defmodule GalliumWeb.BackOfficeIndex.Index do
  @moduledoc """
  LiveView for the backoffice index page.
  """
  use GalliumWeb, :live_view
  import GalliumWeb.Components.Button

  alias Gallium.Members

  embed_templates "backoffice_pages/*"

  def mount(_params, _session, socket) do
    menu_items = [
      %{page: "add_cesium_members", icon: "hero-arrow-up-tray", label: "Adicionar Membros"}
    ]

    socket =
      socket
      |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1, max_file_size: 500_000)
      |> assign(:current_page, "add_cesium_members")
      |> assign(:sidebar_open, false)
      |> assign(:menu_items, menu_items)

    {:ok, socket}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  def handle_event("change_page", %{"page" => page}, socket) do
    {:noreply, socket |> assign(:current_page, page) |> assign(:sidebar_open, false)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :csv, ref)}
  end

  def handle_event("save", _params, socket) do
    # Check if all entries are done uploading
    entries = socket.assigns.uploads.csv.entries

    if Enum.all?(entries, & &1.done?) do
      # Consume the uploaded file (only 1 due to max_entries: 1)
      results =
        consume_uploaded_entries(socket, :csv, fn %{path: path}, _entry ->
          import_result = Members.import_cesium_members(path)

          # Wrap it in :ok to tell LiveView the file was safely consumed
          {:ok, import_result}
        end)

      # Handle result and show flash message
      socket =
        case results do
          [{:ok, message}] -> put_flash(socket, :info, message)
          [{:error, message}] -> put_flash(socket, :error, message)
          _ -> socket
        end

      {:noreply, socket}
    else
      # Upload not done yet
      {:noreply,
       put_flash(socket, :error, "Por favor aguarde até o ficheiro ser enviado completamente")}
    end
  end
end
