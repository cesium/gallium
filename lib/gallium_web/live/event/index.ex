defmodule GalliumWeb.EventLive.Index do
  import GalliumWeb.Components.{HeroBanner, InfoSection, MenuSection, ProgramSection}

  use GalliumWeb, :app_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
