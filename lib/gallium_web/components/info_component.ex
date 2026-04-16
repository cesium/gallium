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

          INFO<br>ESSENCIAL

        </h1>



        <div class="text-center mb-8 flex flex-col items-center">

          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">

            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-5 w-5">

              <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />

              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z" />

            </svg>

            <p>Viagem de Ida</p>

          </div>

          <p class="text-xs font-glacial opacity-70 uppercase mt-1">Paragens UM • Quinta</p>

          <p class="text-3xl md:text-4xl mt-2 font-amarante">18H30 • 19H</p>

        </div>



        <div class="text-center mb-8 flex flex-col items-center">

          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">

            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-5 w-5">

              <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />

            </svg>

            <p>Sessão Fotográfica</p>

          </div>

          <p class="text-3xl md:text-4xl mt-2 font-amarante">19H30 • 20H</p>

        </div>



        <div class="text-center flex flex-col items-center">

          <div class="flex items-center space-x-2 font-glacial text-xs tracking-[0.3em] uppercase opacity-80">

            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-5 w-5">

              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />

            </svg>

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
