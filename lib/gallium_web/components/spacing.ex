defmodule GalliumWeb.Components.Spacing do
  use Phoenix.Component

  def spacing(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl space-y-4">
      <main class="px-4 py-20 sm:px-6 lg:px-8">
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end
end
