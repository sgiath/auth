defmodule SgiathAuth.WorkOS.OrganizationMembership do
  @moduledoc """
  WorkOS Organization Memberships API client.

  Provides functions to list and create organization memberships for users.

  See https://workos.com/docs/reference/authkit/organization-membership
  """

  alias SgiathAuth.WorkOS.Client

  @doc """
  Lists organization memberships with optional filters.

  ## Options

    * `:user_id` - Filter by user ID (string)
    * `:organization_id` - Filter by organization ID (string)
    * `:statuses` - Filter by status, list of `"active"`, `"inactive"`, or `"pending"`
    * `:limit` - Maximum number of results (integer)
    * `:before` - Pagination cursor for previous page (string)
    * `:after` - Pagination cursor for next page (string)
    * `:order` - Sort order, `:asc` or `:desc`

  """
  def list(opts \\ []) do
    Client.new()
    |> Req.get(url: "/user_management/organization_memberships", params: opts)
    |> Client.handle_response()
  end

  @doc """
  Creates an organization membership for a user.

  ## Parameters

    * `user_id` - The user ID to add to the organization
    * `org_id` - The organization ID

  ## Options

    * `:role_slug` - Role to assign (string)
    * `:role_slugs` - Multiple roles to assign (list of strings)

  """
  def create("user_" <> user_id, "org_" <> org_id, opts \\ %{}) do
    body =
      opts
      |> Map.put(:user_id, "user_" <> user_id)
      |> Map.put(:organization_id, "org_" <> org_id)

    Client.new()
    |> Req.post(url: "/user_management/organization_memberships", json: body)
    |> Client.handle_response()
  end

  @doc """
  Updates an organization membership.

  ## Parameters

    * `membership_id` - The organization membership ID (e.g. "om_...")

  ## Options

    * `:role_slug` - New role to assign (string)

  """
  def update("om_" <> membership_id, opts \\ %{}) do
    Client.new()
    |> Req.put(url: "/user_management/organization_memberships/om_#{membership_id}", json: opts)
    |> Client.handle_response()
  end

  @doc """
  Gets an organization membership by ID.
  """
  def get("om_" <> membership_id) do
    Client.new()
    |> Req.get(url: "/user_management/organization_memberships/om_#{membership_id}")
    |> Client.handle_response()
  end

  @doc """
  Deletes an organization membership.

  ## Parameters

    * `membership_id` - The organization membership ID (e.g. "om_...")

  """
  def delete("om_" <> membership_id) do
    Client.new()
    |> Req.delete(url: "/user_management/organization_memberships/om_#{membership_id}")
    |> Client.handle_response()
  end

  @doc """
  Deactivates an organization membership.

  The user will no longer be able to access the organization but the membership record is preserved.

  ## Parameters

    * `membership_id` - The organization membership ID (e.g. "om_...")

  """
  def deactivate("om_" <> membership_id) do
    Client.new()
    |> Req.put(url: "/user_management/organization_memberships/om_#{membership_id}/deactivate")
    |> Client.handle_response()
  end

  @doc """
  Reactivates a previously deactivated organization membership.

  ## Parameters

    * `membership_id` - The organization membership ID (e.g. "om_...")

  """
  def reactivate("om_" <> membership_id) do
    Client.new()
    |> Req.put(url: "/user_management/organization_memberships/om_#{membership_id}/reactivate")
    |> Client.handle_response()
  end
end
