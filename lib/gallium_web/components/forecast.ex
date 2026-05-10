defmodule GalliumWeb.Components.Forecast do
  @moduledoc """
  Component that displays event highlights.
  """
  use Phoenix.Component
  import GalliumWeb.Components.Card

  def forecast(assigns) do
    ~H"""
    <section class="w-full bg-olive py-16 px-4">
      <div class="flex flex-col items-center gap-2 mb-12">
        <h2 class="font-amarante text-white text-4xl tracking-[4px] uppercase text-center">
          O Que Esperar
        </h2>
        <p class="font-cormorant text-white/70 text-sm tracking-[3px] uppercase text-center">
          Uma noite pensada para momentos inesquecíveis
        </p>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 max-w-6xl mx-auto w-full">
        <.card
          icon="hero-cake"
          title="Jantar Requintado"
          description="Desfruta de um menu cuidadosamente elaborado com entradas variadas, sopa, prato principal e sobremesa."
        />
        <.card
          icon="hero-musical-note"
          title="Karaoke & Animação"
          description="Diverte-te com karaoke, cantores quebra-gelo e muitas outras surpresas ao longo da noite."
        />
        <.card
          icon="hero-camera"
          title="Sessão Fotográfica"
          description="Capta memórias eternas com uma sessão fotográfica entre as 19h30 e as 20h."
        />
        <.card
          icon="hero-truck"
          title="Transporte Incluído"
          description="Viagem de ida às 18h30 da universidade e regresso às 3h. Não te preocupes com nada!"
        />
      </div>
    </section>
    """
  end
end
