defmodule SgiathAuth.ScopeTest do
  use ExUnit.Case, async: false

  alias SgiathAuth.Scope

  @test_user %{"id" => "user_123", "email" => "test@example.com"}

  describe "for_user/2 with load_admin callback" do
    setup do
      original_config = Application.get_env(:sgiath_auth, :profile_module)
      on_exit(fn -> Application.put_env(:sgiath_auth, :profile_module, original_config) end)
      :ok
    end

    test "returns nil admin when no profile_module configured" do
      Application.put_env(:sgiath_auth, :profile_module, nil)

      scope = Scope.for_user(@test_user)

      assert scope.user == @test_user
      assert scope.admin == nil
      assert scope.role == "member"
    end

    test "returns nil admin when profile_module does not implement load_admin" do
      defmodule ProfileWithoutAdmin do
        @behaviour SgiathAuth.Profile

        @impl SgiathAuth.Profile
        def load_profile(_user), do: %{name: "Test User"}
      end

      Application.put_env(:sgiath_auth, :profile_module, ProfileWithoutAdmin)

      scope = Scope.for_user(@test_user)

      assert scope.user == @test_user
      assert scope.profile == %{name: "Test User"}
      assert scope.admin == nil
    end

    test "calls load_admin when profile_module implements it" do
      defmodule ProfileWithAdmin do
        @behaviour SgiathAuth.Profile

        @impl SgiathAuth.Profile
        def load_profile(_user), do: %{name: "Test User"}

        @impl SgiathAuth.Profile
        def load_admin(%{"id" => "user_123"}), do: %{email: "admin@example.com", name: "Admin"}
      end

      Application.put_env(:sgiath_auth, :profile_module, ProfileWithAdmin)

      scope = Scope.for_user(@test_user)

      assert scope.user == @test_user
      assert scope.profile == %{name: "Test User"}
      assert scope.admin == %{email: "admin@example.com", name: "Admin"}
    end

    test "load_admin can return nil" do
      defmodule ProfileWithNilAdmin do
        @behaviour SgiathAuth.Profile

        @impl SgiathAuth.Profile
        def load_profile(_user), do: %{name: "Test User"}

        @impl SgiathAuth.Profile
        def load_admin(_user), do: nil
      end

      Application.put_env(:sgiath_auth, :profile_module, ProfileWithNilAdmin)

      scope = Scope.for_user(@test_user)

      assert scope.admin == nil
    end

    test "respects custom role parameter" do
      defmodule ProfileForRole do
        @behaviour SgiathAuth.Profile

        @impl SgiathAuth.Profile
        def load_profile(_user), do: nil
      end

      Application.put_env(:sgiath_auth, :profile_module, ProfileForRole)

      scope = Scope.for_user(@test_user, "admin")

      assert scope.role == "admin"
    end
  end
end
