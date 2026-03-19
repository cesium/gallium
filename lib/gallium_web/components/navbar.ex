defmodule GalliumWeb.Components.Navbar do
  @moduledoc """
  Navbar Component.
  """
  use Phoenix.Component

  import GalliumWeb.Components.Button

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :class, :any, default: nil, doc: "The navbar class to use over defaults"

  def navbar(assigns) do
    ~H"""
    <header class={"w-full h-fit bg-beige text-blue-800/80 px-3 py-3 #{@class}"}>
      <div class="max-w-7xl mx-auto flex items-center justify-between tracking-widest">

        <div>
        <.link href={"/"}>
          <p class="font-amarante text-blue-500 text-2xl uppercase cursor-pointer">
            galium
          </p>
        </.link>
      </div>

        <nav class="md:flex gap-10 uppercase font-cormorant font-bold text-xs">
          <.link href="" class="hover:text-blue-500 transition-colors">evento</.link>
          <.link href="" class="hover:text-blue-500 transition-colors">bilhetes</.link>
        </nav>

        <div>
          <.primary_button
            text="comprar bilhetes"
            link={@ticket_url}
            color={:blue}
            text_color={:beige}
            class="bg-blue-500 px-6 py-1 font-amarante font-bold uppercase"
          />
        </div>

      </div>
    </header>
    """
  end
end
