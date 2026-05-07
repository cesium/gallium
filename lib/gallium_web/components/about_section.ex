defmodule GalliumWeb.Components.AboutSection do
  @moduledoc """
  About section component
  """
  use GalliumWeb, :html
  import GalliumWeb.Components.Frame

  attr :class, :string, default: nil
  attr :title, :string, required: true
  attr :description, :string, required: true

  slot :inner_block, required: false

  def about_section(assigns) do
    ~H"""
    <section class={[
      "bg-light-muted w-full h-screen py-24 px-6 flex flex-col items-center justify-center text-center",
      @class
    ]}>
      <div class="mb-6 rotate-180 scale-130">
        <.frame style={:style2} mode={:bottom} color={:blue} class="scale-75" />
      </div>

      <div class="max-w-3xl mx-auto">
        <h2 class="text-blue font-amarante text-4xl sm:text-5xl md:text-6xl uppercase leading-tight mb-8 tracking-wide">
          {raw(
            @title
            |> String.replace("\\n", "\n")
            |> String.replace("\n", "<br/>")
          )}
        </h2>

        <h4 class="text-blue/60 font-cormorant text-lg md:text-2xl font-medium mx-auto leading-relaxed">
          {@description}
        </h4>
      </div>

      <div class="mt-6 scale-130">
        <.frame style={:style2} mode={:bottom} color={:blue} class="scale-75" />
      </div>
    </section>
    """
  end
end
