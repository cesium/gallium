defmodule Gallium.Repo.Seeds.CesiumMembers do
  @moduledoc """
  Seeds the cesium_members table with a handful of fake members.

  The list intentionally includes student numbers that overlap with
  attendees seeded in ticketing.exs so that `cesium_member?/1`
  returns `true` for those users.
  """

  alias Gallium.Members
  alias Gallium.Members.CesiumMember
  alias Gallium.Repo

  # student_number must match what ticketing.exs seeds for
  # is_cesium_member: true users (attendees 1–5).
  @members [
    %{name: "Ana Silva",       member_id: "CS001", student_number: "a100001"},
    %{name: "Bruno Costa",     member_id: "CS002", student_number: "a100002"},
    %{name: "Catarina Mendes", member_id: "CS003", student_number: "a100003"},
    %{name: "Diogo Ferreira",  member_id: "CS004", student_number: "a100004"},
    %{name: "Eduarda Pinto",   member_id: "CS005", student_number: "a100005"},
    %{name: "Filipe Rocha",    member_id: "CS006", student_number: "a100006"},
    %{name: "Gabriela Lopes",  member_id: "CS007", student_number: "a100007"},
    %{name: "Henrique Neves",  member_id: "CS008", student_number: "a100008"},
  ]

  def run do
    case Repo.all(CesiumMember) do
      [] ->
        seed_cesium_members()

      _ ->
        Mix.shell().error("Found existing cesium members, aborting seeding.")
    end
  end

  # ── Private ────────────────────────────────────────────────────────────────

  defp seed_cesium_members() do
    Enum.each(@members, fn attrs ->
      case Members.create_cesium_member(attrs) do
        {:ok, member} ->
          Mix.shell().info("CesiumMember created: #{member.name} (#{member.member_id})")

        {:error, changeset} ->
          Mix.shell().error("Failed to create cesium member: #{inspect(changeset.errors)}")
      end
    end)

    Mix.shell().info("#{length(@members)} cesium members seeded.")
  end
end

Gallium.Repo.Seeds.CesiumMembers.run()
