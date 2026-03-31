defmodule Gallium.Ticketing.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(amount status order_id mbway_phone attendee_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :decimal
    field :status, Ecto.Enum, values: [:pending, :paid, :failed], default: :pending
    field :order_id, :string
    field :mbway_phone, :string
    belongs_to :attendee, Gallium.Ticketing.Attendee, type: :binary_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
