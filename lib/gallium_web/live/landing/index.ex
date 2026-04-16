defmodule GalliumWeb.LandingLive.Index do
  use GalliumWeb, :landing_view

  import GalliumWeb.Components.Hero
  import GalliumWeb.Components.AboutSection
  import GalliumWeb.Components.Forecast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
