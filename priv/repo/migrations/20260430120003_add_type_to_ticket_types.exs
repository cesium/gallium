defmodule Gallium.Repo.Migrations.AddTypeToTicketTypes do
  use Ecto.Migration

  def change do
    alter table(:ticket_types) do
      add :type, :string, null: false, default: "non_member"
    end
  end
end
