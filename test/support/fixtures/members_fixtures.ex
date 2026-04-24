defmodule Gallium.MembersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gallium.Members` context.
  """

  @doc """
  Generate a cesium_member.
  """
  def cesium_member_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        member_id: "some member_id",
        name: "some name",
        student_number: "some student_number"
      })

    {:ok, cesium_member} = Gallium.Members.create_cesium_member(scope, attrs)
    cesium_member
  end
end
