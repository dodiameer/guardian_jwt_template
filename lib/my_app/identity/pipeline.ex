defmodule MyApp.Identity.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    error_handler: MyApp.Identity.ErrorHandler,
    module: MyApp.Identity.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
