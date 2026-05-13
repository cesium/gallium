defmodule Gallium.Repo.Seeds.TicketTypes do
  alias Gallium.Repo
  alias Gallium.Ticketing.TicketType

  def run do
    case Repo.all(TicketType) do
      [] ->
        seed_all()

      _ ->
        Mix.shell().error("Found existing ticket types, aborting seeding ticket_types.")
    end
  end

  defp seed_all do
    [
      %{product_id: Ecto.UUID.generate(), price: Decimal.new(52), type: "member"},
      %{product_id: Ecto.UUID.generate(), price: Decimal.new(55), type: "non_member"}
    ]
    |> Enum.each(fn attrs ->
      case Repo.insert(TicketType.changeset(%TicketType{}, attrs)) do
        {:ok, ticket_type} ->
          Mix.shell().info("TicketType created with type: #{ticket_type.type}, price: #{ticket_type.price}")

        {:error, changeset} ->
          Mix.shell().error("Failed to create ticket type: #{inspect(changeset.errors)}")
      end
    end)
  end
end

Gallium.Repo.Seeds.TicketTypes.run()
