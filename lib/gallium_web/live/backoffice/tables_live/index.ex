defmodule GalliumWeb.BackOffice.TablesLive.Index do
  @moduledoc """
  LiveView showing seating arrangement: one rectangle per table with avatars
  for each person around it.
  """
  use GalliumWeb, :live_view

  import GalliumWeb.BackOffice.Components.BackofficeLayout

  alias Gallium.Ticketing

  attr :name, :string, required: true
  attr :people, :list, required: true

  def table_card(assigns) do
    {top, bottom} = split_people(assigns.people)
    assigns = assigns |> assign(:top, top) |> assign(:bottom, bottom)

    ~H"""
    <div class="bg-white rounded-xl border border-gray-200 shadow-sm px-6 py-8">
      <div class="flex flex-col items-center gap-3">
        <div class="flex justify-center gap-3 min-h-10">
          <.avatar :for={person <- @top} person={person} />
        </div>

        <div class="w-full max-w-md h-28 rounded-lg bg-olive text-white flex items-center justify-center shadow-inner">
          <span class="font-amarante text-2xl uppercase tracking-widest">{@name}</span>
        </div>

        <div class="flex justify-center gap-3 min-h-10">
          <.avatar :for={person <- @bottom} person={person} />
        </div>
      </div>
    </div>
    """
  end

  attr :person, :map, required: true

  defp avatar(assigns) do
    ~H"""
    <div class="relative group">
      <div
        class="w-10 h-10 rounded-full bg-olive-100 text-olive-700 border border-olive-200 flex items-center justify-center font-amarante text-sm font-bold cursor-default select-none"
        title={@person.full_name}
      >
        {@person.initials}
      </div>
      <span class="pointer-events-none absolute left-1/2 -translate-x-1/2 -top-9 whitespace-nowrap rounded bg-gray-900 text-white text-xs px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity font-cormorant z-10">
        {@person.full_name}
      </span>
    </div>
    """
  end

  defp split_people(people) do
    count = length(people)
    half = div(count + 1, 2)
    Enum.split(people, half)
  end

  def mount(_params, _session, socket) do
    tables =
      Ticketing.list_tables_with_attendees()
      |> Enum.map(fn {name, people} ->
        %{
          name: name,
          people: Enum.map(people, fn p -> Map.put(p, :initials, initials(p.full_name)) end)
        }
      end)

    socket =
      socket
      |> assign(:current_page, :tables)
      |> assign(:sidebar_open, false)
      |> assign(:tables, tables)

    {:ok, socket}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  defp initials(nil), do: "?"

  defp initials(full_name) do
    parts =
      full_name
      |> String.split(~r/\s+/, trim: true)
      |> Enum.reject(&(&1 == ""))

    case parts do
      [] ->
        "?"

      [one] ->
        String.upcase(String.slice(one, 0, 1))

      list ->
        String.upcase(String.slice(List.first(list), 0, 1) <> String.slice(List.last(list), 0, 1))
    end
  end
end
