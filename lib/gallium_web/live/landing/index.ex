defmodule GalliumWeb.LandingLive.Index do
  use GalliumWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
