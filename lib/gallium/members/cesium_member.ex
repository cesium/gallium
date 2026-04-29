defmodule Gallium.Members.CesiumMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cesium_members" do
    field :name, :string
    field :member_id, :string
    field :student_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cesium_member, attrs) do
    cesium_member
    |> cast(attrs, [:name, :member_id, :student_number])
    |> validate_required([:name, :member_id, :student_number])
  end
end
