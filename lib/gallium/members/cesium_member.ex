defmodule Gallium.Members.CesiumMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cesium_members" do
    field :name, :string
    field :member_id, :string
    field :student_number, :string
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cesium_member, attrs, user_scope) do
    cesium_member
    |> cast(attrs, [:name, :member_id, :student_number])
    |> validate_required([:name, :member_id, :student_number])
    |> put_change(:user_id, user_scope.user.id)
  end
end
