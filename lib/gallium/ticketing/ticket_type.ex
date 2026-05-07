defmodule Gallium.Ticketing.TicketType do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Gallium.Repo

  @required_fields ~w(product_id price type)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_types" do
    field :product_id, :binary_id
    field :price, :decimal
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  def price_for_member do
    Repo.one!(from t in __MODULE__, where: t.type == "member", select: t.price)
    |> Decimal.to_integer()
  end

  def price_for_non_member do
    Repo.one!(from t in __MODULE__, where: t.type == "non_member", select: t.price)
    |> Decimal.to_integer()
  end

  @doc false
  def changeset(ticket_type, attrs) do
    ticket_type
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
