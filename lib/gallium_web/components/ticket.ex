defmodule GalliumWeb.Components.Ticket do
  @moduledoc """
  The Ticket component is a reusable UI component used to display information about a ticket.
  It shows a title, a list of advantages, the price per person, and a button to select the ticket.
  """

  use Phoenix.Component
  import GalliumWeb.CoreComponents

  attr(:title, :string, doc: "Ticket title")
  attr(:sub_title, :string, doc: "Ticket sub-title")
  attr(:advantages_list, :list, doc: "List of advantages")
  attr(:price, :string, doc: "Price of the ticket")

  def ticket(assigns) do
    ~H"""
    <div class="bg-white flex justify-between items-start">
      <div class="pl-8 grid grid-rows gap-5">
        <div class="">
          <h1 class="text-golden text-3xl font-amarante mt-8">{@title}</h1>
          <p class="text-black text-xl font-cormorant">Preço exclusivo para sócios</p>
        </div>
        <div class="text-xl font-cormorant grid grid-cols-2 gap-x-20 gap-y-1 w-fit mb-8">
          <%= for item <- @advantagesList do %>
            <p class="text-black">
              <.icon name="hero-check" class="w-5 h-5 text-green" />
              {item}
            </p>
          <% end %>
        </div>
      </div>
      <div class="grid grid-rows gap-5 pr-8">
        <div class="flex flex-col items-end justify-end mt-10">
          <p class="text-golden text-3xl font-amarante">{@price}€</p>
          <p class="text-black text-l font-cormorant">POR PESSOA</p>
        </div>
        <div>
          <button class="bg-golden text-white text-xl font-cormorant px-11 py-2 rounded-md">
            Selecionar
          </button>
        </div>
      </div>
    </div>
    """
  end
end
