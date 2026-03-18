defmodule GalliumWeb.Components.TicketSection do
  @moduledoc """
  Component that renders the complete tickets section on the Landing Page.
  """

  use Phoenix.Component
  import GalliumWeb.Components.Ticket

  def ticket_section(assigns) do
    ~H"""
    <section class="bg-beige py-20 px-4 flex flex-col items-center">
      <div class="text-center mb-16">
        <p class="text-bronze-500 font-cormorant text-sm tracking-[3px] uppercase mb-3">
          Disponibilidade Limitada
        </p>
        <h2 class="text-bronze-500 font-amarante text-7xl uppercase mb-4">
          Bilhetes
        </h2>
        <p class="text-gray-500 font-cormorant text-xl">
          Escolhe a opção que melhor se adequa a ti
        </p>
      </div>

      <div class="w-full max-w-5xl flex flex-col gap-8">
        <.ticket
          title="SOCIO CESIUM"
          subtitle="Preço exclusivo para sócios"
          price="25"
          advantages_list={[
            "Jantar completo",
            "Sessão fotográfica",
            "Transporte incluído",
            "Animação e karaoke"
          ]}
        />

        <.ticket
          title="NAO SOCIO"
          subtitle="Aberto a todos os estudantes"
          price="30"
          advantages_list={[
            "Jantar completo",
            "Sessão fotográfica",
            "Transporte incluído",
            "Animação e karaoke"
          ]}
        />
      </div>
    </section>
    """
  end
end
