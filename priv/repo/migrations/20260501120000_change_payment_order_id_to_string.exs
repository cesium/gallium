defmodule Gallium.Repo.Migrations.ChangePaymentOrderIdToString do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :order_id, :string, null: false
    end
  end
end
