defmodule GalliumWeb.Components.ProgramSection do
  @moduledoc """
  Component that renders the event schedule section on the Landing Page
  """
  use Phoenix.Component

  attr :schedule_items, :list,
    default: [
      %{
        time: "18H30",
        title: "PARTIDA DA UNIVERSIDADE",
        description: "Encontro no Paragens Um para embarque no autocarro"
      },
      %{
        time: "19H30",
        title: "CHEGADA À QUINTA DA ALDEIA",
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
        title: "ANIMAÇÃO & KARAOKE",
        description: "Música, karaoke, cartões quebra-gelo e muitas surpresas"
      },
      %{
        time: "3H",
        title: "REGRESSO À UNIVERSIDADE",
        description: "Autocarro de volta ao ponto de partida"
      }
    ]

  def program_section(assigns) do
    ~H"""
    <section class="bg-beige py-24 px-4 flex flex-col items-center w-full">
      <div class="relative z-10 w-full max-w-3xl flex flex-col items-center py-16 px-8">
        <h2 class="text-olive-500 font-amarante text-5xl uppercase mb-7 tracking-widest text-center">
          Programa
        </h2>

        <div class="w-full flex flex-col">
          <%= for item <- @schedule_items do %>
            <div class="flex flex-col sm:flex-row items-start py-8 border-b border-gray-200 last:border-none gap-2 sm:gap-0">
              <div class="w-full sm:w-1/3">
                <p class="text-olive-500 font-amarante text-xl uppercase max-w-none sm:max-w-[120px] leading-tight">
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

        <p class="mt-16 text-olive-500 font-amarante text-[10px] text-center uppercase tracking-[2px] max-w-md">
          Não percas atividades incríveis como karaoke, cartões quebra-gelo e muitas outras surpresas!
        </p>
      </div>
    </section>
    """
  end
end
