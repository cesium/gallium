defmodule GalliumWeb.Components.PrimaryButton do
  @moduledoc """
  Button Component.
  """
  use Phoenix.Component
  import GalliumWeb.CoreComponents

  attr :text, :string, doc: "Button text"
  attr :color, :atom, values: [:olive, :blue, :bronze, :light_muted], default: :olive, doc: "Background color"
  attr :text_color, :atom, values: [:auto, :olive, :blue, :bronze], default: :auto, doc: "Text color"

  @color_classes %{
    olive: "bg-olive text-light-muted hover:bg-olive-700",
    blue: "bg-blue text-light-muted hover:bg-blue-700",
    bronze: "bg-bronze text-light-muted hover:bg-bronze-700",
    light_muted: "bg-light-muted"
  }
  @text_colors %{auto: "text-blue", olive: "text-olive", blue: "text-blue", bronze: "text-bronze"}

  attr :icon, :string, default: nil, doc: "Icon to be displayed"

  attr :iconpos, :atom,
    values: [:left, :right],
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
        "flex w-full h-full items-center justify-center gap-2 px-4 py-2 rounded-md
         cursor-pointer hover:scale-95 transition-all duration-300",
        color_classes(@color, @text_color),
        @rest[:class]
      ]}
      {@rest}
    >
      <%= if @icon && @iconpos == :left do %>
        <.icon name={@icon} />
      <% end %>
      <p>{@text}</p>
      <%= if @icon && @iconpos == :right do %>
        <.icon name={@icon} />
      <% end %>
    </button>
    """
  end

  defp color_classes(:light_muted, color),
    do: [@color_classes.light_muted, Map.fetch!(@text_colors, color)]

  defp color_classes(color, _text_color),
    do: [Map.fetch!(@color_classes, color)]
end
