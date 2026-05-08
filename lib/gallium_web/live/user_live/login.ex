defmodule GalliumWeb.UserLive.Login do
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts
  alias Gallium.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto w-full max-w-sm my-8 px-4 space-y-4 flex flex-1 flex-col justify-center">
        <div class="text-center font-cormorant">
          <.header subtitle_class="text-base font-cormorant text-blue/60">
            <p class="text-5xl">Entrar</p>
            <:subtitle>
              <%= if @current_scope do %>
                Precisas de te reautenticar para fazer ações sensíveis
              <% else %>
                Não tens conta? <.link
                  navigate={~p"/users/register"}
                  class="font-semibold text-blue hover:text-blue/70 underline"
                  phx-no-format
                >Regista-te aqui</.link>
              <% end %>
            </:subtitle>
          </.header>
        </div>

        <div :if={local_mail_adapter?()} class="alert alert-info">
          <.icon name="hero-information-circle" class="size-6 shrink-0" />
          <div>
            <p>You are running the local mail adapter.</p>
            <p>
              To see sent emails, visit <.link href="/dev/mailbox" class="underline">the mailbox page</.link>.
            </p>
          </div>
        </div>
        <.form
          :let={f}
          for={@form}
          id="login_form_magic"
          action={~p"/users/log-in"}
          phx-submit="submit_magic"
        >
          <.input
            readonly={!!@current_scope}
            field={f[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            spellcheck="false"
            required
            phx-mounted={JS.focus()}
          />
          <.primary_button
            class="font-cormorant"
            color={:blue}
            text="Entrar com email"
            icon="hero-arrow-right"
            iconpos={:right}
          />
        </.form>

        <div class="divider font-cormorant">ou</div>

        <.form
          :let={f}
          for={@form}
          id="login_form_password"
          action={~p"/users/log-in"}
          phx-submit="submit_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            readonly={!!@current_scope}
            field={f[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            spellcheck="false"
            required
          />
          <.input
            field={@form[:password]}
            type="password"
            label="Password"
            autocomplete="current-password"
            spellcheck="false"
          />
          <div class="flex flex-col gap-3">
            <.primary_button
              class="font-cormorant"
              color={:blue}
              text="Mantém-me logado neste dispositivo"
              name={@form[:remember_me].name}
              value="true"
              icon="hero-arrow-right"
              iconpos={:right}
            />
            <.primary_button
              class="font-cormorant"
              color={:blue}
              text="Entrar apenas desta vez"
            />
          </div>
        </.form>
      </div>
    </.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "Se o teu email estiver no nosso sistema, receberás instruções para entrar em breve."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:gallium, Gallium.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
