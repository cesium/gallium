defmodule GalliumWeb.Components.Navbar do
  @moduledoc """
  Navbar Component.
  """
  use Phoenix.Component

  import GalliumWeb.Components.Button

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :landing_pages, :list, default: [], doc: "List of landing pages for the navbar navigation"
  attr :class, :any, default: nil, doc: "The navbar class to use over defaults"

  def navbar(assigns) do
    ~H"""
    <header class={"w-full h-fit bg-beige text-blue-800/80 px-4 py-3 #{@class}"}>
      <div class="max-w-7xl mx-auto flex items-center justify-between tracking-widest gap-4">
        <div class="flex-1 min-w-max">
          <.link href="/">
            <p class="font-amarante text-blue-500 text-xl md:text-2xl uppercase cursor-pointer">
              jantar de gala
            </p>
          </.link>
        </div>

        <nav class="flex flex-wrap gap-x-4 md:gap-x-10 justify-center uppercase font-cormorant font-bold text-[10px] md:text-xs">
          <%= for page <- @landing_pages do %>
            <.link navigate={page.url} class="hover:text-blue-500 transition-colors">
              {page.name}
            </.link>
          <% end %>
        </nav>

        <div class="flex-1 flex min-w-max justify-end">
          <.primary_button
            text="comprar bilhetes"
            link={@ticket_url}
            color={:blue}
            text_color={:auto}
            class="bg-blue-500 text-beige! px-4 md:px-6 py-1 font-amarante font-bold uppercase text-[10px] md:text-xs"
          />
        </div>
      </div>
    </header>
    """
  end
end
