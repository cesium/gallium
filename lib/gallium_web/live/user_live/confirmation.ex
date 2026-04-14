defmodule GalliumWeb.UserLive.Confirmation do
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts
  alias Gallium.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-lg py-12 px-4 sm:px-6">
        <div class="text-7xl text-center mb-10 flex flex-col gap-2 text-olive font-cormorant">
          <h1>Bem Vindo</h1>
          <p class="text-gray-500 font-sans text-sm tracking-wide">{@user.email}</p>
        </div>

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

          <div class="flex flex-col gap-4">
            <.primary_button
              name={@form[:remember_me].name}
              value="true"
              phx-disable-with="A confirmar..."
              text="Confirmar e ficar logado"
              class="font-cormorant text-lg py-3"
            />
            <.primary_button
              text="Confirmar e ficar logado apenas desta vez"
              phx-disable-with="A confirmar..."
              class="font-cormorant text-lg py-3 "
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
          <div class="flex flex-col gap-4 mt-4">
            <%= if @current_scope do %>
              <.primary_button
                phx-disable-with="Logging in..."
                text="Log in"
                class="font-cormorant text-lg py-3 shadow-md"
              />
            <% else %>
              <.primary_button
                name={@form[:remember_me].name}
                value="true"
                phx-disable-with="Logging in..."
                text="Mantém-me logado neste dispositivo"
                class="font-cormorant text-lg py-3 shadow-md"
              />
              <.primary_button
                text="Mantém-me logado apenas desta vez"
                phx-disable-with="Logging in..."
                class="font-cormorant text-lg py-3 opacity-80 hover:opacity-100"
              />
            <% end %>
          </div>
        </.form>

        <div
          :if={!@user.confirmed_at}
          class="mt-10 p-5 bg-blue-50 rounded-xl border border-olive text-center font-amarante flex flex-col gap-1 text-gray-600"
        >
          <span class="text-blue-800 font-bold tracking-widest uppercase text-xs">Dica</span>
          <span class="text-base">
            Se preferires logar com palavra-passe, podes definir a tua nas "Settings".
          </span>
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
       |> put_flash(:error, "Magic link is invalid or it has expired.")
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end
