defmodule GalliumWeb.Components.MenuSection do
  @moduledoc """
  This module holds the menu for the Jantar de Gala.
  """
  use Phoenix.Component
  import GalliumWeb.Components.Frame

  attr :title, :string, default: "MENU"

  slot :section do
    attr :title, :string, required: true
  end

  def menu_frame(assigns) do
    ~H"""
    <div class="relative w-full h-auto p-6 bg-beige bg-contain bg-no-repeat bg-center">
      <div class="relative flex flex-col items-center gap-8 p-12">
        <.frame style={:style1} mode={:bottom} color={:bronze} />
        <h1 class="text-6xl text-bronze font-amarante tracking-wide py-2">{@title}</h1>
        <div>
          <%= if @section == [] do %>
            <div class="flex flex-col items-center text-center p-4 gap-2">
              <p class="text-sm tracking-wide text-black font-cormorant leading-relaxed text-wrap max-w-5xl uppercase">
                Sem secções para mostrar.
              </p>
            </div>
          <% else %>
            <%= for {section, _} <- Enum.with_index(@section) do %>
              <div class="flex flex-col items-center text-center p-4 gap-2">
                <h2 class="text-xl tracking-[0.3em] text-bronze font-amarante font-semibold uppercase">
                  {section.title}
                </h2>
                <div class="text-sm tracking-wide text-gray-500 font-cormorant leading-relaxed text-wrap max-w-5xl uppercase">
                  {render_slot(section)}
                </div>
              </div>
            <% end %>
          <% end %>
        </div>
        <.frame style={:style1} mode={:top} color={:bronze} />
      </div>
    </div>
    """
  end
end
