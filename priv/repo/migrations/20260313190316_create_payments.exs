defmodule Gallium.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :decimal, null: false
      add :status, :string, default: "pending", null: false
      add :order_id, :string, null: false
      add :mbway_phone, :string, null: false
      add :attendee_id, references(:attendees, on_delete: :nothing, type: :binary_id), null: flase

      timestamps(type: :utc_datetime)
    end
  end
end
