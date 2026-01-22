defmodule SgiathAuth.Profile do
  @moduledoc """
  Behaviour for loading user profiles.

  Implement this behaviour in your application to populate the `profile` field
  in `SgiathAuth.Scope` with application-specific data.

  ## Example

      defmodule MyApp.Profile do
        @behaviour SgiathAuth.Profile

        @impl SgiathAuth.Profile
        def load_profile(%{"id" => user_id}) do
          MyApp.Repo.get_by(MyApp.User, workos_id: user_id)
        end
      end

  Then configure it in your application:

      config :sgiath_auth, profile_module: MyApp.Profile
  """

  @doc """
  Loads a profile for the given WorkOS user.

  Receives the WorkOS user map and should return whatever data you want
  stored in `SgiathAuth.Scope.profile`. Return `nil` if no profile is found.
  """
  @callback load_profile(user :: map()) :: any()

  @doc """
  Optional callback to load admin data

  Receives the WorkOS user map and should return admin data to be stored
  in `SgiathAuth.Scope.admin`. Typically used to extract and load admin
  information from the JWT `act.sub` claim when an admin is impersonating a user or load admin
  data when regular users can also be admins.

  Return `nil` if no admin is impersonating or if the callback is not needed.
  """
  @callback load_admin(user :: map()) :: any()

  @optional_callbacks load_admin: 1
end
