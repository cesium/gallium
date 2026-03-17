defmodule GalliumWeb.HeroBanner do
  @moduledoc """
  This module holds the Gala Dinner Hero Banner
  """
  use Phoenix.Component

  attr :title, :string, default: "MENU"

  def hero_banner(assigns) do
    ~H"""
    <div class="bg-olive w-full px-8 sm:px-0">
      <div class="relative w-full font-serif h-auto sm:bg-[url(/frames/frame2.svg)] bg-contain bg-no-repeat bg-center">
        <div class=" flex flex-col items-center justify-center text-center py-3">
          <div class="flex flex-col gap-3 p-12">
            <p class="flex items-center justify-center text-white font-bold text-md tracking-[.25em] opacity-50">
              •••••••••
            </p>
            <h1 class="text-olive-50 font-amarante leading-tight tracking-wide text-6xl m-0">
              JANTAR<br />DE GALA
            </h1>
            <p class="text-olive-50 font-cormorant font-bold text-xs tracking-[0.2em]">
              <span class="block sm:inline">PROGRAMA •</span>
              <span class="block sm:inline">VER MAIS &gt;&gt;&gt</span>
            </p>
          </div>

          <.link
            href="/"
            class="border border-white text-olive bg-white px-8 py-2.5 text-sm tracking-[0.2em] font-serif no-underline transition-all duration-200 hover:bg-olive hover:text-olive-50"
          >
            COMPRAR BILHETES
          </.link>
          <span class="text-olive-50 text-2xl pt-8">✳</span>
        </div>
      </div>
    </div>
    """
  end
end
