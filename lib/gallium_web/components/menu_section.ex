defmodule GalliumWeb.MenuSection do
  @moduledoc """
  This module holds the menu for the Jantar de Gala.
  """
  use Phoenix.Component

  attr :title, :string, default: "MENU"

  slot :section, required: true do
    attr :title, :string, required: true
  end

  def menu_frame(assigns) do
    ~H"""
    <div class="relative w-256 font-serif">
      <img
        src="/frames/frame 4.svg"
        class="absolute inset-0 w-full h-full object-fill pointer-events-none"
      />

      <div class="relative flex flex-col items-center gap-6 p-20">
        <h1 class="text-3xl tracking-[0.4em] text-[#7BAFC4] font-serif">{@title}</h1>

        <%= for {section, index} <- Enum.with_index(@section) do %>
          <%= if index > 0 do %>
            <div class="w-48 h-px bg-[#7BAFC4] opacity-50"></div>
          <% end %>
          <div class="flex flex-col items-center gap-2 text-center">
            <h2 class="text-sm tracking-[0.3em] text-[#7BAFC4] font-semibold">{section.title}</h2>
            <div class="text-[10px] tracking-widest text-[#7BAFC4] max-w-xl leading-relaxed uppercase">
              {render_slot(section)}
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
