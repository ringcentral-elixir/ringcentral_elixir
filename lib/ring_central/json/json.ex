defmodule RingCentral.JSON do
  @moduledoc """
  JSON behaviour for RingCentral

  ## Build your own JSON encoder & decoder:

  ```elixir
  defmodule MyApp.AwesomeJSONCoder do
    @behaviour RingCentral.JSON

    @impl true
    def decode!(json_string) do
      Jason.decode!(json_string)
    end

    @impl true
    def encode!(data) do
      Jason.encode!(data)
    end
  end
  ```

  Then Use the custom JSON implementation while building the client:

  ```elixir
  ringcentral =
    RingCentral.build(
      client_id: "my-client-id",
      client_secret: "my-client-secret",
      http_client: MyApp.AwesomeHTTPClient
      json_coder: MyApp.AwesomeJSONCoder
    )
  ```

  See `RingCentral.JSON.DefaultCoder` for a reference implementation.
  """

  @callback encode!(map() | [map()]) :: String.t()
  @callback decode!(String.t()) :: map()

  @doc false
  def encode!(%RingCentral{} = rc, data) do
    rc.json_coder.encode!(data)
  end

  @doc false
  def decode!(%RingCentral{} = rc, str) do
    rc.json_coder.decode!(str)
  end
end
