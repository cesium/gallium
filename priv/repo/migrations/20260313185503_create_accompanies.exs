defmodule Gallium.Repo.Migrations.CreateAccompanies do
  use Ecto.Migration

  def change do
    create table(:accompanies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :phone_number, :string, null: false

      add :attendee_id, references(:attendees, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end
  end
end
