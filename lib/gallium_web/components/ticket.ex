defmodule GalliumWeb.Components.Ticket do
  @moduledoc """
  The Ticket component is a reusable UI component used to display information about a ticket.
  It shows a title, a list of advantages, the price per person, and a button to select the ticket.
  """

  use Phoenix.Component
  import GalliumWeb.CoreComponents
  import GalliumWeb.Components.Button

  attr :title, :string, doc: "Ticket title"
  attr :subtitle, :string, doc: "Ticket sub-title"
  attr :advantages_list, :list, doc: "List of advantages"
  attr :price, :string, doc: "Price of the ticket"
  attr :link, :string, default: nil, doc: "Link for the select button"

  def ticket(assigns) do
    ~H"""
    <div class="flex flex-col bg-white border border-gray-300 rounded-2xl shadow-sm justify-between items-start px-8 py-8 gap-5">
      <div class="flex gap-5 w-full justify-between items-start">
        <div>
          <h1 class="text-golden text-3xl font-amarante">{@title}</h1>
          <p class="text-gray-500 text-xl font-cormorant">{@subtitle}</p>
        </div>
        <div class="flex flex-col items-end">
          <p class="text-golden text-3xl font-amarante">{@price}€</p>
          <p class="text-gray-500 text-right font-cormorant">POR PESSOA</p>
        </div>
      </div>

      <div class="w-full flex flex-col sm:flex-row justify-between gap-5">
        <div class="text-xl font-cormorant grid sm:grid-cols-2 gap-x-20 gap-y-1 w-fit">
          <%= for item <- @advantages_list do %>
            <p class="text-gray-500">
              <.icon name="hero-check" class="w-5 h-5 text-olive-700" />
              {item}
            </p>
          <% end %>
        </div>
        <.primary_button
          text="Selecionar"
          link={@link}
          class="bg-golden! text-base text-white font-cormorant font-semibold px-4 py-1 w-fit h-fit!"
        />
      </div>
    </div>
    """
  end
end
