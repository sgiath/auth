defmodule Auth.Token do
  use Joken.Config

  add_hook(JokenJwks, strategy: Auth.Token.Strategy)

  @impl Joken.Config
  def token_config do
    base_url = Auth.WorkOS.base_url()
    client_id = Auth.WorkOS.client_id()

    default_claims(iss: "#{base_url}/user_management/#{client_id}")
  end
end

defmodule Auth.Token.Strategy do
  use JokenJwks.DefaultStrategyTemplate

  def init_opts(opts) do
    base_url = Auth.WorkOS.base_url()
    client_id = Auth.WorkOS.client_id()

    Keyword.merge(opts, jwks_url: "#{base_url}/sso/jwks/#{client_id}")
  end
end
