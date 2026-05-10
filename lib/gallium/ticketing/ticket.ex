defmodule Gallium.Ticketing.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(type user_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    field :type, Ecto.Enum, values: [:member, :non_member]
    belongs_to :user, Gallium.Accounts.User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id, name: :tickets_user_id_index)
  end
end
