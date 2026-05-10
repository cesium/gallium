defmodule GalliumWeb.Components.InfoSection do
  @moduledoc """
  Info Section Component
  """
  use GalliumWeb, :html

  import GalliumWeb.Components.Frame

  def info_section(assigns) do
    ~H"""
    <section class="bg-bronze w-full select-none h-screen flex flex-col items-center justify-between py-12 md:py-16 snap-start snap-always overflow-hidden">
      <div class="hidden w-full md:flex justify-center scale-100 md:scale-150">
        <.frame style={:style2} mode={:top} color={:light_muted} />
      </div>

      <div class="text-center flex flex-col items-center justify-center flex-1 font-amarante text-beige">
        <h1 class="text-5xl md:text-7xl mb-12 tracking-wide">
          Informação<br />Essencial
        </h1>

        <div class="text-center mb-8 flex flex-col items-center">
          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">
            <.icon name="hero-map-pin" class="h-5 w-5" />
            <p>Viagem de Ida</p>
          </div>
          <p class="text-xs font-glacial opacity-70 uppercase mt-1">Paragem da UM  • Quinta</p>
          <p class="text-3xl md:text-4xl mt-2 font-amarante">18H • 19:00H</p>
        </div>

        <div class="text-center flex flex-col items-center">
          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">
            <.icon name="hero-truck" class="h-5 w-5" />
            <p>Regresso</p>
          </div>
          <p class="text-3xl md:text-4xl mt-2 font-amarante">2H</p>
        </div>
      </div>

      <div class="hidden w-full md:flex justify-center scale-100 md:scale-150">
        <.frame style={:style2} mode={:bottom} color={:light_muted} />
      </div>
    </section>
    """
  end
end
