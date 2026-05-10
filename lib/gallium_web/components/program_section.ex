defmodule GalliumWeb.Components.ProgramSection do
  @moduledoc """
  Component that renders the event schedule section on the Landing Page
  """
  use Phoenix.Component

  attr :class, :string, default: nil

  attr :schedule_items, :list,
    default: [
      %{
        time: "18H30",
        title: "PARTIDA DA UNIVERSIDADE",
        description: "Encontro na paragem da UM para embarque no autocarro"
      },
      %{
        time: "19H30",
        title: "CHEGADA À QUINTA VINHA DO CABO",
        description: "Recepção com entradas e bebidas de boas-vindas"
      },
      %{
        time: "19H30 - 20H30",
        title: "ENTRADAS & SESSÃO FOTOGRÁFICA",
        description: "Aproveita para tirar fotografias profissionais e socializar"
      },
      %{
        time: "20H30",
        title: "JANTAR",
        description: "Sopa, prato principal e sobremesa servidos à mesa"
      },
      %{
        time: "22H00",
        title: "ANIMAÇÃO",
        description: "Música, cartões quebra-gelo e muitas surpresas"
      },
      %{
        time: "2H",
        title: "REGRESSO À UNIVERSIDADE",
        description: "Autocarro de volta ao ponto de partida"
      }
    ]

  def program_section(assigns) do
    ~H"""
    <section class={["bg-beige flex flex-col items-center w-full", @class]}>
      <div class="relative z-10 w-full max-w-3xl flex flex-col items-center py-16 px-8">
        <h2 class="text-bronze font-amarante text-5xl uppercase mb-7 tracking-widest text-center">
          Programa
        </h2>

        <div class="w-full flex flex-col">
          <%= for item <- @schedule_items do %>
            <div class="flex flex-col sm:flex-row items-start py-8 border-b border-bronze/20 last:border-none gap-2 sm:gap-0">
              <div class="w-full sm:w-1/3">
                <p class="text-bronze font-amarante text-xl uppercase max-w-none sm:max-w-[120px] leading-tight">
                  {item.time}
                </p>
              </div>
              <div class="w-full sm:w-2/3 flex flex-col gap-1">
                <h3 class="text-gray-700 font-cormorant text-lg font-semibold uppercase tracking-wide">
                  {item.title}
                </h3>
                <p class="text-gray-500 font-cormorant text-base">{item.description}</p>
              </div>
            </div>
          <% end %>
        </div>

        <p class="mt-16 text-bronze text-sm text-center tracking-[2px] max-w-md">
          Não percas atividades incríveis como karaoke, cartões quebra-gelo e muitas outras surpresas!
        </p>
      </div>
    </section>
    """
  end
end
