defmodule GalliumWeb.Components.Hero do
  @moduledoc """
  Hero component.
  """
  use GalliumWeb, :html

  import GalliumWeb.Components.Button

  attr :date_info, :string,
    default: "",
    doc: "Date information for the gala dinner"

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :class, :any, default: nil, doc: "The hero class to use over defaults"

  def hero(assigns) do
    ~H"""
    <section class="bg-blue-500 w-full h-fit flex flex-col items-center justify-center px-4 py-20 {@class}">
      <div class="text-center flex flex-col items-center">
        <h1 class="text-beige font-amarante text-9xl uppercase mb-9">
          jantar<br /> de gala
        </h1>
        <p class="text-beige font-cormorant tracking-[4px] uppercase mb-9">
          {@date_info}
        </p>
        <div class="w-fit">
          <.primary_button
            text="comprar bilhetes"
            link={@ticket_url}
            color={:light_muted}
            text_color={:blue}
            class="px-8 py-3 font-amarante uppercase tracking-[0.2em]"
          />
        </div>
      </div>
    </section>
    """
  end
end
