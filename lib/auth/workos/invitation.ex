defmodule SgiathAuth.WorkOS.Invitation do
  @moduledoc """
  WorkOS Invitations API client.

  Provides functions to manage user invitations to organizations.

  See https://workos.com/docs/reference/authkit/invitation
  """

  alias SgiathAuth.WorkOS.Client

  @doc """
  Gets an invitation by ID.

  ## Parameters

    * `invitation_id` - The invitation ID (e.g. "invitation_...")

  """
  def get("invitation_" <> invitation_id) do
    Client.new()
    |> Req.get(url: "/user_management/invitations/invitation_#{invitation_id}")
    |> Client.handle_response()
  end

  @doc """
  Gets an invitation by its token.

  ## Parameters

    * `token` - The invitation token from the invite URL

  """
  def get_by_token(token) do
    Client.new()
    |> Req.get(url: "/user_management/invitations/by_token/#{token}")
    |> Client.handle_response()
  end

  @doc """
  Lists invitations with optional filters.

  ## Options

    * `:email` - Filter by email address (string)
    * `:organization_id` - Filter by organization ID (string)
    * `:limit` - Maximum number of results (integer)
    * `:before` - Pagination cursor for previous page (string)
    * `:after` - Pagination cursor for next page (string)
    * `:order` - Sort order, `:asc` or `:desc`

  """
  def list(params \\ []) do
    Client.new()
    |> Req.get(url: "/user_management/invitations", params: params)
    |> Client.handle_response()
  end

  @doc """
  Sends a new invitation to an email address.

  ## Parameters

    * `email` - The email address to invite

  ## Options

    * `:organization_id` - Organization to invite user to (string)
    * `:expires_in_days` - Days until invitation expires (integer)
    * `:inviter_user_id` - User ID of the inviter (string)
    * `:role_slug` - Role to assign upon acceptance (string)

  """
  def send(email, params \\ %{}) do
    Client.new()
    |> Req.post(url: "/user_management/invitations", json: Map.put(params, :email, email))
    |> Client.handle_response()
  end

  @doc """
  Resends an existing invitation.

  ## Parameters

    * `invitation_id` - The invitation ID (e.g. "invitation_...")

  """
  def resend("invitation_" <> invitation_id) do
    Client.new()
    |> Req.post(url: "/user_management/invitations/invitation_#{invitation_id}/resend")
    |> Client.handle_response()
  end

  @doc """
  Revokes an invitation so it can no longer be accepted.

  ## Parameters

    * `invitation_id` - The invitation ID (e.g. "invitation_...")

  """
  def revoke("invitation_" <> invitation_id) do
    Client.new()
    |> Req.post(url: "/user_management/invitations/invitation_#{invitation_id}/revoke")
    |> Client.handle_response()
  end
end
