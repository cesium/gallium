defmodule GalliumWeb.Components.Stepper do
  @moduledoc """
  Stepper Component.
  """
  use Phoenix.Component
  import GalliumWeb.CoreComponents

  attr :current_step, :integer, required: true
  attr :step_names, :list, required: true

  def stepper(assigns) do
    ~H"""
    <div class="flex flex-row w-full items-center sm:p-10">
      <%= for {name, index} <- Enum.with_index(@step_names, 1) do %>
        <div class="flex flex-col items-center relative">
          <div class={[
            "rounded-full transition duration-500 ease-in-out h-10 w-10 flex items-center justify-center p-2 shrink-0 m-2",
            @current_step > index && "bg-blue-500 text-white",
            @current_step == index && "bg-blue-500 border-blue-200 text-white ring-4",
            @current_step < index && "bg-white text-gray-500"
          ]}>
            <%= if @current_step > index do %>
              <.icon name="hero-check" class="size-6" />
            <% else %>
              <span class="font-amarante select-none">{index}</span>
            <% end %>
          </div>
          <div class="hidden sm:block absolute top-12 left-1/2 -translate-x-1/2 w-max text-center text-xs uppercase my-2">
            <span class="font-cormorant text-gray-700">{name}</span>
          </div>
        </div>
        <%= if index < length(@step_names) do %>
          <div class={[
            "flex-1 h-1 transition duration-500 ease-in-out",
            @current_step > index && "bg-blue-500",
            @current_step <= index && "bg-white"
          ]}>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
