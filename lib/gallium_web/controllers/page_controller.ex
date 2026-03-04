defmodule GalliumWeb.PageController do
  use GalliumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
