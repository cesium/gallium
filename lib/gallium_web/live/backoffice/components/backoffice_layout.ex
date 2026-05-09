defmodule GalliumWeb.BackOffice.Components.BackofficeLayout do
  @moduledoc false
  use GalliumWeb, :component

  import GalliumWeb.Layouts
  import GalliumWeb.BackOffice.Components.Sidebar

  attr :current_page, :atom, required: true
  attr :sidebar_open, :boolean, default: false
  attr :flash, :map, required: true
  slot :inner_block, required: true

  def backoffice_layout(assigns) do
    ~H"""
    <div class="flex flex-col h-screen">
      <header class="md:hidden border-b border-gray-200 px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold font-amarante text-olive">Backoffice</h1>

        <button
          phx-click="toggle_sidebar"
          class="hover:bg-gray-300 px-2 py-1 rounded-md"
        >
          <.icon name="hero-bars-3" class="h-6 w-6" />
        </button>
      </header>

      <div class="flex flex-1 overflow-hidden">
        <%= if @sidebar_open do %>
          <div
            class="fixed inset-0 bg-black/50 z-40 md:hidden"
            phx-click="toggle_sidebar"
          />
        <% end %>

        <.sidebar current_page={@current_page} sidebar_open={@sidebar_open} />

        <main class="flex-1 px-4 py-8 md:px-8 overflow-y-auto bg-gray-50">
          {render_slot(@inner_block)}
        </main>
      </div>
    </div>
    <.flash_group flash={@flash} />
    """
  end
end
