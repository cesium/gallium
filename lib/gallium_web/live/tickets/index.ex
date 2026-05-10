defmodule GalliumWeb.TicketsLive.Index do
  use GalliumWeb, :live_view

  @moduledoc """
  The tickets index page.

  This page is where the user selects the type of ticket they wish to purchase.
  """

  import GalliumWeb.Components.Ticket
  import GalliumWeb.Layouts

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
