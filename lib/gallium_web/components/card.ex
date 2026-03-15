defmodule GalliumWeb.Card do
  @moduledoc """
  A card component with a title, description, and an icon.
  """
  use GalliumWeb, :html

  attr :title, :string, default: ""
  attr :description, :string, default: ""
  attr :image_url, :string, default: nil
  attr :icon, :string, default: nil

  def card(assigns) do
    ~H"""
    <div class="rounded-lg flex flex-col p-8 items-center gap-6 w-full max-w-xs min-h-72 h-fit bg-beige">
      <div
        :if={@image_url || @icon}
        class="flex w-16 h-16 items-center justify-center rounded-full bg-bronze-100"
      >
        <img
          :if={@image_url}
          src={@image_url}
          alt={@title || "card image"}
          class="h-8 w-8 object-cover"
        />
        <.icon :if={!@image_url && @icon} name={@icon} class="h-8 w-8 text-bronze-500" />
      </div>
      <div class="flex flex-col items-center gap-3 text-center">
        <h3
          :if={@title}
          class="font-amarante text-bronze-500 text-xl tracking-[1px] leading-7 uppercase text-center px-4"
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
