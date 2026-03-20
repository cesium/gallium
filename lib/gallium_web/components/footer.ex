defmodule GalliumWeb.Components.Footer do
  @moduledoc """
  Footer Component.
  """
  use Phoenix.Component

  attr :place_name, :string, default: "", doc: "Event place name"
  attr :date, :string, default: "", doc: "Event date"
  attr :class, :any, default: nil, doc: "The footer class to use over defaults"

  def footer(assigns) do
    ~H"""
    <footer class={"w-full bg-beige text-blue-800/80 px-6 py-16 #{@class}"}>
      <div class="max-w-7xl mx-auto flex flex-col">
        <div class="flex flex-col md:flex-row justify-between items-center md:items-baseline mb-12 gap-8">
          <div class="flex-1 text-center md:text-left">
            <p class="font-amarante text-blue-500 text-3xl tracking-widest uppercase">
              galium
            </p>
            <p class="font-cormorant text-xs text-blue-800/60 tracking-[0.2em] mt-2 uppercase">
              jantar de gala 2026
            </p>
          </div>

          <nav class="flex gap-10 uppercase font-cormorant text-xs tracking-widest">
            <.link href="" class="hover:text-blue-500 transition-colors">evento</.link>
            <.link href="" class="hover:text-blue-500 transition-colors">bilhetes</.link>
          </nav>

          <div class="flex-1 text-center md:text-right">
            <p class="font-cormorant text-xs tracking-widest uppercase">
              {@place_name}
              <span :if={@place_name != "" and @date != ""}>-</span>
              {@date}
            </p>

            <p class="text-olive text-xs mt-1 font-cormorant tracking-widest">
              Organizado pelo CeSIUM
            </p>
          </div>
        </div>

        <div class="w-full border-t border-olive-800/20 mb-12"></div>

        <div class="flex justify-center mb-8">
          <div class="w-4 h-4 rounded-full border border-blue-500 flex items-center justify-center">
            <div class="w-1.5 h-1.5 rounded-full bg-blue-500"></div>
          </div>
        </div>

        <p class="text-center font-cormorant text-sm">
          © 2026 Galium. Todos os direitos reservados.
        </p>
      </div>
    </footer>
    """
  end
end
