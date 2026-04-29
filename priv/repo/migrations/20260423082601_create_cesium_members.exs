defmodule Gallium.Repo.Migrations.CreateCesiumMembers do
  use Ecto.Migration

  def change do
    create table(:cesium_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :member_id, :string
      add :student_number, :string

      timestamps(type: :utc_datetime)
    end
  end
end
