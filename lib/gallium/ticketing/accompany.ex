defmodule Gallium.Ticketing.Accompany do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(full_name email phone_number attendee_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accompanies" do
    field :full_name, :string
    field :email, :string
    field :phone_number, :string
    belongs_to :attendee, Gallium.Ticketing.Attendee, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(accompany, attrs) do
    accompany
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
