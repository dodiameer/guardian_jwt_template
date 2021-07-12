defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_cookies, signed: ~w(my_app_rjwt)
  end

  # Maybe authenticated
  pipeline :auth do
    plug MyApp.Identity.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_no_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  scope "/api", MyAppWeb do
    pipe_through [:api, :auth]
  end

  scope "/auth", MyAppWeb do
    pipe_through [:api, :auth, :ensure_no_auth]

    post "/login", AccountController, :login
    post "/register", AccountController, :register
  end

  scope "/auth", MyAppWeb do
    pipe_through [:api, :auth, :ensure_auth]

    delete "/logout", AccountController, :logout
    get "/me", AccountController, :me
    get "/refresh", AccountController, :refresh
  end

  # ?? Refresh token doesn't care about authentication status
  # scope "/auth", MyAppWeb do
  #   pipe_through [:api, :auth]

  #   get "/refresh", AccountController, :refresh
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end
end
