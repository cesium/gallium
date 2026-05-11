defmodule GalliumWeb.TermsLive.Index do
  use GalliumWeb, :landing_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Termos e Condições")}
  end
end
