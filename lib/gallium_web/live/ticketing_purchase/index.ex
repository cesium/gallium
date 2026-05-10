defmodule GalliumWeb.TicketingPurchaseLive.Index do
  use Phoenix.Component
  use GalliumWeb, :app_view
  import GalliumWeb.Components.{Button, Stepper}

  alias Gallium.Ticketing
  alias Gallium.Ticketing.{CheckoutForm, TicketType}

  embed_templates "steps/*"

  @impl true
  def mount(params, _session, socket) do
    # takes the type of the ticket from the url
    is_cesium_member? = Map.get(params, "type", "nao_socio") == "socio"
    user_id = socket.assigns.current_scope.user.id
    purchase = Ticketing.get_purchase_by_user_id(user_id)

    socket =
      case purchase_state(purchase) do
        {:blocked, attendee} ->
          assign_blocked_purchase(socket, attendee, is_cesium_member?)

        {:resume, attendee} ->
          assign_resumable_purchase(socket, attendee)

        :new ->
          assign_new_purchase(socket, is_cesium_member?)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    {:noreply, update(socket, :current_step, &(&1 + 1))}
  end

  @impl true
  def handle_event("previous_step", _params, %{assigns: %{resuming_purchase?: true}} = socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("previous_step", _params, socket) do
    {:noreply, update(socket, :current_step, &max(&1 - 1, 1))}
  end

  @impl true
  def handle_event("to_tickets", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/tickets")}
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

  @impl true
  def handle_info({:payment_order_updated, payment}, socket) do
    {:noreply, assign(socket, :payment_status, payment.status)}
  end

  defp purchase_state(%{attendee: %{payment: %{status: :paid}} = attendee}) do
    {:blocked, attendee}
  end

  defp purchase_state(%{attendee: attendee}) when not is_nil(attendee) do
    {:resume, attendee}
  end

  defp purchase_state(_purchase), do: :new

  defp assign_new_purchase(socket, is_cesium_member?) do
    initial_changeset =
      CheckoutForm.changeset_personal_data(
        %CheckoutForm{is_cesium_member: is_cesium_member?},
        %{}
      )

    price_per_ticket = price_per_ticket(is_cesium_member?)

    socket
    |> assign(:current_step, 1)
    |> assign(:form_data, to_form(initial_changeset))
    |> assign(:has_accompany?, false)
    |> assign(:amount_to_pay, nil)
    |> assign(:price_per_ticket, price_per_ticket)
    |> assign(:companion_price, price_per_ticket)
    |> assign(:payment_status, :pending)
    |> assign(:purchase_blocked?, false)
    |> assign(:resuming_purchase?, false)
    |> assign(:user_info, nil)
  end

  defp assign_resumable_purchase(socket, attendee) do
    if connected?(socket) && attendee.payment && attendee.payment.status == :pending do
      Ticketing.subscribe_to_payment_order_updates(attendee.payment.order_id)
    end

    has_accompany? = not is_nil(attendee.accompany)
    price_per_ticket = price_per_ticket(attendee.is_cesium_member)
    amount_to_pay = existing_amount_to_pay(attendee, price_per_ticket, has_accompany?)
    checkout_form = checkout_form_from_attendee(attendee)
    payment_changeset = CheckoutForm.changeset_payment(checkout_form, %{})

    socket
    |> assign(:current_step, 3)
    |> assign(:form_data, to_form(payment_changeset))
    |> assign(:has_accompany?, has_accompany?)
    |> assign(:amount_to_pay, amount_to_pay)
    |> assign(:price_per_ticket, price_per_ticket)
    |> assign(:companion_price, price_per_ticket)
    |> assign(:payment_status, payment_status(attendee))
    |> assign(:purchase_blocked?, false)
    |> assign(:resuming_purchase?, true)
    |> assign(:user_info, attendee)
  end

  defp assign_blocked_purchase(socket, attendee, is_cesium_member?) do
    price_per_ticket = price_per_ticket(is_cesium_member?)

    socket
    |> assign(:current_step, 1)
    |> assign(:form_data, to_form(CheckoutForm.changeset_personal_data(%CheckoutForm{}, %{})))
    |> assign(:has_accompany?, false)
    |> assign(:amount_to_pay, attendee.payment.amount)
    |> assign(:price_per_ticket, price_per_ticket)
    |> assign(:companion_price, price_per_ticket)
    |> assign(:payment_status, :paid)
    |> assign(:purchase_blocked?, true)
    |> assign(:resuming_purchase?, false)
    |> assign(:user_info, attendee)
  end

  defp checkout_form_from_attendee(attendee) do
    %CheckoutForm{
      full_name: attendee.full_name,
      student_number: attendee.student_number,
      phone_number: attendee.phone_number,
      nif: attendee.nif,
      is_cesium_member: attendee.is_cesium_member,
      wants_transport: attendee.wants_transport,
      table_preference: attendee.table_preference,
      allergies: attendee.allergies,
      accompany: accompany_form_from_attendee(attendee.accompany)
    }
  end

  defp accompany_form_from_attendee(nil), do: nil

  defp accompany_form_from_attendee(accompany) do
    %CheckoutForm.AccompanyForm{
      full_name: accompany.full_name,
      email: accompany.email,
      phone_number: accompany.phone_number
    }
  end

  defp existing_amount_to_pay(%{payment: %{amount: amount}}, _price_per_ticket, _has_accompany?)
       when not is_nil(amount) do
    amount
  end

  defp existing_amount_to_pay(_attendee, price_per_ticket, true), do: price_per_ticket * 2
  defp existing_amount_to_pay(_attendee, price_per_ticket, false), do: price_per_ticket

  defp payment_status(%{payment: %{status: status}}), do: status
  defp payment_status(_attendee), do: :pending

  defp price_per_ticket(true), do: TicketType.price_for_member()
  defp price_per_ticket(false), do: TicketType.price_for_non_member()
end
