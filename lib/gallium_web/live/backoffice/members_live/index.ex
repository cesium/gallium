defmodule GalliumWeb.BackOffice.MembersLive.Index do
  @moduledoc """
  LiveView for backoffice member CSV uploads.
  """
  use GalliumWeb, :live_view

  import GalliumWeb.Components.Button
  import GalliumWeb.BackOffice.Components.BackofficeLayout

  alias Gallium.Members

  def mount(_params, _session, socket) do
    socket =
      socket
      |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1, max_file_size: 500_000)
      |> assign(:current_page, :members)
      |> assign(:sidebar_open, false)

    {:ok, socket}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :csv, ref)}
  end

  def handle_event("save", _params, socket) do
    entries = socket.assigns.uploads.csv.entries

    if Enum.all?(entries, & &1.done?) do
      results =
        consume_uploaded_entries(socket, :csv, fn %{path: path}, _entry ->
          import_result = Members.import_cesium_members(path)

          {:ok, import_result}
        end)

      socket =
        case results do
          [{:ok, message}] -> put_flash(socket, :info, message)
          [{:error, message}] -> put_flash(socket, :error, message)
          _ -> socket
        end

      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "Wait until the file has been uploaded!")}
    end
  end
end
