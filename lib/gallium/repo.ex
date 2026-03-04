defmodule Gallium.Repo do
  use Ecto.Repo,
    otp_app: :gallium,
    adapter: Ecto.Adapters.Postgres
end
