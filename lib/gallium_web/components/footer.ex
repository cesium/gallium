defmodule GalliumWeb.Components.Footer do
  @moduledoc """
  Footer Component.
  """
  use Phoenix.Component

  attr :place_name, :string, default: "", doc: "Event place name"
  attr :date, :string, default: "", doc: "Event date"
  attr :landing_pages, :list, default: [], doc: "List of landing pages for the footer navigation"
  attr :class, :any, default: nil, doc: "The footer class to use over defaults"

  def footer(assigns) do
    ~H"""
    <footer class={"w-full border-t border-beige/20 bg-blue text-beige/80 px-6 py-16 #{@class}"}>
      <div class="max-w-7xl mx-auto flex flex-col">
        <div class="flex flex-col md:flex-row justify-between items-center md:items-baseline mb-12 gap-8">
          <div class="flex-1 text-center md:text-left min-w-max">
            <p class="font-amarante text-light-muted text-3xl">
              Jantar de Gala
            </p>
            <p class="font-cormorant text-xs text-beige/60 tracking-wider mt-2 uppercase">
              Jantar de Gala 2026
            </p>
          </div>

          <nav class="flex flex-wrap gap-10 uppercase font-cormorant text-xs tracking-widest">
            <%= for page <- @landing_pages do %>
              <.link navigate={page.url} class="hover:text-light-muted transition-colors">
                {page.name}
              </.link>
            <% end %>
          </nav>

          <div class="flex-1 text-center md:text-right min-w-max">
            <p class="font-cormorant text-xs tracking-widest uppercase">
              {@place_name}
              <span :if={@place_name != "" and @date != ""}>-</span>
              {@date}
            </p>

            <p class="text-beige/70 text-xs mt-1 font-cormorant tracking-widest">
              Organizado pelo CeSIUM
            </p>
          </div>
        </div>

        <div class="w-full border-t border-beige/20 mb-12"></div>

        <div class="flex justify-center mb-8">
          <div class="w-4 h-4 rounded-full border border-light-muted flex items-center justify-center">
            <div class="w-1.5 h-1.5 rounded-full bg-light-muted"></div>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
