defmodule GalliumWeb.BackOffice.Components.Sidebar do
  @moduledoc false
  use GalliumWeb, :component

  attr :current_page, :atom, required: true
  attr :sidebar_open, :boolean, default: false

  def sidebar(assigns) do
    menu_items = [
      %{
        action: :attendees,
        icon: "hero-users",
        label: "Inscrições",
        path: ~p"/dashboard/attendees"
      },
      %{
        action: :tables,
        icon: "hero-rectangle-group",
        label: "Mesas",
        path: ~p"/dashboard/tables"
      },
      %{
        action: :members,
        icon: "hero-arrow-up-tray",
        label: "Sócios",
        path: ~p"/dashboard/members"
      }
    ]

    assigns = assign(assigns, :menu_items, menu_items)

    ~H"""
    <nav class={[
      "fixed left-0 top-0 h-screen w-64 flex-shrink-0 md:relative md:h-auto md:border-r-2 md:border-gray-300 z-50 transition-transform duration-300 overflow-y-auto bg-white md:bg-transparent",
      if(@sidebar_open, do: "translate-x-0", else: "-translate-x-full md:translate-x-0")
    ]}>
      <div class="md:hidden px-4 py-3 border-b border-gray-200 flex items-center justify-end">
        <button
          phx-click="toggle_sidebar"
          class="hover:bg-gray-300 px-2 py-1 rounded-md"
        >
          <.icon name="hero-x-mark" class="h-5 w-5" />
        </button>
      </div>

      <div class="w-full flex flex-col">
        <div class="w-full px-4 mt-6 mb-6 md:flex md:justify-center">
          <.link
            navigate={~p"/dashboard"}
            class="text-left text-olive uppercase tracking-wider text-xs font-bold font-amarante md:text-2xl hover:opacity-70 transition-opacity"
          >
            Backoffice
          </.link>
        </div>
        <%= for item <- @menu_items do %>
          <.link
            navigate={item.path}
            class={[
              if(@current_page == item.action,
                do: "bg-olive text-white font-bold hover:brightness-95",
                else: "hover:bg-gray-300"
              ),
              "font-cormorant w-full flex py-3 items-center justify-start px-4 transition-all focus:outline-none"
            ]}
          >
            <.icon name={item.icon} class="h-5 w-5" />
            <span class="ml-2">{item.label}</span>
          </.link>
        <% end %>
      </div>
    </nav>
    """
  end
end
