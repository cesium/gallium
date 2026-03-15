defmodule GalliumWeb.Components.PrimaryButton do
  @moduledoc """
  Button Component.
  """
  use Phoenix.Component

  attr :text, :string, doc: "Button text"
  attr :bgcolor, :string, doc: "Background color"
  attr :textcolor, :string, doc: "Text color"
  attr :icon, :string, default: nil, doc: "Icon to be displayed"

  attr :iconpos, :atom,
    values: [:left, :right, :none],
    default: :none,
    doc: "Position where the icon will be displayed (left, right)"

  attr :link, :string, default: nil, doc: "Link URL"
  attr :rest, :global, doc: "Additional attributes for the button"

  def primary_button(%{link: nil} = assigns) do
    ~H"""
    {button_content(assigns)}
    """
  end

  def primary_button(assigns) do
    ~H"""
    <a href={@link}>
      {button_content(assigns)}
    </a>
    """
  end

  defp button_content(assigns) do
    ~H"""
    <button
      class={[
        "flex w-full h-full items-center justify-center gap-2 rounded-md cursor-pointer",
        @bgcolor,
        @textcolor,
        @rest[:class]
      ]}
      {@rest}
    >
      <%= if @icon && @iconpos == :left do %>
        <span class={@icon} />
      <% end %>
      <p>{@text}</p>
      <%= if @icon && @iconpos == :right do %>
        <span class={@icon} />
      <% end %>
    </button>
    """
  end
end
