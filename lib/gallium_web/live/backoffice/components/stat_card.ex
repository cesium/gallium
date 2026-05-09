defmodule GalliumWeb.BackOffice.Components.StatCard do
  @moduledoc false
  use GalliumWeb, :component

  attr :label, :string, required: true
  attr :value, :integer, required: true
  attr :color, :string, default: "text-olive"

  def stat_card(assigns) do
    ~H"""
    <div class="bg-white rounded-xl border border-gray-200 px-5 py-4 shadow-sm">
      <p class="text-xs font-cormorant uppercase tracking-widest text-gray-400 mb-1">
        {@label}
      </p>
      <p class={"text-3xl font-amarante #{@color}"}>{@value}</p>
    </div>
    """
  end
end
