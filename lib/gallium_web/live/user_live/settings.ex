defmodule GalliumWeb.UserLive.Settings do
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts
  # Change this to :require_authenticated if you want to remove the Sudo Mode popup!
  on_mount {GalliumWeb.UserAuth, :require_authenticated}

  alias Gallium.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-2xl mx-auto py-12 px-4">
        <div class="text-center mb-10">
          <h1 class="text-5xl font-amarante text-olive uppercase mb-3">Definições</h1>
          <p class="font-cormorant text-gray-500 text-xl">
            Gere o email e a palavra-passe da tua conta
          </p>
        </div>

        <div class="bg-white border border-gray-200 p-8 rounded-lg shadow-sm mb-6">
          <div class="flex items-center gap-3 mb-6">
            <div class="bg-olive/10 rounded-full p-2">
              <.icon name="hero-envelope" class="size-5 text-olive" />
            </div>
            <h2 class="font-amarante text-olive uppercase text-xl">Atualizar Email</h2>
          </div>

          <.form
            for={@email_form}
            id="email_form"
            phx-submit="update_email"
            phx-change="validate_email"
            class="space-y-4"
          >
            <div class="font-cormorant">
              <.input
                field={@email_form[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                spellcheck="false"
                required
              />
            </div>

            <div class="mt-6">
              <.primary_button
                type="submit"
                text="Atualizar Email"
                phx-disable-with="A guardar..."
                class="font-cormorant w-full sm:w-auto"
                color={:blue}
              />
            </div>
          </.form>
        </div>

        <div class="bg-white border border-gray-200 p-8 rounded-lg shadow-sm">
          <div class="flex items-center gap-3 mb-6">
            <div class="bg-olive/10 rounded-full p-2">
              <.icon name="hero-lock-closed" class="size-5 text-olive" />
            </div>
            <h2 class="font-amarante text-olive uppercase text-xl">Atualizar Palavra-Passe</h2>
          </div>

          <.form
            for={@password_form}
            id="password_form"
            action={~p"/users/update-password"}
            method="post"
            phx-change="validate_password"
            phx-submit="update_password"
            phx-trigger-action={@trigger_submit}
            class="space-y-4"
          >
            <input
              name={@password_form[:email].name}
              type="hidden"
              id="hidden_user_email"
              spellcheck="false"
              value={@current_email}
            />

            <div class="font-cormorant">
              <.input
                field={@password_form[:password]}
                type="password"
                label="Nova palavra-passe"
                autocomplete="new-password"
                spellcheck="false"
                required
              />
            </div>

            <div class="font-cormorant">
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label="Confirma a palavra-passe"
                autocomplete="new-password"
                spellcheck="false"
              />
            </div>

            <div class="mt-6">
              <.primary_button
                type="submit"
                text="Guardar Palavra-Passe"
                phx-disable-with="A guardar..."
                class="font-cormorant w-full sm:w-auto"
                color={:blue}
              />
            </div>
          </.form>
        </div>

        <div class="mt-6 text-center">
          <a href={~p"/user/profile"} class="font-cormorant text-gray-400 hover:text-olive text-base transition-colors">
            ← Voltar ao perfil
          </a>
        </div>
      </div>
    </.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_scope.user, token) do
        {:ok, _user} ->
          put_flash(socket, :info, "Email changed successfully.")

        {:error, _} ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    email_changeset = Accounts.change_user_email(user, %{}, validate_unique: false)
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"user" => user_params} = params

    email_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_email(user_params, validate_unique: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.change_user_email(user, user_params) do
      %{valid?: true} = changeset ->
        Accounts.deliver_user_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          user.email,
          &url(~p"/users/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info)}

      changeset ->
        {:noreply, assign(socket, :email_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end
end
