defmodule GalliumWeb.Components.HeroBanner do
  @moduledoc """
  This module holds the Gala Dinner Hero Banner
  """
  use Phoenix.Component
  import GalliumWeb.Components.{Button, Frame}

  attr :title, :string, default: "MENU"

  def hero_banner(assigns) do
    ~H"""
    <div class="bg-blue h-[calc(100dvh-3rem)] overflow-y-auto w-full px-8 sm:px-0 flex flex-col items-center py-12 overflow-hidden">
      <div class="w-full flex justify-center overflow-hidden">
        <div class="w-full md:scale-25">
          <.frame style={:style2} mode={:bottom} color={:light_muted} />
        </div>
      </div>
      <div class="relative w-full font-serif h-auto py-8">
        <div class="flex flex-col items-center justify-center text-center py-3">
          <div class="flex flex-col gap-3 p-12">
            <p class="flex items-center justify-center text-light-muted font-bold text-md tracking-[.25em] opacity-50">
              •••••••••
            </p>
            <h1 class="text-beige font-amarante leading-tight text-7xl md:text-9xl m-0">
              Jantar<br />de Gala
            </h1>
            <p class="text-beige font-glacial text-base tracking-[0.2em] opacity-70">
              <span class="block sm:inline">PROGRAMA</span>
              <span class="block sm:inline">–</span>
              <span class="block sm:inline">VER MAIS</span>
            </p>
          </div>

          <.primary_button
            text="Comprar Bilhetes"
            link="/tickets"
            color={:light_muted}
            text_color={:blue}
            class="px-12 py-4 font-cormorant font-semibold uppercase tracking-wider text-sm rounded-md shadow-sm hover:scale-100"
          />
          <span class="text-light-muted text-2xl pt-5">✳</span>
        </div>
      </div>
      <div class="w-full flex justify-center overflow-hidden">
        <div class="w-full md:scale-25">
          <.frame style={:style2} mode={:top} color={:light_muted} />
        </div>
      </div>
    </div>
    """
  end
end
