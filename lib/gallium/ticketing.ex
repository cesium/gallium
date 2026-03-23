defmodule Gallium.Ticketing do
  @moduledoc """
  The Ticketing context.
  """

  import Ecto.Query, warn: false
  alias Gallium.Repo

  alias Gallium.Ticketing.{Accompany, Attendee, Payment}

  @doc """
  Returns the list of accompanies.

  ## Examples

      iex> list_accompanies()
      [%Accompany{}, ...]

  """
  def list_accompanies do
    Repo.all(Accompany)
  end

  @doc """
  Gets a single accompany.

  Raises `Ecto.NoResultsError` if the Accompany does not exist.

  ## Examples

      iex> get_accompany!(123)
      %Accompany{}

      iex> get_accompany!(456)
      ** (Ecto.NoResultsError)

  """
  def get_accompany!(id), do: Repo.get!(Accompany, id)

  @doc """
  Creates a accompany.

  ## Examples

      iex> create_accompany(%{field: value})
      {:ok, %Accompany{}}

      iex> create_accompany(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_accompany(attrs) do
    %Accompany{}
    |> Accompany.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a accompany.

  ## Examples

      iex> update_accompany(accompany, %{field: new_value})
      {:ok, %Accompany{}}

      iex> update_accompany(accompany, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_accompany(%Accompany{} = accompany, attrs) do
    accompany
    |> Accompany.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a accompany.

  ## Examples

      iex> delete_accompany(accompany)
      {:ok, %Accompany{}}

      iex> delete_accompany(accompany)
      {:error, %Ecto.Changeset{}}

  """
  def delete_accompany(%Accompany{} = accompany) do
    Repo.delete(accompany)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking accompany changes.

  ## Examples

      iex> change_accompany(accompany)
      %Ecto.Changeset{data: %Accompany{}}

  """
  def change_accompany(%Accompany{} = accompany, attrs \\ %{}) do
    Accompany.changeset(accompany, attrs)
  end

  alias Gallium.Ticketing.Payment

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{data: %Payment{}}

  """
  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  alias Gallium.Ticketing.Attendee

  @doc """
  Returns the list of attendees.

  ## Examples

      iex> list_attendees()
      [%Attendee{}, ...]

  """
  def list_attendees do
    Repo.all(Attendee)
  end

  @doc """
  Gets a single attendee.

  Raises `Ecto.NoResultsError` if the Attendee does not exist.

  ## Examples

      iex> get_attendee!(123)
      %Attendee{}

      iex> get_attendee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attendee!(id), do: Repo.get!(Attendee, id)

  @doc """
  Creates a attendee.

  ## Examples

      iex> create_attendee(%{field: value})
      {:ok, %Attendee{}}

      iex> create_attendee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attendee(attrs) do
    %Attendee{}
    |> Attendee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attendee.

  ## Examples

      iex> update_attendee(attendee, %{field: new_value})
      {:ok, %Attendee{}}

      iex> update_attendee(attendee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attendee(%Attendee{} = attendee, attrs) do
    attendee
    |> Attendee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a attendee.

  ## Examples

      iex> delete_attendee(attendee)
      {:ok, %Attendee{}}

      iex> delete_attendee(attendee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attendee(%Attendee{} = attendee) do
    Repo.delete(attendee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attendee changes.

  ## Examples

      iex> change_attendee(attendee)
      %Ecto.Changeset{data: %Attendee{}}

  """
  def change_attendee(%Attendee{} = attendee, attrs \\ %{}) do
    Attendee.changeset(attendee, attrs)
  end

  def process_ticket_purchase(form_data, amount_to_pay, has_accompany?)do
    attendee_changeset = Attendee.changeset(%Attendee{}, %{
      full_name: form_data.full_name,
      email: form_data.email,
      phone_number: form_data.phone_number,
      student_number: form_data.student_number,
      nif: form_data.nif,
      is_cesium_member: form_data.is_cesium_member
    })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:attendee, attendee_changeset)
    |> Ecto.Multi.run(:accompany, fn repo, %{attendee: attendee} ->
      if has_accompany? do
        accompany_attrs = %{
          attendee_id: attendee.id,
          full_name: form_data.accompany.full_name,
          email: form_data.accompany.email,
          phone_number: form_data.accompany.phone_number
        }
        repo.insert(Accompany.changeset(%Accompany{}, accompany_attrs))
      else
        {:ok, nil}
      end
    end)
    |> Ecto.Multi.run(:payment, fn repo, %{attendee: attendee} ->
      payment_attrs = %{
        attendee_id: attendee.id,
        amount: amount_to_pay,
        status: "paid",
        mbway_phone: form_data.mbway_number,
        order_id: "MOCK_" <> Ecto.UUID.generate()
      }
      repo.insert(Payment.changeset(%Payment{}, payment_attrs))
    end)
    |> Repo.transaction()
  end

end
