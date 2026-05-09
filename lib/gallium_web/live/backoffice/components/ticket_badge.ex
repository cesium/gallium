defmodule GalliumWeb.BackOffice.Components.TicketBadge do
  @moduledoc false
  use GalliumWeb, :component

  attr :type, :any, required: true

  def ticket_badge(assigns) do
    ~H"""
    <%= case @type do %>
      <% :member -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-olive-100 text-olive-700 font-semibold border border-olive-200">
          <.icon name="hero-academic-cap" class="size-3" /> Sócio
        </span>
      <% :non_member -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-gray-100 text-gray-500 font-semibold border border-gray-200">
          <.icon name="hero-user" class="size-3" /> Não Sócio
        </span>
      <% _ -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-gray-100 text-gray-300 font-semibold border border-gray-200">
          -
        </span>
    <% end %>
    """
  end
end
