defmodule Gallium.MembersTest do
  use Gallium.DataCase

  alias Gallium.Members

  describe "cesium_members" do
    alias Gallium.Members.CesiumMember

    import Gallium.AccountsFixtures, only: [user_scope_fixture: 0]
    import Gallium.MembersFixtures

    @invalid_attrs %{name: nil, member_id: nil, student_number: nil}

    test "list_cesium_members/1 returns all scoped cesium_members" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)
      other_cesium_member = cesium_member_fixture(other_scope)
      assert Members.list_cesium_members(scope) == [cesium_member]
      assert Members.list_cesium_members(other_scope) == [other_cesium_member]
    end

    test "get_cesium_member!/2 returns the cesium_member with given id" do
      scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)
      other_scope = user_scope_fixture()
      assert Members.get_cesium_member!(scope, cesium_member.id) == cesium_member

      assert_raise Ecto.NoResultsError, fn ->
        Members.get_cesium_member!(other_scope, cesium_member.id)
      end
    end

    test "create_cesium_member/2 with valid data creates a cesium_member" do
      valid_attrs = %{
        name: "some name",
        member_id: "some member_id",
        student_number: "some student_number"
      }

      scope = user_scope_fixture()

      assert {:ok, %CesiumMember{} = cesium_member} =
               Members.create_cesium_member(scope, valid_attrs)

      assert cesium_member.name == "some name"
      assert cesium_member.member_id == "some member_id"
      assert cesium_member.student_number == "some student_number"
      assert cesium_member.user_id == scope.user.id
    end

    test "create_cesium_member/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Members.create_cesium_member(scope, @invalid_attrs)
    end

    test "update_cesium_member/3 with valid data updates the cesium_member" do
      scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        member_id: "some updated member_id",
        student_number: "some updated student_number"
      }

      assert {:ok, %CesiumMember{} = cesium_member} =
               Members.update_cesium_member(scope, cesium_member, update_attrs)

      assert cesium_member.name == "some updated name"
      assert cesium_member.member_id == "some updated member_id"
      assert cesium_member.student_number == "some updated student_number"
    end

    test "update_cesium_member/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)

      assert_raise MatchError, fn ->
        Members.update_cesium_member(other_scope, cesium_member, %{})
      end
    end

    test "update_cesium_member/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Members.update_cesium_member(scope, cesium_member, @invalid_attrs)

      assert cesium_member == Members.get_cesium_member!(scope, cesium_member.id)
    end

    test "delete_cesium_member/2 deletes the cesium_member" do
      scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)
      assert {:ok, %CesiumMember{}} = Members.delete_cesium_member(scope, cesium_member)

      assert_raise Ecto.NoResultsError, fn ->
        Members.get_cesium_member!(scope, cesium_member.id)
      end
    end

    test "delete_cesium_member/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)
      assert_raise MatchError, fn -> Members.delete_cesium_member(other_scope, cesium_member) end
    end

    test "change_cesium_member/2 returns a cesium_member changeset" do
      scope = user_scope_fixture()
      cesium_member = cesium_member_fixture(scope)
      assert %Ecto.Changeset{} = Members.change_cesium_member(scope, cesium_member)
    end
  end
end
