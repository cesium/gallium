defmodule Gallium.Repo.Migrations.CreateAttendees do
  use Ecto.Migration

  def change do
    create table(:attendees, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :phone_number, :string, null: false
      add :student_number, :string
      add :nif, :string
      add :is_cesium_member, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
