defmodule Gallium.TicketingTest do
  use Gallium.DataCase

  alias Gallium.Ticketing

  describe "accompanies" do
    alias Gallium.Ticketing.Accompany
    import Gallium.TicketingFixtures

    # Removido student_number pois não existe no schema Accompany
    @invalid_attrs %{full_name: nil, email: nil, phone_number: nil}

    test "list_accompanies/0 returns all accompanies" do
      accompany = accompany_fixture()
      assert Ticketing.list_accompanies() == [accompany]
    end

    test "get_accompany!/1 returns the accompany with given id" do
      accompany = accompany_fixture()
      assert Ticketing.get_accompany!(accompany.id) == accompany
    end

    test "create_accompany/1 with valid data creates a accompany" do
      # Precisamos de um attendee para associar o acompanhante
      attendee = attendee_fixture()

      valid_attrs = %{
        full_name: "some full_name",
        email: "some email",
        phone_number: "some phone_number",
        attendee_id: attendee.id
      }

      assert {:ok, %Accompany{} = accompany} = Ticketing.create_accompany(valid_attrs)
      assert accompany.full_name == "some full_name"
      assert accompany.email == "some email"
      assert accompany.phone_number == "some phone_number"
    end

    test "create_accompany/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ticketing.create_accompany(@invalid_attrs)
    end

    test "update_accompany/2 with valid data updates the accompany" do
      accompany = accompany_fixture()

      update_attrs = %{
        full_name: "some updated full_name",
        email: "some updated email",
        phone_number: "some updated phone_number"
      }

      assert {:ok, %Accompany{} = accompany} = Ticketing.update_accompany(accompany, update_attrs)
      assert accompany.full_name == "some updated full_name"
      assert accompany.email == "some updated email"
      assert accompany.phone_number == "some updated phone_number"
    end

    test "update_accompany/2 with invalid data returns error changeset" do
      accompany = accompany_fixture()
      assert {:error, %Ecto.Changeset{}} = Ticketing.update_accompany(accompany, @invalid_attrs)
      assert accompany == Ticketing.get_accompany!(accompany.id)
    end

    test "delete_accompany/1 deletes the accompany" do
      accompany = accompany_fixture()
      assert {:ok, %Accompany{}} = Ticketing.delete_accompany(accompany)
      assert_raise Ecto.NoResultsError, fn -> Ticketing.get_accompany!(accompany.id) end
    end

    test "change_accompany/1 returns a accompany changeset" do
      accompany = accompany_fixture()
      assert %Ecto.Changeset{} = Ticketing.change_accompany(accompany)
    end
  end

  describe "payments" do
    alias Gallium.Ticketing.Payment
    import Gallium.TicketingFixtures

    # Adicionado mbway_phone que é obrigatório
    @invalid_attrs %{status: nil, amount: nil, order_id: nil, mbway_phone: nil}

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Ticketing.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Ticketing.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      attendee = attendee_fixture()

      valid_attrs = %{
        status: :paid,
        amount: "120.5",
        order_id: "some order_id",
        mbway_phone: "912345678",
        attendee_id: attendee.id
      }

      assert {:ok, %Payment{} = payment} = Ticketing.create_payment(valid_attrs)
      assert payment.status == :paid
      assert payment.amount == Decimal.new("120.5")
      assert payment.order_id == "some order_id"
      assert payment.mbway_phone == "912345678"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ticketing.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()

      update_attrs = %{
        status: :failed,
        amount: "456.7",
        order_id: "some updated order_id",
        mbway_phone: "999888777"
      }

      assert {:ok, %Payment{} = payment} = Ticketing.update_payment(payment, update_attrs)
      assert payment.status == :failed
      assert payment.amount == Decimal.new("456.7")
      assert payment.order_id == "some updated order_id"
      assert payment.mbway_phone == "999888777"
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Ticketing.update_payment(payment, @invalid_attrs)
      assert payment == Ticketing.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Ticketing.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Ticketing.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Ticketing.change_payment(payment)
    end
  end

  describe "attendees" do
    alias Gallium.Ticketing.Attendee
    import Gallium.TicketingFixtures

    @invalid_attrs %{full_name: nil, email: nil, phone_number: nil, student_number: nil, nif: nil}

    test "list_attendees/0 returns all attendees" do
      attendee = attendee_fixture()
      assert Ticketing.list_attendees() == [attendee]
    end

    test "get_attendee!/1 returns the attendee with given id" do
      attendee = attendee_fixture()
      assert Ticketing.get_attendee!(attendee.id) == attendee
    end

    test "create_attendee/1 with valid data creates a attendee" do
      valid_attrs = %{
        full_name: "some full_name",
        email: "some email",
        phone_number: "some phone_number",
        student_number: "some student_number",
        nif: "some nif"
      }

      # Corrigido para %Attendee{} (maiúsculo)
      assert {:ok, %Attendee{} = attendee} = Ticketing.create_attendee(valid_attrs)
      assert attendee.full_name == "some full_name"
      assert attendee.email == "some email"
      assert attendee.phone_number == "some phone_number"
      assert attendee.student_number == "some student_number"
      assert attendee.nif == "some nif"
    end

    test "create_attendee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ticketing.create_attendee(@invalid_attrs)
    end

    test "update_attendee/2 with valid data updates the attendee" do
      attendee = attendee_fixture()

      update_attrs = %{
        full_name: "some updated full_name",
        email: "some updated email",
        phone_number: "some updated phone_number",
        student_number: "some updated student_number",
        nif: "some updated nif"
      }

      assert {:ok, %Attendee{} = attendee} = Ticketing.update_attendee(attendee, update_attrs)
      assert attendee.full_name == "some updated full_name"
      assert attendee.email == "some updated email"
      assert attendee.phone_number == "some updated phone_number"
      assert attendee.student_number == "some updated student_number"
      assert attendee.nif == "some updated nif"
    end

    test "update_attendee/2 with invalid data returns error changeset" do
      attendee = attendee_fixture()
      assert {:error, %Ecto.Changeset{}} = Ticketing.update_attendee(attendee, @invalid_attrs)
      assert attendee == Ticketing.get_attendee!(attendee.id)
    end

    test "delete_attendee/1 deletes the attendee" do
      attendee = attendee_fixture()
      assert {:ok, %Attendee{}} = Ticketing.delete_attendee(attendee)
      assert_raise Ecto.NoResultsError, fn -> Ticketing.get_attendee!(attendee.id) end
    end

    test "change_attendee/1 returns a attendee changeset" do
      attendee = attendee_fixture()
      assert %Ecto.Changeset{} = Ticketing.change_attendee(attendee)
    end
  end
end
