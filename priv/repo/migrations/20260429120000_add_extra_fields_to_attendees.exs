defmodule Gallium.Repo.Migrations.AddExtraFieldsToAttendees do
  use Ecto.Migration

  def change do
    alter table(:attendees) do
      add :wants_transport, :boolean, null: false, default: false
      add :table_preference, :string
      add :allergies, :string
    end
  end
end
