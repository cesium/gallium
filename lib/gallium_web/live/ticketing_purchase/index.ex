defmodule GalliumWeb.TicketingPurchaseLive.Index do
  use Phoenix.Component
  use GalliumWeb, :app_view
  import GalliumWeb.Components.{Button, Stepper}

  alias Gallium.Accounts
  alias Gallium.Ticketing
  alias Gallium.Ticketing.{CheckoutForm, TicketType}

  embed_templates "steps/*"

  @impl true
  def mount(params, _session, socket) do
    # takes the type of the ticket from the url
    is_cesium_member? = Map.get(params, "tipo", "nao_socio") == "socio"

    user_info =
      case Accounts.get_user_info_by_id(socket.assigns.current_scope.user.id) do
        {:ok, attendee} -> attendee
        {:error, nil} -> nil
      end

    initial_changeset =
      CheckoutForm.changeset_personal_data(
        %CheckoutForm{is_cesium_member: is_cesium_member?},
        %{}
      )

    price_per_ticket =
      if is_cesium_member?,
        do: TicketType.price_for_member(),
        else: TicketType.price_for_non_member()

    {:ok,
     socket
     |> assign(:current_step, 1)
     |> assign(:form_data, to_form(initial_changeset))
     |> assign(:has_accompany?, false)
     |> assign(:amount_to_pay, nil)
     |> assign(:price_per_ticket, price_per_ticket)
     |> assign(:companion_price, price_per_ticket)
     |> assign(:payment_status, :pending)
     |> assign(:user_info, user_info)}
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    {:noreply, update(socket, :current_step, &(&1 + 1))}
  end

  @impl true
  def handle_event("previous_step", _params, socket) do
    {:noreply, update(socket, :current_step, &max(&1 - 1, 1))}
  end

  @impl true
  def handle_event("to_tickets", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/bilhetes")}
  end

  @impl true
  def handle_event("to_home", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/")}
  end

  def handle_event("toggle_accompany", _, socket) do
    has_accompany? = !socket.assigns.has_accompany?
    params = socket.assigns.form_data.params || %{}

    changeset = CheckoutForm.changeset_personal_data(socket.assigns.form_data.data, params)
    is_member = Ecto.Changeset.get_field(changeset, :is_cesium_member)

    price_per_ticket =
      if is_member, do: TicketType.price_for_member(), else: TicketType.price_for_non_member()

    {:noreply,
     socket
     |> assign(:has_accompany?, has_accompany?)
     |> assign(:price_per_ticket, price_per_ticket)
     |> assign(:companion_price, price_per_ticket)
     |> assign(:form_data, to_form(changeset))}
  end

  def handle_event("save_draft_form_info_step1", %{"checkout_form" => form_params}, socket) do
    changeset = CheckoutForm.changeset_personal_data(socket.assigns.form_data.data, form_params)
    changeset_with_error_info = Map.put(changeset, :action, :validate)

    is_member = Ecto.Changeset.get_field(changeset, :is_cesium_member)

    price_per_ticket =
      if is_member, do: TicketType.price_for_member(), else: TicketType.price_for_non_member()

    {:noreply,
     socket
     |> assign(:price_per_ticket, price_per_ticket)
     |> assign(:companion_price, price_per_ticket)
     |> assign(:form_data, to_form(changeset_with_error_info))}
  end

  def handle_event("save_step1", %{"checkout_form" => form_data}, socket) do
    changeset = CheckoutForm.changeset_personal_data(socket.assigns.form_data.data, form_data)
    is_member = Ecto.Changeset.get_field(changeset, :is_cesium_member)

    price_per_ticket =
      if is_member, do: TicketType.price_for_member(), else: TicketType.price_for_non_member()

    if changeset.valid? do
      amount_to_pay =
        if socket.assigns.has_accompany?,
          do: price_per_ticket * 2,
          else: price_per_ticket

      new_data = Ecto.Changeset.apply_changes(changeset)
      new_changeset = CheckoutForm.changeset_personal_data(new_data, %{})

      {:noreply,
       socket
       |> assign(:price_per_ticket, price_per_ticket)
       |> assign(:companion_price, price_per_ticket)
       |> assign(:form_data, to_form(new_changeset))
       |> assign(:amount_to_pay, amount_to_pay)
       |> update(:current_step, &(&1 + 1))}
    else
      changeset_com_erros = Map.put(changeset, :action, :validate)

      {:noreply,
       socket
       |> assign(:price_per_ticket, price_per_ticket)
       |> assign(:companion_price, price_per_ticket)
       |> assign(:form_data, to_form(changeset_com_erros))}
    end
  end

  def handle_event("save_draft_form_info_step3", %{"checkout_form" => form_params}, socket) do
    changeset = CheckoutForm.changeset_payment(socket.assigns.form_data.data, form_params)
    changeset_with_error_info = Map.put(changeset, :action, :validate)

    {:noreply, assign(socket, :form_data, to_form(changeset_with_error_info))}
  end

  def handle_event("save_step3", %{"checkout_form" => form_data}, socket) do
    changeset = CheckoutForm.changeset_payment(socket.assigns.form_data.data, form_data)

    if changeset.valid? do
      process_step3(socket, Ecto.Changeset.apply_changes(changeset))
    else
      {:noreply, assign(socket, :form_data, to_form(Map.put(changeset, :action, :validate)))}
    end
  end

  defp process_step3(socket, final_data) do
    user = socket.assigns.current_scope.user

    with {:ok, attendee} <-
           get_or_create_attendee(user.id, final_data, socket.assigns.has_accompany?),
         {:ok, payment} <-
           Ticketing.start_payment(
             :mbway,
             attendee,
             user,
             final_data,
             socket.assigns.amount_to_pay,
             socket.assigns.has_accompany?
           ) do
      if connected?(socket) do
        Ticketing.subscribe_to_payment_order_updates(payment.order_id)
      end

      new_changeset = CheckoutForm.changeset_payment(final_data, %{})

      {:noreply,
       socket
       |> assign(:form_data, to_form(new_changeset))
       |> assign(:payment_status, :pending)
       |> update(:current_step, &(&1 + 1))}
    else
      {:error, :booking_failed} ->
        {:noreply,
         put_flash(socket, :error, "Ocorreu um erro ao guardar o bilhete. Tenta novamente.")}

      {:error, reason} ->
        {:noreply,
         put_flash(
           socket,
           :error,
           "Erro ao iniciar pagamento MBWay: #{inspect(reason)}. Tenta novamente."
         )}
    end
  end

  defp get_or_create_attendee(user_id, final_data, has_accompany?) do
    case Ticketing.get_attendee_by_user_id(user_id) do
      nil ->
        case Ticketing.create_booking(final_data, has_accompany?, user_id) do
          {:ok, %{attendee: attendee}} -> {:ok, attendee}
          {:error, _op, _errors, _} -> {:error, :booking_failed}
        end

      attendee ->
        {:ok, attendee}
    end
  end

  def handle_info({:payment_order_updated, payment}, socket) do
    {:noreply, assign(socket, :payment_status, payment.status)}
  end
end
