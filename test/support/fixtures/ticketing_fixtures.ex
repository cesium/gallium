defmodule Gallium.TicketingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gallium.Ticketing` context.
  """

  @doc """
  Generate a attendee.
  """
  def attendee_fixture(attrs \\ %{}) do
    {:ok, attendee} =
      attrs
      |> Enum.into(%{
        # Email único para evitar erros de duplicado
        email: "some email #{System.unique_integer()}",
        full_name: "some full_name",
        nif: "some nif",
        phone_number: "some phone_number",
        student_number: "some student_number"
      })
      |> Gallium.Ticketing.create_attendee()

    attendee
  end

  @doc """
  Generate a accompany.
  """
  def accompany_fixture(attrs \\ %{}) do
    # Se não passares um attendee_id, criamos um attendee agora
    attendee_id = Map.get(attrs, :attendee_id) || attendee_fixture().id

    {:ok, accompany} =
      attrs
      |> Enum.into(%{
        email: "accompany#{System.unique_integer()}@example.com",
        full_name: "some full_name",
        phone_number: "some phone_number",
        attendee_id: attendee_id
      })
      |> Gallium.Ticketing.create_accompany()

    accompany
  end

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    # Se não passares um attendee_id, criamos um attendee agora
    attendee_id = Map.get(attrs, :attendee_id) || attendee_fixture().id

    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        order_id: "some order_id",
        # Mudado para átomo (Enum)
        status: :pending,
        # Campo obrigatório adicionado
        mbway_phone: "912345678",
        # Campo obrigatório adicionado
        attendee_id: attendee_id
      })
      |> Gallium.Ticketing.create_payment()

    payment
  end
end
