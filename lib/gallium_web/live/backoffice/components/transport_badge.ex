defmodule GalliumWeb.BackOffice.Components.TransportBadge do
  @moduledoc false
  use GalliumWeb, :component

  attr :wants_transport, :boolean, required: true

  def transport_badge(assigns) do
    ~H"""
    <%= if @wants_transport do %>
      <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-blue-50 text-blue-700 font-semibold border border-blue-200">
        <.icon name="hero-check" class="size-3" /> Sim
      </span>
    <% else %>
      <span class="text-gray-300">-</span>
    <% end %>
    """
  end
end
