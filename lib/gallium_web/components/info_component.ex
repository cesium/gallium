defmodule GalliumWeb.Components.InfoSection do
  @moduledoc """
  Info Section Component
  """
  use GalliumWeb, :html

  import GalliumWeb.Components.Frame

  def info_section(assigns) do
    ~H"""
    <section class="bg-blue-500 w-full h-screen flex flex-col items-center justify-between py-12 md:py-16 snap-start snap-always overflow-hidden">
      <div class="hidden w-full md:flex justify-center scale-100 md:scale-125">
        <.frame style={:style1} mode={:bottom} color={:light_muted} />
      </div>

      <div class="text-center flex flex-col items-center justify-center flex-1 font-amarante text-beige">
        <h1 class="text-5xl md:text-7xl uppercase mb-12 tracking-[0.2em]">
          INFO<br />ESSENCIAL
        </h1>

        <div class="text-center mb-8 flex flex-col items-center">
          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">
            <.icon name="hero-map-pin" class="h-5 w-5" />

            <p>Viagem de Ida</p>
          </div>

          <p class="text-xs font-glacial opacity-70 uppercase mt-1">Paragens UM • Quinta</p>

          <p class="text-3xl md:text-4xl mt-2 font-amarante">18H30 • 19H</p>
        </div>

        <div class="text-center mb-8 flex flex-col items-center">
          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">
            <.icon name="hero-clock" class="h-5 w-5" />

            <p>Sessão Fotográfica</p>
          </div>

          <p class="text-3xl md:text-4xl mt-2 font-amarante">19H30 • 20H</p>
        </div>

        <div class="text-center flex flex-col items-center">
          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">
            <.icon name="hero-truck" class="h-5 w-5" />

            <p>Regresso</p>
          </div>

          <p class="text-3xl md:text-4xl mt-2 font-amarante">3H</p>
        </div>
      </div>

      <div class="hidden w-full md:flex justify-center scale-100 md:scale-125">
        <.frame style={:style1} mode={:top} color={:light_muted} />
      </div>
    </section>
    """
  end
end
