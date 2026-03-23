defmodule Gallium.Ticketing.CheckoutForm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :full_name, :string
    field :email, :string
    field :student_number, :string
    field :phone_number, :string
    field :nif, :string
    field :mbway_number, :string
    field :is_cesium_member, :boolean

    embeds_one :accompany, AccompanyForm, primary_key: false do
      field :full_name, :string
      field :email, :string
      field :phone_number, :string
    end
  end

  def changeset_fase1(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:full_name, :email, :student_number, :phone_number, :nif, :is_cesium_member])
    |> validate_required([:full_name, :email, :phone_number, :is_cesium_member],
      message: "Este campo é obrigatório"
    )
    |> validate_length(:full_name, min: 3, message: "O nome tem de ter pelo menos 3 letras")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "Formato de email inválido")
    |> validate_format(:phone_number, ~r/^\+?\d{9,15}$/, message: "Número de telefone inválido")
    |> validate_format(:student_number, ~r/^(A|PG|a|pg)\d+$/,
      message: "Formato inválido (ex: A12345)"
    )
    |> validate_format(:nif, ~r/^\d{9}$/, message: "O NIF tem de ter exatamente 9 números")
    |> cast_embed(:accompany, with: &accompany_changeset/2)
  end

  defp accompany_changeset(schema, attrs) do
    schema
    |> cast(attrs, [:full_name, :email, :phone_number])
    |> validate_required([:full_name, :email, :phone_number], message: "Este campo é obrigatório")
    |> validate_length(:full_name, min: 3, message: "O nome tem de ter pelo menos 3 letras")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "Formato de email inválido")
    |> validate_format(:phone_number, ~r/^\+?\d{9,15}$/, message: "Número de telefone inválido")
  end

  def changeset_fase3(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:mbway_number])
    |> validate_required([:mbway_number], message: "Este campo é obrigatório")
    |> validate_format(:mbway_number, ~r/^\+?\d{9,15}$/, message: "Formato de número inválido")
  end
end
