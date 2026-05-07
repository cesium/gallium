defmodule Gallium.Ticketing.Attendee do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(full_name phone_number is_cesium_member wants_transport user_id)a
  @optional_fields ~w(student_number nif table_preference allergies)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attendees" do
    field :full_name, :string
    field :phone_number, :string
    field :student_number, :string
    field :nif, :string
    field :is_cesium_member, :boolean, default: false
    field :wants_transport, :boolean, default: false
    field :table_preference, :string
    field :allergies, :string
    belongs_to :user, Gallium.Accounts.User, type: :binary_id

    has_one :accompany, Gallium.Ticketing.Accompany
    has_one :payment, Gallium.Ticketing.Payment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attendee, attrs) do
    attendee
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
