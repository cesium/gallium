defmodule Gallium.Ticketing.CheckoutForm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Gallium.Accounts
  alias Gallium.Members

  @primary_key false
  embedded_schema do
    field :full_name, :string
    field :student_number, :string
    field :phone_number, :string
    field :nif, :string
    field :mbway_number, :string
    field :is_cesium_member, :boolean
    field :wants_transport, :boolean, default: false
    field :table_preference, :string
    field :allergies, :string

    embeds_one :accompany, AccompanyForm, primary_key: false, on_replace: :delete do
      field :full_name, :string
      field :email, :string
      field :phone_number, :string
    end
  end

  def changeset_personal_data(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [
      :full_name,
      :student_number,
      :phone_number,
      :nif,
      :is_cesium_member,
      :wants_transport,
      :table_preference,
      :allergies
    ])
    |> validate_required([:full_name, :student_number, :phone_number, :is_cesium_member],
      message: "Este campo é obrigatório"
    )
    |> validate_length(:full_name, min: 3, message: "O nome tem de ter pelo menos 3 letras")
    |> validate_format(:phone_number, ~r/^\+?\d{9,15}$/, message: "Número de telefone inválido")
    |> validate_format(:student_number, ~r/^(a\d{1,6}|pg\d{1,5}|e\d{1,6})$/i,
      message: "Formato inválido (ex: A12345, PG1234, E12345)"
    )
    |> validate_cesium_member(:student_number, :is_cesium_member)
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

  def changeset_payment(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:mbway_number])
    |> validate_required([:mbway_number], message: "Este campo é obrigatório")
    |> validate_format(:mbway_number, ~r/^\+?\d{9,15}$/, message: "Formato de número inválido")
  end

  def validate_cesium_member(changeset, student_number_field, is_cesium_member_field) do
    student_number_value = get_field(changeset, student_number_field)

    if is_binary(student_number_value) do
      formatted_number = format_student_number(student_number_value)
      is_member_claimed = get_field(changeset, is_cesium_member_field)

      check_already_used(
        changeset,
        formatted_number,
        is_member_claimed,
        student_number_field,
        is_cesium_member_field
      )
    else
      changeset
    end
  end

  defp format_student_number(number) do
    number
    |> String.trim()
    |> String.downcase()
  end

  defp check_already_used(
         changeset,
         formatted_number,
         is_member_claimed,
         number_field,
         member_field
       ) do
    if Accounts.student_number_already_used?(formatted_number) do
      add_error(
        changeset,
        number_field,
        "Este número de estudante já foi usado para comprar um bilhete."
      )
    else
      apply_membership_rules(
        changeset,
        formatted_number,
        is_member_claimed,
        number_field,
        member_field
      )
    end
  end

  defp apply_membership_rules(changeset, formatted_number, true, number_field, _member_field) do
    if Members.cesium_member?(formatted_number) do
      put_change(changeset, number_field, formatted_number)
    else
      add_error(
        changeset,
        number_field,
        "O número de estudante não corresponde a um sócio válido do CeSIUM."
      )
    end
  end

  defp apply_membership_rules(
         changeset,
         formatted_number,
         _claimed_false,
         number_field,
         member_field
       ) do
    if Members.cesium_member?(formatted_number) do
      changeset
      |> put_change(member_field, true)
      |> put_change(number_field, formatted_number)
    else
      changeset
    end
  end
end
