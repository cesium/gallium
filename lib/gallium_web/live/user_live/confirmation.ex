defmodule GalliumWeb.UserLive.Confirmation do
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts
  alias Gallium.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="grow flex flex-col items-center justify-center px-4 py-16">
        <div class="w-full max-w-sm text-center">
          <p class="text-bronze font-amarante text-4xl mb-4">✳</p>
          <h1 class="text-5xl font-amarante text-blue uppercase tracking-widest mb-2">
            Bem-Vindo
          </h1>
          <div class="w-10 h-0.5 bg-bronze mx-auto my-4"></div>
          <p class="font-cormorant text-gray-500 text-lg mb-10">{@user.email}</p>

          <.form
            :if={!@user.confirmed_at}
            for={@form}
            id="confirmation_form"
            phx-mounted={JS.focus_first()}
            phx-submit="submit"
            action={~p"/users/log-in?_action=confirmed"}
            phx-trigger-action={@trigger_submit}
          >
            <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
            <div class="flex flex-col gap-3">
              <.primary_button
                name={@form[:remember_me].name}
                value="true"
                phx-disable-with="A confirmar..."
                text="Confirmar e manter sessão iniciada neste dispositivo"
                class="font-cormorant text-lg py-3"
                color={:blue}
              />
              <.primary_button
                text="Confirmar apenas desta vez"
                phx-disable-with="A confirmar..."
                class="font-cormorant text-lg py-3 opacity-80 hover:opacity-100"
                color={:blue}
              />
            </div>
          </.form>

          <.form
            :if={@user.confirmed_at}
            for={@form}
            id="login_form"
            phx-submit="submit"
            phx-mounted={JS.focus_first()}
            action={~p"/users/log-in"}
            phx-trigger-action={@trigger_submit}
          >
            <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
            <div class="flex flex-col gap-3">
              <%= if @current_scope do %>
                <.primary_button
                  phx-disable-with="A entrar..."
                  text="Entrar na conta"
                  class="font-cormorant text-lg py-3"
                  color={:blue}
                />
              <% else %>
                <.primary_button
                  name={@form[:remember_me].name}
                  value="true"
                  phx-disable-with="A entrar..."
                  text="Manter sessão iniciada neste dispositivo"
                  class="font-cormorant text-lg py-3"
                  color={:blue}
                />
                <.primary_button
                  text="Apenas desta vez"
                  phx-disable-with="A entrar..."
                  class="font-cormorant text-lg py-3 opacity-80 hover:opacity-100"
                  color={:blue}
                />
              <% end %>
            </div>
          </.form>

          <div
            :if={!@user.confirmed_at}
            class="mt-8 p-4 bg-white rounded-lg border border-gray-100 text-center font-cormorant text-gray-500 text-base"
          >
            Podes definir uma palavra-passe nas
            <a href={~p"/users/settings"} class="text-olive underline-offset-2 hover:underline">
              definições
            </a>
            da tua conta.
          </div>
        </div>
      </div>
    </.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_magic_link_token(token) do
      form = to_form(%{"token" => token}, as: "user")

      {:ok, assign(socket, user: user, form: form, trigger_submit: false),
       temporary_assigns: [form: nil]}
    else
      {:ok,
       socket
       |> put_flash(:error, "O link é inválido ou expirou.")
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end
