defmodule GalliumWeb.TicketingPurchaseLive.Index do
  use Phoenix.Component
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Stepper
  import GalliumWeb.Components.Button

  alias Gallium.Ticketing.CheckoutForm
  alias Gallium.Ticketing

  embed_templates "steps/*"

  @impl true
  def mount(params, _session, socket) do
    # takes the type of the ticket from the url
    is_cesium_member? = Map.get(params, "tipo", "nao_socio") == "socio"

    initial_changeset =
      CheckoutForm.changeset_fase1(%CheckoutForm{is_cesium_member: is_cesium_member?}, %{})

    price_per_ticket = if is_cesium_member?, do: 25, else: 30

    {:ok,
     socket
     |> assign(:current_step, 1)
     |> assign(:form_data, to_form(initial_changeset))
     |> assign(:has_accompany?, false)
     |> assign(:amount_to_pay, nil)
     |> assign(:price_per_ticket, price_per_ticket)}
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    {:noreply, update(socket, :current_step, &(&1 + 1))}
  end

  @impl true
  def handle_event("previous_step", _params, socket) do
    {:noreply, update(socket, :current_step, &(&1 - 1))}
  end

  def handle_event("toggle_accompany", _, socket) do
    has_accompany? = !socket.assigns.has_accompany?
    params = socket.assigns.form_data.params || %{}

    changeset = CheckoutForm.changeset_fase1(socket.assigns.form_data.data, params)

    {:noreply,
     socket
     |> assign(:has_accompany?, has_accompany?)
     |> assign(:form_data, to_form(changeset))}
  end

  def handle_event("save_draft_form_info_step1", %{"checkout_form" => form_params}, socket) do
    changeset = CheckoutForm.changeset_fase1(socket.assigns.form_data.data, form_params)
    changeset_with_error_info = Map.put(changeset, :action, :validate)

    {:noreply, assign(socket, :form_data, to_form(changeset_with_error_info))}
  end

  def handle_event("save_step1", %{"checkout_form" => form_data}, socket) do
    changeset = CheckoutForm.changeset_fase1(socket.assigns.form_data.data, form_data)

    if changeset.valid? do
      amount_to_pay =
        if socket.assigns.has_accompany? do
          socket.assigns.price_per_ticket * 2
        else
          socket.assigns.price_per_ticket
        end

      new_data = Ecto.Changeset.apply_changes(changeset)
      new_changeset = CheckoutForm.changeset_fase1(new_data, %{})

      {:noreply,
       socket
       |> assign(:form_data, to_form(new_changeset))
       |> assign(:amount_to_pay, amount_to_pay)
       |> update(:current_step, &(&1 + 1))}
    else
      changeset_com_erros = Map.put(changeset, :action, :validate)
      {:noreply, assign(socket, :form_data, to_form(changeset_com_erros))}
    end
  end

  def handle_event("save_draft_form_info_step3", %{"checkout_form" => form_params}, socket) do
    changeset = CheckoutForm.changeset_fase3(socket.assigns.form_data.data, form_params)
    changeset_with_error_info = Map.put(changeset, :action, :validate)

    {:noreply, assign(socket, :form_data, to_form(changeset_with_error_info))}
  end

  def handle_event("save_step3", %{"checkout_form" => form_data}, socket) do
    changeset = CheckoutForm.changeset_fase3(socket.assigns.form_data.data, form_data)

    if changeset.valid? do
      final_data = Ecto.Changeset.apply_changes(changeset)

      case Ticketing.process_ticket_purchase(
             final_data,
             socket.assigns.amount_to_pay,
             socket.assigns.has_accompany?
           ) do
        {:ok, _bd_result} ->
          # Success
          IO.puts("✅ SUCESSO! GRAVOU NA BD!")
          new_changeset = CheckoutForm.changeset_fase3(final_data, %{})

          {:noreply,
           socket
           |> assign(:form_data, to_form(new_changeset))
           |> update(:current_step, &(&1 + 1))}

        {:error, _operation, _errors, _alterations} ->
          # DataBase error

          {:noreply,
           put_flash(socket, :error, "Ocorreu um erro ao guardar o bilhete. Tenta novamente.")}
      end
    else
      IO.puts("✅Erro na validacao \n\n\n\n")
      changeset_com_erros = Map.put(changeset, :action, :validate)
      {:noreply, assign(socket, :form_data, to_form(changeset_com_erros))}
    end
  end
end
