defmodule GalliumWeb.UserLive.Registration do
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts
  alias Gallium.Accounts
  alias Gallium.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto w-full max-w-sm my-8 space-y-4 flex flex-1 flex-col justify-center">
        <div class="text-center font-cormorant">
          <.header>
            <div class="text-3xl">
              Regista a tua conta
            </div>
            <:subtitle>
              Já resgistado?
              <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
                Log in
              </.link>
              na tua conta.
            </:subtitle>
          </.header>
        </div>
        <div class="w-full">
          <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
            <.input
              field={@form[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              spellcheck="false"
              required
              placeholder="exemplo@gmail.com"
              phx-mounted={JS.focus()}
            />

            <.primary_button
              phx-disable-with="Creating account..."
              text="Criar conta"
              color={:blue}
              class="font-cormorant"
            />
          </.form>
        </div>
      </div>
    </.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: GalliumWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
