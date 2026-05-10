defmodule GalliumWeb.MidasController do
  use GalliumWeb, :controller

  alias Gallium.Ticketing

  def handle_webhook(conn, %{"api_key" => api_key, "order_id" => order_id}) do
    if api_key == Application.fetch_env!(:gallium, :midas)[:api_key] do
      process_payment_if_pending(conn, order_id)
    else
      send_resp(conn, 403, "invalid api key")
    end
  end

  def payment_received(conn, %{"orderId" => order_id, "key" => api_key}) do
    if api_key == Application.fetch_env!(:gallium, :midas)[:api_key] do
      process_payment_if_pending(conn, order_id)
    else
      send_resp(conn, 403, "invalid api key")
    end
  end

  defp process_payment_if_pending(conn, order_id) do
    payment = Ticketing.get_payment_by_order_id(order_id)

    if payment && payment.status != :paid do
      case Ticketing.mark_payment_paid(order_id) do
        {:error, reason} -> json(conn, %{status: "error", reason: inspect(reason)})
        _ -> json(conn, %{status: "success"})
      end
    else
      json(conn, %{status: "success"})
    end
  end
end
