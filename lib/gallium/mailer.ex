defmodule Gallium.Mailer do
  use Swoosh.Mailer, otp_app: :gallium

  def get_sender_name do
    Application.get_env(:gallium, :from_email_name)
  end

  def get_sender_address do
    Application.get_env(:gallium, :from_email_address)
  end
end
