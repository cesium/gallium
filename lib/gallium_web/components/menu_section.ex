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
    <div class="relative w-full h-auto p-6 bg-beige bg-[url(/frames/frame4.svg)] bg-contain bg-no-repeat bg-center">
      <div class="relative flex flex-col items-center gap-8 p-12">
        <h1 class="text-5xl  text-blue-500 font-cormorant py-2">{@title}</h1>
        <div class="">
          <%= for {section, i} <- Enum.with_index(@section) do %>
            <div class="flex flex-col items-center text-center p-4 gap-2">
              <h2 class="text-md tracking-[0.3em] text-blue-500 font-amarante font-semibold uppercase">
                {section.title}
              </h2>
              <div class="text-sm tracking-wide text-black font-cormorant  leading-relaxed text-wrap max-w-5xl uppercase">
                {render_slot(section)}
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
