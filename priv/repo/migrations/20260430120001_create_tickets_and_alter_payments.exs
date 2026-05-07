defmodule Gallium.Repo.Migrations.CreateTicketsAndAlterPayments do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tickets, [:user_id])

    alter table(:payments) do
      remove :mbway_phone, :string
    end
  end
end
