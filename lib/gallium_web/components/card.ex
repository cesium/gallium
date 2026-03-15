defmodule GalliumWeb.Card do
  @moduledoc """
  A card component with a title, description, and an icon.
  """
  use GalliumWeb, :html

  attr :title, :string, default: ""
  attr :description, :string, default: ""
  attr :icon, :string, default: nil

  def card(assigns) do
    ~H"""
    <div class="rounded-lg flex flex-col p-8 items-center gap-6 w-full max-w-[280px] min-h-[288px] h-fit bg-beige">
      <div :if={@icon} class="flex w-16 h-16 items-center justify-center rounded-full bg-bronze-100">
        <.icon name={@icon} class="h-8 w-8 text-bronze-500" />
      </div>
      <div class="flex flex-col items-center gap-3 text-center">
        <h3
          :if={@title}
          class="font-amarante text-bronze-500 text-xl tracking-[1px] leading-[28px] uppercase text-center px-4"
        >
          {@title}
        </h3>
        <p
          :if={@description}
          class="font-cormorant text-gray-500 text-sm font-normal leading-[22.75px] tracking-normal text-center"
        >
          {@description}
        </p>
      </div>
    </div>
    """
  end
end
