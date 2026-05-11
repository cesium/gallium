defmodule Gallium.Ticketing do
  @moduledoc """
  The Ticketing context.
  """

  import Ecto.Query, warn: false
  alias Gallium.Repo

  alias Gallium.Ticketing.{Accompany, Attendee, Payment, Ticket, TicketType}

  @pubsub Gallium.PubSub

  @doc """
  Returns all attendees with their payment and accompany preloaded.
  """
  def list_attendees_with_details do
    Attendee
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
    |> Repo.preload([:payment, :accompany, user: :ticket])
  end

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

  def get_attendee_by_user_id(user_id) do
    Repo.get_by(Attendee, user_id: user_id)
  end

  def get_purchase_by_user_id(user_id) do
    attendee =
      Attendee
      |> Repo.get_by(user_id: user_id)
      |> Repo.preload([:accompany, :payment])

    ticket = Repo.get_by(Ticket, user_id: user_id)

    %{attendee: attendee, ticket: ticket}
  end

  def create_booking(form_data, has_accompany?, user_id) do
    data =
      form_data
      |> Map.from_struct()
      |> Map.put(:user_id, user_id)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:attendee, Attendee.changeset(%Attendee{}, data))
    |> Ecto.Multi.run(:ticket, fn repo, _changes ->
      insert_ticket(repo, user_id, form_data)
    end)
    |> Ecto.Multi.run(:accompany, fn repo, %{attendee: attendee} ->
      insert_accompany(repo, attendee, form_data, has_accompany?)
    end)
    |> Repo.transaction()
  end

  def start_payment(:mbway, attendee, user, form_data, amount, has_accompany?) do
    ticket_type_name = if form_data.is_cesium_member, do: "member", else: "non_member"
    ticket_type = Repo.get_by!(TicketType, type: ticket_type_name)

    with :ok <- validate_midas_config(ticket_type) do
      quantity = if has_accompany?, do: 2, else: 1
      nif = if form_data.nif in [nil, ""], do: nil, else: form_data.nif

      case Req.post(midas_api_url() <> "/orders",
             headers: [{"authorization", "Bearer " <> midas_api_key()}],
             json: %{
               order: %{
                 lines: [
                   %{
                     product_id: ticket_type.product_id,
                     quantity: quantity,
                     discount: 0
                   }
                 ],
                 customer_email: user.email,
                 customer_name: attendee.full_name,
                 customer_tax_id: nif,
                 payment: %{
                   method: "mbway",
                   phone_number: form_data.mbway_number
                 },
                 message: "CeSIUM - Jantar de Gala 2026 Bilhete",
                 extra_fields: %{attendee_id: attendee.id}
               }
             }
           ) do
        {:ok, %Req.Response{status: 201, body: body}} ->
          to_string(body["id"])
          |> upsert_payment(attendee.id, amount)
          |> broadcast_payment_order_update()

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, %{status: status, body: body}}

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  defp validate_midas_config(ticket_type) do
    cond do
      not is_binary(midas_api_url()) ->
        {:error, :missing_midas_api_url}

      is_nil(ticket_type.product_id) ->
        {:error, :missing_ticket_product_id}

      not is_binary(midas_api_key()) or midas_api_key() == "" ->
        {:error, :missing_midas_api_key}

      true ->
        :ok
    end
  end

  def get_payment_by_order_id(order_id) do
    Repo.get_by(Payment, order_id: order_id)
  end

  def mark_payment_paid(order_id) do
    case get_payment_by_order_id(order_id) do
      nil ->
        {:error, :not_found}

      payment ->
        payment
        |> Ecto.Changeset.change(status: :paid)
        |> Repo.update()
        |> broadcast_payment_order_update()
    end
  end

  def subscribe_to_payment_order_updates(order_id) do
    Phoenix.PubSub.subscribe(@pubsub, "payment_order:#{order_id}")
  end

  defp upsert_payment(order_id, attendee_id, amount) do
    case Repo.get_by(Payment, attendee_id: attendee_id) do
      nil ->
        create_payment(%{
          attendee_id: attendee_id,
          amount: amount,
          order_id: order_id,
          status: :pending
        })

      existing ->
        existing
        |> Ecto.Changeset.change(order_id: order_id, amount: amount, status: :pending)
        |> Repo.update()
    end
  end

  defp broadcast_payment_order_update({:ok, %Payment{} = payment} = result) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      "payment_order:#{payment.order_id}",
      {:payment_order_updated, payment}
    )

    result
  end

  defp broadcast_payment_order_update({:error, _} = result), do: result

  defp midas_api_url, do: Application.fetch_env!(:gallium, :midas)[:midas_api_url]
  defp midas_api_key, do: Application.fetch_env!(:gallium, :midas)[:midas_api_key]

  defp insert_accompany(repo, attendee, %{accompany: accompany}, true)
       when not is_nil(accompany) do
    accompany_attrs = %{
      attendee_id: attendee.id,
      full_name: accompany.full_name,
      email: accompany.email,
      phone_number: accompany.phone_number
    }

    repo.insert(Accompany.changeset(%Accompany{}, accompany_attrs))
  end

  defp insert_accompany(_repo, _attendee, _form_data, true), do: {:error, :missing_accompany}
  defp insert_accompany(_repo, _attendee, _form_data, false), do: {:ok, nil}

  defp insert_ticket(repo, user_id, form_data) do
    ticket_type = if form_data.is_cesium_member, do: :member, else: :non_member

    ticket_attrs = %{
      user_id: user_id,
      type: ticket_type
    }

    repo.insert(Ticket.changeset(%Ticket{}, ticket_attrs))
  end
end
