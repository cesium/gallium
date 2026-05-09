defmodule GalliumWeb.BackOffice.AttendeesLive.Index do
  @moduledoc """
  LiveView for backoffice attendees table.
  """
  use GalliumWeb, :live_view

  import GalliumWeb.BackOffice.Components.{
    BackofficeLayout,
    PaymentBadge,
    StatCard,
    TicketBadge,
    TransportBadge
  }

  alias Gallium.Ticketing

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:current_page, :attendees)
      |> assign(:sidebar_open, false)
      |> assign(:attendees, [])

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    attendees = Ticketing.list_attendees_with_details()

    socket =
      socket
      |> assign(:attendees, attendees)
      |> assign(:total_count, length(attendees))
      |> assign(:paid_count, Enum.count(attendees, &(&1.payment && &1.payment.status == :paid)))
      |> assign(
        :member_count,
        Enum.count(attendees, &(&1.user.ticket && &1.user.ticket.type == :member))
      )
      |> assign(:accompany_count, Enum.count(attendees, & &1.accompany))

    {:noreply, socket}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end
end
