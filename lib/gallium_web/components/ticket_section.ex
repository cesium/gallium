defmodule GalliumWeb.Components.TicketSection do
  @moduledoc """
  Component that renders the complete tickets section on the Landing Page.
  """

  use Phoenix.Component
  import GalliumWeb.Components.Ticket
  import GalliumWeb.Components.Frame

  def ticket_section(assigns) do
    ~H"""
    <section class="bg-beige flex flex-col items-center">
      <div class="w-full flex justify-center">
        <.frame style={:style1} mode={:bottom} color={:bronze} />
      </div>
      <div class="py-20 px-4 flex flex-col items-center w-full flex-1">
        <div class="text-center mb-16">
          <p class="text-bronze font-cormorant text-sm tracking-[3px] uppercase mb-3">
            Disponibilidade Limitada
          </p>
          <h2 class="text-bronze font-amarante text-7xl uppercase mb-4">
            Bilhetes
          </h2>
          <p class="text-gray-500 font-cormorant text-xl">
            Escolhe a opção que melhor se adequa a ti
          </p>
        </div>

        <div class="w-full max-w-5xl flex flex-col gap-8">
          <.ticket
            title="SÓCIO CESIUM"
            subtitle="Preço exclusivo para sócios CeSIUM"
            price="52"
            advantages_list={[
              "Jantar completo",
              "Sessão fotográfica",
              "Animação"
            ]}
          />

          <.ticket
            title="NÃO SÓCIO"
            subtitle="Aberto a todos os estudantes"
            price="55"
            advantages_list={[
              "Jantar completo",
              "Sessão fotográfica",
              "Animação"
            ]}
          />
        </div>
      </div>
      <div class="w-full flex justify-center">
        <.frame style={:style1} mode={:top} color={:bronze} />
      </div>
    </section>
    """
  end
end
