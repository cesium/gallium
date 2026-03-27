defmodule GalliumWeb.Components.Navbar do
  @moduledoc """
  Navbar Component.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  import GalliumWeb.Components.Button
  import GalliumWeb.CoreComponents

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :landing_pages, :list, default: [], doc: "List of landing pages for the navbar navigation"
  attr :class, :any, default: nil, doc: "The navbar class to use over defaults"

  def navbar(assigns) do
    ~H"""
    <header class={"w-full h-fit bg-beige text-blue-800/80 px-4 py-3 z-30 relative #{@class}"}>
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
          <div class="hidden lg:flex">
            <.primary_button
              text="comprar bilhetes"
              link={@ticket_url}
              color={:blue}
              text_color={:auto}
              class="bg-blue-500 text-beige px-4 md:px-6 py-1 font-amarante font-bold uppercase text-xs"
            />
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
          <div class="flex justify-end p-6">
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

            <div class="mt-4">
              <.primary_button
                text="comprar bilhetes"
                link={@ticket_url}
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
