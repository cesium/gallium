defmodule Gallium.Repo.Migrations.CreateTicketTypes do
  use Ecto.Migration

  def change do
    create table(:ticket_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, :binary_id, null: false
      add :price, :decimal, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
