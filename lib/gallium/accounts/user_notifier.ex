defmodule Gallium.Accounts.UserNotifier do
  @moduledoc """
  Module responsible for sending account-related emails to users.
  """
  import Swoosh.Email

  alias Gallium.Accounts.User
  alias Gallium.Mailer
  alias Gallium.Repo

  use Phoenix.Swoosh, view: GalliumWeb.EmailView

  defp base_html_email(recipient, subject) do
    sender = {Mailer.get_sender_name(), Mailer.get_sender_address()}

    phx_host =
      if System.get_env("PHX_HOST") != nil do
        "https://" <> System.get_env("PHX_HOST")
      else
        ""
      end

    new()
    |> to(recipient)
    |> from(sender)
    |> subject("[#{elem(sender, 0)}] #{subject}")
    |> assign(:phx_host, phx_host)
  end

  defp user_full_name(%User{} = user) do
    user
    |> Repo.preload(:attendee)
    |> attendee_full_name()
  end

  defp attendee_full_name(%User{attendee: %{full_name: full_name}}) when is_binary(full_name) do
    full_name
  end

  defp attendee_full_name(%User{email: email}), do: email

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    user_name = user_full_name(user)

    email =
      base_html_email(user.email, "Update your email address")
      |> assign(:user_name, user_name)
      |> assign(:confirm_email_link, url)
      |> render_body("confirm_email.html")
      |> text_body("""
      Olá #{user_name},

      Confirma o teu email através do link abaixo:

      #{url}
      """)

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Deliver instructions to log in with a magic link.
  """
  def deliver_login_instructions(user, url) do
    case user do
      %User{confirmed_at: nil} -> deliver_confirmation_instructions(user, url)
      _ -> deliver_magic_link_instructions(user, url)
    end
  end

  defp deliver_magic_link_instructions(user, url) do
    user_name = user_full_name(user)

    email =
      base_html_email(user.email, "Log in to your account")
      |> assign(:user_name, user_name)
      |> assign(:magic_link, url)
      |> render_body("magic_link.html")
      |> text_body("""
      Olá #{user_name},

      Usa o link abaixo para entrares na tua conta:

      #{url}
      """)

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  defp deliver_confirmation_instructions(user, url) do
    user_name = user_full_name(user)

    email =
      base_html_email(user.email, "Confirm your email")
      |> assign(:user_name, user_name)
      |> assign(:confirm_email_link, url)
      |> render_body("confirm_email.html")
      |> text_body("""
      Olá #{user_name},

      Confirma o teu email através do link abaixo:

      #{url}
      """)

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end
end
