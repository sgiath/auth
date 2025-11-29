defmodule Auth.Profile do
  @moduledoc """
  Behaviour for loading user profiles.

  Implement this behaviour in your application to populate the `profile` field
  in `Auth.Scope` with application-specific data.

  ## Example

      defmodule MyApp.Profile do
        @behaviour Auth.Profile

        @impl Auth.Profile
        def load_profile(%{"id" => user_id}) do
          MyApp.Repo.get_by(MyApp.User, workos_id: user_id)
        end
      end

  Then configure it in your application:

      config :auth, profile_module: MyApp.Profile
  """

  @doc """
  Loads a profile for the given WorkOS user.

  Receives the WorkOS user map and should return whatever data you want
  stored in `Auth.Scope.profile`. Return `nil` if no profile is found.
  """
  @callback load_profile(user :: map()) :: any()
end

