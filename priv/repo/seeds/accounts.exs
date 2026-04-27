defmodule Gallium.Repo.Seeds.Accounts do
  @moduledoc """
  Seeds user accounts: one admin and a set of regular attendee-type users.

  Admin credentials  → admin@gallium.pt / password1234
  Attendee pattern   → attendeeN@gallium.pt / password1234
  """

  alias Gallium.Accounts
  alias Gallium.Accounts.User
  alias Gallium.Repo

  @admin_email "admin@gallium.pt"
  @attendee_count 10
  @password "password1234"

  def run do
    case Repo.all(User) do
      [] ->
        seed_admin()
        seed_attendees()

      _ ->
        Mix.shell().error("Found existing users, aborting seeding accounts.")
    end
  end

  # ── Admin ──────────────────────────────────────────────────────────────────

  defp seed_admin do
    case insert_user(@admin_email, "admin") do
      {:ok, user} ->
        confirm_user(user)
        Mix.shell().info("Admin created: #{@admin_email}")

      {:error, changeset} ->
        Mix.shell().error("Failed to create admin: #{inspect(changeset.errors)}")
    end
  end

  # ── Attendees ──────────────────────────────────────────────────────────────

  defp seed_attendees do
    for i <- 1..@attendee_count do
      email = "attendee#{i}@gallium.pt"

      case insert_user(email, "attendee") do
        {:ok, user} ->
          confirm_user(user)

        {:error, changeset} ->
          Mix.shell().error("Failed to create attendee #{email}: #{inspect(changeset.errors)}")
      end
    end

    Mix.shell().info("#{@attendee_count} attendee users created.")
  end

  # ── Helpers ────────────────────────────────────────────────────────────────

  defp insert_user(email, type) do
    %User{type: type}
    |> User.email_changeset(%{email: email})
    |> User.password_changeset(%{password: @password})
    |> Repo.insert()
  end

  defp confirm_user(user) do
    user
    |> User.confirm_changeset()
    |> Repo.update!()
  end
end

Gallium.Repo.Seeds.Accounts.run()
