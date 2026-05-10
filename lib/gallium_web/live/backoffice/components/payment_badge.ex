defmodule GalliumWeb.BackOffice.Components.PaymentBadge do
  @moduledoc false
  use GalliumWeb, :component

  attr :payment, :any, required: true

  def payment_badge(assigns) do
    ~H"""
    <%= case @payment do %>
      <% nil -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-gray-100 text-gray-400 font-semibold border border-gray-200">
          Sem pagamento
        </span>
      <% %{status: :paid} -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-green-50 text-green-700 font-semibold border border-green-200">
          <.icon name="hero-check" class="size-3" /> Pago
        </span>
      <% %{status: :pending} -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-yellow-50 text-yellow-700 font-semibold border border-yellow-200">
          <.icon name="hero-clock" class="size-3" /> Pendente
        </span>
      <% %{status: :failed} -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-red-50 text-red-600 font-semibold border border-red-200">
          <.icon name="hero-x-mark" class="size-3" /> Falhou
        </span>
      <% _ -> %>
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs bg-gray-100 text-gray-400 font-semibold border border-gray-200">
          Desconhecido
        </span>
    <% end %>
    """
  end
end
