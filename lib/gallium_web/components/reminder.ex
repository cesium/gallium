defmodule GalliumWeb.Components.Reminder do
  @moduledoc false
  use Phoenix.Component

  attr :title, :string, required: true, doc: "The title of the reminder"
  attr :description, :string, default: nil, doc: "The description of the reminder"

  def reminder(assigns) do
    ~H"""
    <div class="flex flex-col gap-3 items-center justify-center rounded-lg border border-olive/10 bg-olive-200/30 w-[1216px] h-[138px]">
      <h2 class="text-olive/80 font-amarante uppercase text-2xl tracking-wide">
        {@title}
      </h2>
      <%= if @description do %>
        <p class="text-olive-700 font-cormorant text-md uppercase tracking-wide">
          {@description}
        </p>
      <% end %>
    </div>
    """
  end
end
