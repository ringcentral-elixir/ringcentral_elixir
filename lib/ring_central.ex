defmodule RingCentral do
  @moduledoc """
  A thin [RingCentral API](https://developer.ringcentral.com/api-reference) wrapper in Elixir.
  """

  @enforce_keys [:client_id, :client_secret]

  defstruct server_url: nil,
            client_id: nil,
            client_secret: nil,
            token_info: nil,
            http_client: nil,
            json_coder: nil

  @type t :: %__MODULE__{
          server_url: String.t(),
          client_id: String.t(),
          client_secret: String.t(),
          token_info: map(),
          http_client: module(),
          json_coder: module()
        }

  @production_server_url "https://platform.ringcentral.com"
  @sandbox_server_url "https://platform.devtest.ringcentral.com"

  @doc """
  Build the RingCentral client, used by functions in both `RingCentral.OAuth` and `RingCentral.API`

  ## Options

  - `server_url`: Optional, the API server URL, default to the value of `RingCentral.production_server_url/0`
  - `client_id`: Required, the client ID
  - `client_secret`: Required, the client Secret
  - `token_info`: Required if used by `RingCentral.API` to make API calls, should be set to the result of `RingCentral.OAuth.get_token/2`
  - `http_client`: Optional, the module used to make HTTP calls, default to `RingCentral.HTTPClient.DefaultClient`
  - `json_coder`: Optional, the module used as JSON encoder & decoder, default to `RingCentral.JSON.DefaultCoder`
  """
  @spec build(keyword) :: t()
  def build(opts) do
    opts =
      opts
      |> Keyword.put_new(:http_client, RingCentral.HTTPClient.DefaultClient)
      |> Keyword.put_new(:json_coder, RingCentral.JSON.DefaultCoder)
      |> Keyword.put_new(:server_url, sandbox_server_url())

    struct!(__MODULE__, opts)
  end

  @doc """
  Returns the production API server URL: #{@production_server_url}
  """
  @spec production_server_url :: String.t()
  def production_server_url do
    @production_server_url
  end

  @doc """
  Returns the sandbox API server URL: #{@sandbox_server_url}
  """
  @spec sandbox_server_url :: String.t()
  def sandbox_server_url do
    @sandbox_server_url
  end
end
