defmodule Gallium.MembersTest do
  use Gallium.DataCase

  alias Gallium.Members

  describe "cesium_members" do
    alias Gallium.Members.CesiumMember

    import Gallium.MembersFixtures

    @invalid_attrs %{name: nil, member_id: nil, student_number: nil}

    test "list_cesium_members/0 returns all cesium_members" do
      cesium_member = cesium_member_fixture()
      other_cesium_member = cesium_member_fixture(%{student_number: "another_number"})
      assert length(Members.list_cesium_members()) == 2
      assert cesium_member in Members.list_cesium_members()
      assert other_cesium_member in Members.list_cesium_members()
    end

    test "get_cesium_member!/1 returns the cesium_member with given id" do
      cesium_member = cesium_member_fixture()
      assert Members.get_cesium_member!(cesium_member.id) == cesium_member
    end

    test "create_cesium_member/1 with valid data creates a cesium_member" do
      valid_attrs = %{
        name: "some name",
        member_id: "some member_id",
        student_number: "some student_number"
      }

      assert {:ok, %CesiumMember{} = cesium_member} =
               Members.create_cesium_member(valid_attrs)

      assert cesium_member.name == "some name"
      assert cesium_member.member_id == "some member_id"
      assert cesium_member.student_number == "some student_number"
    end

    test "create_cesium_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Members.create_cesium_member(@invalid_attrs)
    end

    test "update_cesium_member/2 with valid data updates the cesium_member" do
      cesium_member = cesium_member_fixture()

      update_attrs = %{
        name: "some updated name",
        member_id: "some updated member_id",
        student_number: "some updated student_number"
      }

      assert {:ok, %CesiumMember{} = cesium_member} =
               Members.update_cesium_member(cesium_member, update_attrs)

      assert cesium_member.name == "some updated name"
      assert cesium_member.member_id == "some updated member_id"
      assert cesium_member.student_number == "some updated student_number"
    end

    test "update_cesium_member/2 with invalid data returns error changeset" do
      cesium_member = cesium_member_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Members.update_cesium_member(cesium_member, @invalid_attrs)

      assert cesium_member == Members.get_cesium_member!(cesium_member.id)
    end

    test "delete_cesium_member/1 deletes the cesium_member" do
      cesium_member = cesium_member_fixture()
      assert {:ok, %CesiumMember{}} = Members.delete_cesium_member(cesium_member)

      assert_raise Ecto.NoResultsError, fn ->
        Members.get_cesium_member!(cesium_member.id)
      end
    end

    test "change_cesium_member/1 returns a cesium_member changeset" do
      cesium_member = cesium_member_fixture()
      assert %Ecto.Changeset{} = Members.change_cesium_member(cesium_member)
    end
  end
end
