defmodule Gallium.Repo.Migrations.ChangeAttendeesWantsTransportDefault do
  use Ecto.Migration

  def change do
    alter table(:attendees) do
      modify :wants_transport, :boolean, null: false, default: true
    end
  end
end
