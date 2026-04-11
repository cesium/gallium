defmodule GalliumWeb.Components.Forecast do
  @moduledoc """
  Component that displays event highlights.
  """
  use Phoenix.Component
  import GalliumWeb.Components.Card

  def forecast(assigns) do
    ~H"""
    <section class="w-full bg-bronze-500 py-16 px-4">
      <div class="flex flex-col items-center gap-2 mb-12">
        <h2 class="font-amarante text-beige text-4xl tracking-[4px] uppercase text-center">
          O Que Esperar
        </h2>
        <p class="font-cormorant text-beige/70 text-sm tracking-[3px] uppercase text-center">
          Uma noite pensada para momentos inesquecíveis
        </p>
      </div>

      <div class="grid grid-cols-4 gap-3 max-w-6xl mx-auto w-full ">
        <div>
          <.card
            icon="hero-cake"
            title="Jantar Requintado"
            description="Desfruta de um menu cuidadosamente elaborado com entradas variadas, sopa, prato principal e sobremesa."
          />
        </div>
        <div>
          <.card
            icon="hero-musical-note"
            title="Karaoke & Animação"
            description="Diverte-te com karaoke, cantores quebra-gelo e muitas outras surpresas ao longo da noite."
          />
        </div>
        <div>
          <.card
            icon="hero-camera"
            title="Sessão Fotográfica"
            description="Capta memórias eternas com uma sessão fotográfica profissional entre as 19h30 e as 20h."
          />
        </div>
        <div>
          <.card
            icon="hero-truck"
            title="Transporte Incluído"
            description="Viagem de ida às 18h30 da universidade e regresso às 3h. Não te preocupes com nada!"
          />
        </div>
      </div>
    </section>
    """
  end
end
