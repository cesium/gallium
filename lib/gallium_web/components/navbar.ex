defmodule GalliumWeb.Components.Navbar do
  @moduledoc """
  Navbar Component.
  """
  use Phoenix.Component
  use GalliumWeb, :verified_routes
  alias Gallium.Accounts.User
  alias Phoenix.LiveView.JS

  import GalliumWeb.Components.Button
  import GalliumWeb.CoreComponents

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :landing_pages, :list, default: [], doc: "List of landing pages for the navbar navigation"
  attr :class, :any, default: nil, doc: "The navbar class to use over defaults"
  attr :current_scope, :map, default: nil, doc: "The current scope/user session"

  def navbar(assigns) do
    ~H"""
    <header class={"w-full h-fit bg-beige text-blue-800/80 px-4 py-3 z-30 sticky top-0 border-b-1 border-olive-800/20 #{@class}"}>
      <div class="max-w-7xl mx-auto flex items-center justify-between tracking-widest gap-4">
        <div class="flex-1 min-w-max">
          <.link navigate="/">
            <p class="font-amarante text-blue-500 text-xl md:text-2xl uppercase">
              jantar de gala
            </p>
          </.link>
        </div>
        <nav class="hidden lg:flex flex-wrap gap-x-4 md:gap-x-10 justify-center uppercase font-amarante text-blue-800/60">
          <%= for page <- @landing_pages do %>
            <.link navigate={page.url} class="hover:text-blue-500 transition-colors">
              {page.name}
            </.link>
          <% end %>
        </nav>

        <div class="flex-1 flex min-w-max justify-end items-center gap-4">
          <div class="hidden lg:flex items-center gap-4 text-xs font-amarante uppercase text-blue mr-3">
            <%= if @current_scope do %>
              <.link href={~p"/users/settings"} class="hover:text-blue-500 transition-colors">
                Settings
              </.link>
              <.link
                href={~p"/users/log-out"}
                method="delete"
                class="hover:text-blue-500 transition-colors"
              >
                Log out
              </.link>
            <% else %>
              <.link href={~p"/users/register"} class="hover:text-blue-500 transition-colors">
                Regista-te
              </.link>
              <.link href={~p"/users/log-in"} class="hover:text-blue-500 transition-colors">
                Log in
              </.link>
            <% end %>
          </div>

          <div class="hidden lg:flex flex-row gap-4">
            <.primary_button
              text="Comprar Bilhetes"
              link="/bilhetes"
              color={:blue}
              text_color={:auto}
              class="bg-blue-500 text-beige px-4 md:px-6 py-1 font-amarante font-bold uppercase text-xs"
            />
            <%= if @current_scope do %>
              <.link href="/user/profile">
                <.icon name="hero-user-circle" class="bg-blue-500 px-4 md:px-6 py-1 size-7" />
              </.link>
            <% end %>
            <%= if @current_scope && User.admin?(@current_scope.user) do %>
              <.link href="/backoffice">
                <span class="text-xs font-amarante uppercase text-blue hover:text-blue-500 transition-colors">
                  Backoffice
                </span>
              </.link>
            <% end %>
          </div>

          <button type="button" class="lg:hidden p-2" phx-click={show_mobile_navbar()}>
            <.icon name="hero-bars-3" class="text-blue-500" />
          </button>
        </div>
      </div>

      <div
        id="mobile-navbar"
        class="fixed inset-0 z-40 bg-beige hidden flex-col"
      >
        <div class="flex flex-col h-full">
          <div class={"flex #{if @current_scope, do: "justify-between", else: "justify-end"} p-6"}>
            <%= if @current_scope do %>
              <.link href="/user/profile">
                <.icon name="hero-user-circle" class="bg-blue-500 px-4 md:px-6 py-1 size-7" />
              </.link>
              <%= if User.admin?(@current_scope.user) do %>
                <.link href="/backoffice">
                  <span class="text-xs font-amarante uppercase text-blue hover:text-blue-500 transition-colors">
                    Backoffice
                  </span>
                </.link>
              <% end %>
            <% end %>
            <button type="button" phx-click={hide_mobile_navbar()}>
              <.icon name="hero-x-mark" class="text-blue-500" />
            </button>
          </div>

          <nav class="flex flex-col items-center gap-8 mt-10 uppercase font-cormorant font-bold text-2xl text-blue-800/80">
            <%= for page <- @landing_pages do %>
              <.link navigate={page.url} phx-click={hide_mobile_navbar()} class="hover:text-blue-500">
                {page.name}
              </.link>
            <% end %>

            <%= if @current_scope do %>
              <div class="flex flex-row gap-10 ">
                <.link
                  href={~p"/users/settings"}
                  phx-click={hide_mobile_navbar()}
                  class="hover:text-blue-500"
                >
                  Settings
                </.link>
                <.link href={~p"/users/log-out"} method="delete" class="hover:text-blue-500">
                  Log out
                </.link>
              </div>
            <% else %>
              <div class="flex flex-row gap-5 ">
                <.link
                  href={~p"/users/register"}
                  phx-click={hide_mobile_navbar()}
                  class="hover:text-blue-500 "
                >
                  Regista-te
                </.link>
                <.link
                  href={~p"/users/log-in"}
                  phx-click={hide_mobile_navbar()}
                  class="hover:text-blue-500 "
                >
                  Log in
                </.link>
              </div>
            <% end %>

            <div class="mt-4">
              <.primary_button
                text="Comprar Bilhetes"
                link="/bilhetes"
                color={:blue}
                text_color={:auto}
                class="bg-blue-500 text-beige px-8 py-2 font-amarante font-bold uppercase text-lg"
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
