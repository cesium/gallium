defmodule GalliumWeb.LandingLive.Index do
  use GalliumWeb, :landing_view

  import GalliumWeb.Components.{AboutSection, Forecast, Hero}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
