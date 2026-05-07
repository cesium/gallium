defmodule GalliumWeb.Router do
  use GalliumWeb, :router

  import GalliumWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GalliumWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GalliumWeb do
    pipe_through :browser

    live_session :current_user,
      on_mount: [{GalliumWeb.UserAuth, :mount_current_scope}] do
      live "/", LandingLive.Index, :index
      live "/bilhetes", TicketsLive.Index, :index
      live "/evento", EventLive.Index, :index
    end
  end

  scope "/api", GalliumWeb do
    pipe_through :api

    post "/midas/:api_key/webhook", MidasController, :handle_webhook
    get "/v1/payments/received", MidasController, :payment_received
  end

  scope "/uploads", GalliumWeb do
    pipe_through :api

    get "/invoices/:order_id/original.pdf", MidasController, :invoice_not_found
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gallium, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GalliumWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", GalliumWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    live_session :require_admin,
      on_mount: [
        {GalliumWeb.UserAuth, :require_authenticated},
        {GalliumWeb.UserAuth, :require_admin}
      ] do
      live "/backoffice", BackOfficeIndex.Index, :index
    end
  end

  ## Authentication routes

  scope "/", GalliumWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{GalliumWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
      live "/bilhetes/comprar", TicketingPurchaseLive.Index, :index
      live "/user/profile", UserLive.Profile, :new
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", GalliumWeb do
    pipe_through [:browser]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{GalliumWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
