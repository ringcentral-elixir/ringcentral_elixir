defmodule RingCentral.Client do
  @moduledoc """
  The Module to build a new client.

  ```elixir
  client = RingCentral.Client.new(
    client_id: "CLIENT_ID",
    client_secret: "CLIENT_SECRET",
    redirect_uri: "https://ringcentral-elixir.test",
    server_url: "https://platform.devtest.ringcentral.com"
  )
  ```

  """

  @behaviour OAuth2.Strategy

  import OAuth2.Client, only: [put_param: 3, put_header: 3]

  @type config :: [
          client_id: String.t(),
          client_secret: String.t(),
          redirect_uri: String.t(),
          server_url: String.t()
        ]

  @doc """
  Build a new RingCentral Client
  """
  @spec new(config) :: OAuth2.Client.t()
  def new(opts) do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: opts[:client_id],
      client_secret: opts[:client_secret],
      redirect_uri: opts[:redirect_uri],
      site: build_url(opts[:server_url], "/restapi"),
      authorize_url: build_url(opts[:server_url], "/restapi/oauth/authorize"),
      token_url: build_url(opts[:server_url], "/restapi/oauth/token"),
      headers: [{:accept, "application/json"}]
    )
  end

  @impl OAuth2.Strategy
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  @impl OAuth2.Strategy
  def get_token(client, params \\ [], headers \\ []) do
    client
    |> put_param(:grant_type, "authorization_code")
    |> put_param(:code, params[:code])
    |> put_param(:redirect_uri, client.redirect_uri)
    |> put_param(:access_token_ttl, params[:access_token_ttl] || 3600)
    |> put_param(:refresh_token_ttl, params[:refresh_token_ttl])
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp build_url(server_url, path) do
    server_url
    |> URI.parse()
    |> URI.merge(path)
    |> to_string()
  end
end
