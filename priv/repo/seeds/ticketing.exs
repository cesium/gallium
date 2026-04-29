defmodule Gallium.Repo.Seeds.Ticketing do
  @moduledoc """
  Seeds the ticketing tables: attendees, accompanies, and payments.

  One Attendee record is created for each regular attendee user
  (attendee1@gallium.pt ... attendee10@gallium.pt).

  Rules applied:
    - Attendees 1-5  -> is_cesium_member: true, student numbers match cesium_members.exs
    - Attendees 6-10 -> is_cesium_member: false
    - Attendees 1-3  -> include an Accompany

  Pricing:
    - Socio sem acompanhante  -> 25.00
    - Socio com acompanhante  -> 50.00
    - Normal sem acompanhante -> 30.00
    - Normal com acompanhante -> 60.00
  """

  alias Gallium.Accounts
  alias Gallium.Ticketing

  @student_numbers %{
    1  => "a100001",
    2  => "a100002",
    3  => "a100003",
    4  => "a100004",
    5  => "a100005",
    6  => "a100006",
    7  => "a100007",
    8  => "a100008",
    9  => "a100009",
    10 => "a100010"
  }

  @accompany_data %{
    1 => %{full_name: "Acompanhante de Ana",      email: "acomp1@example.com", phone_number: "+351910000001"},
    2 => %{full_name: "Acompanhante de Bruno",    email: "acomp2@example.com", phone_number: "+351910000002"},
    3 => %{full_name: "Acompanhante de Catarina", email: "acomp3@example.com", phone_number: "+351910000003"}
  }

  def run do
    case Ticketing.list_attendees() do
      [] ->
        seed_all()

      _ ->
        Mix.shell().error("Found existing attendees, aborting seeding ticketing.")
    end
  end

  # -- Orchestration ----------------------------------------------------------

  defp seed_all do
    for i <- 1..10 do
      email = "attendee#{i}@gallium.pt"

      case Accounts.get_user_by_email(email) do
        nil ->
          Mix.shell().error("User #{email} not found; run accounts seed first.")

        user ->
          attendee = seed_attendee(i, user.id)
          if attendee, do: seed_payment(i, attendee)
          if attendee, do: maybe_seed_accompany(i, attendee)
      end
    end

    Mix.shell().info("Ticketing records seeded.")
  end

  # -- Attendee ---------------------------------------------------------------

  defp seed_attendee(index, user_id) do
    is_member = index <= 5

    attrs = %{
      full_name:        "Attendee #{index}",
      phone_number:     "+35191000000#{index}",
      is_cesium_member: is_member,
      user_id:          user_id,
      student_number:   @student_numbers[index],
      nif:              "20000000#{index}"
    }

    case Ticketing.create_attendee(attrs) do
      {:ok, attendee} ->
        Mix.shell().info("Attendee created for attendee#{index}@gallium.pt")
        attendee

      {:error, changeset} ->
        Mix.shell().error("Failed to create attendee #{index}: #{inspect(changeset.errors)}")
        nil
    end
  end

  # -- Payment ----------------------------------------------------------------

  defp seed_payment(index, attendee) do
    is_member     = index <= 5
    has_accompany = Map.has_key?(@accompany_data, index)

    amount =
      cond do
        is_member and has_accompany -> Decimal.new("50.00")
        is_member                   -> Decimal.new("25.00")
        has_accompany               -> Decimal.new("60.00")
        true                        -> Decimal.new("30.00")
      end

    attrs = %{
      attendee_id: attendee.id,
      amount:      amount,
      status:      :paid,
      mbway_phone: attendee.phone_number,
      order_id:    "SEED_#{String.pad_leading(Integer.to_string(index), 4, "0")}_#{Ecto.UUID.generate()}"
    }

    case Ticketing.create_payment(attrs) do
      {:ok, _payment} ->
        Mix.shell().info("Payment created for attendee #{index} (#{amount})")

      {:error, changeset} ->
        Mix.shell().error("Failed to create payment #{index}: #{inspect(changeset.errors)}")
    end
  end

  # -- Accompany --------------------------------------------------------------

  defp maybe_seed_accompany(index, attendee) when is_map_key(@accompany_data, index) do
    attrs =
      @accompany_data
      |> Map.fetch!(index)
      |> Map.put(:attendee_id, attendee.id)

    case Ticketing.create_accompany(attrs) do
      {:ok, _accompany} ->
        Mix.shell().info("Accompany created for attendee #{index}")

      {:error, changeset} ->
        Mix.shell().error("Failed to create accompany #{index}: #{inspect(changeset.errors)}")
    end
  end

  defp maybe_seed_accompany(_index, _attendee), do: :ok
end

Gallium.Repo.Seeds.Ticketing.run()
