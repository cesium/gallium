defmodule GalliumWeb.Components.Stepper do
  @moduledoc """
  Stepper Component. mix credo --all --strict
  """
  use Phoenix.Component

  attr :current_step, :integer, required: true
  attr :step_names, :list, required: true

  def stepper(assigns) do
    ~H"""
    <div class="flex flex-row w-full items-center p-10">
      <%= for {name, index} <- Enum.with_index(@step_names, 1) do %>
        <div class="flex flex-col items-center relative">
          <div class={[
            "rounded-full transition duration-500 ease-in-out h-10 w-10 flex items-center justify-center p-2 shrink-0 m-2",
            @current_step > index && "bg-olive text-white",
            @current_step == index && "bg-blue-500 border-blue-200 text-white ring-4 ring-blue-100",
            @current_step < index && "bg-gray-300 text-gray-500"
          ]}>
            <%= if @current_step > index do %>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="size-6"
              >
                <path strokeLinecap="round" strokeLinejoin="round" d="m4.5 12.75 6 6 9-13.5" />
              </svg>
            <% else %>
              <span class="font-amarante">{index}</span>
            <% end %>
          </div>
          <div class="hidden sm:block absolute top-12 left-1/2 -translate-x-1/2 w-max text-center text-xs uppercase my-2">
            <span class="font-cormorant">{name}</span>
          </div>
        </div>
        <%= if index < length(@step_names) do %>
          <div class={[
            "flex-1 h-1 transition duration-500 ease-in-out",
            @current_step > index && "bg-olive",
            @current_step <= index && "bg-gray-300"
          ]}>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
