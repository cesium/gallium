defmodule GalliumWeb.Components.Navbar do
  @moduledoc """
  Navbar Component.
  """
  use Phoenix.Component
  use GalliumWeb, :verified_routes
  alias Gallium.Accounts
  alias Phoenix.LiveView.JS

  import GalliumWeb.Components.Button
  import GalliumWeb.CoreComponents

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :landing_pages, :list, default: [], doc: "List of landing pages for the navbar navigation"
  attr :class, :any, default: nil, doc: "The navbar class to use over defaults"
  attr :current_scope, :map, default: nil, doc: "The current scope/user session"

  def navbar(assigns) do
    ~H"""
    <header class={"w-full h-fit bg-blue text-beige/80 px-4 py-3 z-30 sticky top-0 border-b-1 border-beige/20 #{@class}"}>
      <div class="max-w-7xl mx-auto flex items-center justify-between gap-4">
        <div class="flex-1 min-w-max">
          <.link navigate="/">
            <p class="font-amarante text-light-muted text-xl md:text-2xl">
              Jantar de Gala
            </p>
          </.link>
        </div>
        <nav class="hidden lg:flex flex-wrap gap-x-4 md:gap-x-10 justify-center font-cormorant text-sm uppercase tracking-wider text-beige/60">
          <%= for page <- @landing_pages do %>
            <.link navigate={page.url} class="hover:text-light-muted transition-colors">
              {page.name}
            </.link>
          <% end %>
        </nav>

        <div class="flex-1 flex min-w-max justify-end items-center gap-4">
          <div class="hidden lg:flex items-center gap-4 text-xs font-cormorant uppercase tracking-wider text-beige/80 mr-3">
            <%= if @current_scope do %>
              <.link href={~p"/users/settings"} class="hover:text-light-muted transition-colors">
                Definições
              </.link>
              <.link
                href={~p"/users/log-out"}
                method="delete"
                class="hover:text-light-muted transition-colors"
              >
                Sair
              </.link>
            <% else %>
              <.link href={~p"/users/register"} class="hover:text-light-muted transition-colors">
                Regista-te
              </.link>
              <.link href={~p"/users/log-in"} class="hover:text-light-muted transition-colors">
                Entrar
              </.link>
            <% end %>
          </div>

          <div class="hidden lg:flex flex-row gap-4">
            <.primary_button
              text="Comprar Bilhetes"
              link="/bilhetes"
              color={:light_muted}
              text_color={:blue}
              class="px-4 md:px-6 py-1 font-cormorant font-semibold uppercase text-xs tracking-wider"
            />
            <%= if @current_scope do %>
              <.link href="/user/profile">
                <.icon name="hero-user-circle" class="text-beige size-7" />
              </.link>
            <% end %>
            <%= if @current_scope && Accounts.admin?(@current_scope.user) do %>
              <.link href="/backoffice">
                <span class="text-xs font-cormorant uppercase tracking-wider text-beige/80 hover:text-light-muted transition-colors">
                  Backoffice
                </span>
              </.link>
            <% end %>
          </div>

          <button type="button" class="lg:hidden p-2" phx-click={show_mobile_navbar()}>
            <.icon name="hero-bars-3" class="text-beige" />
          </button>
        </div>
      </div>

      <div
        id="mobile-navbar"
        class="fixed inset-0 z-40 bg-blue hidden flex-col"
      >
        <div class="flex flex-col h-full overflow-hidden">
          <div class={"flex items-center #{if @current_scope, do: "justify-between", else: "justify-end"} px-6 py-4 border-b border-beige/10 flex-shrink-0"}>
            <%= if @current_scope do %>
              <.link
                href="/user/profile"
                phx-click={hide_mobile_navbar()}
                class="flex items-center gap-2"
              >
                <.icon name="hero-user-circle" class="text-beige size-6" />
                <span class="text-xs font-cormorant uppercase tracking-wider text-beige/70">
                  Perfil
                </span>
              </.link>
              <%= if Accounts.admin?(@current_scope.user) do %>
                <.link href="/backoffice">
                  <span class="text-xs font-cormorant uppercase tracking-wider text-beige/70 hover:text-light-muted transition-colors">
                    Backoffice
                  </span>
                </.link>
              <% end %>
            <% end %>
            <button type="button" phx-click={hide_mobile_navbar()} class="p-1">
              <.icon name="hero-x-mark" class="text-beige size-6" />
            </button>
          </div>

          <nav class="flex flex-col items-center justify-center gap-6 flex-1 overflow-y-auto py-8 font-cormorant font-semibold text-2xl text-beige/80">
            <.link
              navigate="/"
              phx-click={hide_mobile_navbar()}
              class="font-amarante text-light-muted text-xl mb-2"
            >
              Jantar de Gala
            </.link>
            <%= for page <- @landing_pages do %>
              <.link
                navigate={page.url}
                phx-click={hide_mobile_navbar()}
                class="hover:text-white transition-colors"
              >
                {page.name}
              </.link>
            <% end %>

            <div class="w-8 h-px bg-beige/20 my-2"></div>

            <%= if @current_scope do %>
              <.link
                href={~p"/users/settings"}
                phx-click={hide_mobile_navbar()}
                class="text-lg text-beige/60 hover:text-white transition-colors"
              >
                Definições
              </.link>
              <.link
                href={~p"/users/log-out"}
                method="delete"
                class="text-lg text-beige/60 hover:text-white transition-colors"
              >
                Terminar sessão
              </.link>
            <% else %>
              <.link
                href={~p"/users/register"}
                phx-click={hide_mobile_navbar()}
                class="text-lg text-beige/60 hover:text-white transition-colors"
              >
                Registar
              </.link>
              <.link
                href={~p"/users/log-in"}
                phx-click={hide_mobile_navbar()}
                class="text-lg text-beige/60 hover:text-white transition-colors"
              >
                Entrar
              </.link>
            <% end %>

            <div class="mt-4">
              <.primary_button
                text="Comprar Bilhetes"
                link="/bilhetes"
                color={:light_muted}
                text_color={:blue}
                class="px-8 py-2 font-cormorant font-semibold uppercase text-base tracking-wider"
              />
            </div>
          </nav>
        </div>
      </div>
    </header>
    """
  end

  def show_mobile_navbar(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#mobile-navbar",
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"},
      display: "flex"
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_mobile_navbar(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#mobile-navbar",
      transition:
        {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
    |> JS.remove_class("overflow-hidden", to: "body")
  end
end
