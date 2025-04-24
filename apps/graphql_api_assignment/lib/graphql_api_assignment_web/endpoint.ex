defmodule GraphqlApiAssignmentWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :graphql_api_assignment
  use Absinthe.Phoenix.Endpoint

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_graphql_api_assignment_key",
    signing_salt: "c/hYk2Qx",
    same_site: "Lax"
  ]

  # Sockets
  socket "/socket", GraphqlApiAssignmentWeb.UserSocket,
    websocket: true,
    longpoll: false

  # socket "/live", Phoenix.LiveView.Socket,
  #   websocket: [connect_info: [session: @session_options]],
  #   longpoll: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :graphql_api_assignment,
    gzip: false,
    only: GraphqlApiAssignmentWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  # Request Cache
  plug RequestCache.Plug

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug GraphqlApiAssignmentWeb.Router

  plug Absinthe.Plug, before_send: {RequestCache, :connect_absinthe_context_to_conn}

end
