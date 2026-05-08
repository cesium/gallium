defmodule GalliumWeb.Components.Hero do
  @moduledoc """
  Hero component.
  """
  use GalliumWeb, :html

  import GalliumWeb.Components.{Button, Frame}

  attr :date_info, :string,
    default: "",
    doc: "Date information for the gala dinner"

  attr :ticket_url, :string, default: "", doc: "URL for purchasing tickets"
  attr :class, :any, default: nil, doc: "The hero class to use over defaults"

  def hero(assigns) do
    ~H"""
    <section class={[
      "bg-blue w-full h-screen flex flex-col items-center justify-between py-12 md:py-16 snap-start snap-always overflow-hidden",
      @class
    ]}>
      <div class="hidden w-full md:flex justify-center scale-75 md:scale-125">
        <.frame style={:style1} mode={:bottom} color={:light_muted} />
      </div>
      <div class="text-center flex flex-col items-center justify-center flex-1">
        <h1 class="text-white font-amarante text-[60px] sm:text-[90px] md:text-[120px] lg:text-[150px] leading-[0.85] mb-8 md:mb-12">
          Jantar<br /> de Gala
        </h1>
        <p class="text-white/80 font-glacial text-sm sm:text-base md:text-2xl tracking-wider uppercase mb-10 md:mb-14">
          {@date_info}
        </p>
        <div class="w-fit">
          <.primary_button
            text="Comprar Bilhetes"
            link={@ticket_url}
            color={:light_muted}
            text_color={:blue}
            class="px-12 py-5 md:px-16 md:py-6 font-cormorant font-semibold uppercase tracking-wider text-sm md:text-lg rounded"
          />
        </div>
      </div>
      <div class="hidden w-full md:flex justify-center scale-75 md:scale-125">
        <.frame style={:style1} mode={:top} color={:light_muted} />
      </div>
    </section>
    """
  end
end
