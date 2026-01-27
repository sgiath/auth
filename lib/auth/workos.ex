defmodule SgiathAuth.WorkOS do
  @moduledoc """
  WorkOS AuthKit integration for user authentication.

  Provides functions for OAuth authorization flow, token management, and user retrieval.

  See https://workos.com/docs/reference/authkit/authentication
  """

  alias SgiathAuth.WorkOS.Client

  require Logger

  @doc """
  Generates a WorkOS authorization URL for user authentication.

  ## Options

    * `:screen_hint` - Either `"sign-in"` or `"sign-up"` (default: `"sign-in"`)
    * `:state` - State parameter passed through the OAuth flow (default: `""`)
    * `:organization_id` - Pre-select an organization for the user

  Returns `{:ok, url}`.
  """
  def get_authorization_url(opts \\ []) do
    query =
      opts
      # default sign-in if not specified
      |> Keyword.put_new(:screen_hint, "sign-in")
      |> Keyword.put_new(:state, "")
      |> Keyword.merge(
        provider: "authkit",
        response_type: "code",
        client_id: Client.client_id(),
        redirect_uri: callback_url()
      )
      |> URI.encode_query()

    {:ok, "#{Client.base_url()}/user_management/authorize?#{query}"}
  end

  @doc """
  Generates a WorkOS logout URL for ending a user session.

  Returns `{:ok, url}`.
  """
  def get_logout_url(session_id) do
    query =
      URI.encode_query(
        client_id: Client.client_id(),
        session_id: session_id,
        return_to: logout_return_to()
      )

    {:ok, "#{Client.base_url()}/user_management/sessions/logout?#{query}"}
  end

  @doc """
  Exchanges an authorization code for access and refresh tokens.

  Called after WorkOS redirects back to the callback URL with an auth code.
  Returns user data and tokens on success.
  """
  def authenticate_with_code(_conn, code) do
    Client.new()
    |> Req.post(
      url: "/user_management/authenticate",
      json: %{
        code: code,
        client_id: Client.client_id(),
        client_secret: Client.client_secret(),
        grant_type: "authorization_code"
      }
    )
    |> Client.handle_response()
  end

  @doc """
  Refreshes an expired access token using a refresh token.

  Returns new access and refresh tokens on success.

  ## Params

    * `:organization_id` - switch to different organization

  """
  def authenticate_with_refresh_token(_conn, refresh_token, params \\ %{}) do
    Client.new()
    |> Req.post(
      url: "/user_management/authenticate",
      json:
        Map.merge(
          %{
            client_id: Client.client_id(),
            client_secret: Client.client_secret(),
            grant_type: "refresh_token",
            refresh_token: refresh_token
          },
          params
        )
    )
    |> Client.handle_response()
  end

  @doc """
  Fetches a user by their WorkOS user ID.
  """
  def get_user(user_id) do
    Client.new()
    |> Req.get(url: "/user_management/users/#{user_id}")
    |> Client.handle_response()
  end

  defp callback_url do
    Application.fetch_env!(:sgiath_auth, :callback_url)
  end

  defp logout_return_to do
    Application.get_env(:sgiath_auth, :logout_return_to, "/")
  end

  @doc """
  Returns the configured sign-in path. Defaults to `"/sign-in"`.
  """
  def sign_in_path do
    Application.get_env(:sgiath_auth, :sign_in_path, "/sign-in")
  end

  @doc """
  Returns the configured token refresh path (POST-only). Defaults to `"/auth/refresh"`.
  """
  def refresh_path do
    Application.get_env(:sgiath_auth, :refresh_path, "/auth/refresh")
  end

  @doc """
  Returns the default redirect path after authentication. Defaults to `"/"`.
  """
  def default_path do
    Application.get_env(:sgiath_auth, :default_path, "/")
  end

  @doc """
  Returns the configured profile module implementing `SgiathAuth.Profile` behavior.

  Returns `nil` if not configured.
  """
  def profile_module do
    Application.get_env(:sgiath_auth, :profile_module)
  end
end
