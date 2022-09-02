defmodule RingCentral.API do
  @moduledoc """
  The Main module to interact with RingCentral [REST APIs](https://developer.ringcentral.com/api-reference).

  """

  @default_doc """
  It will uses `ringcentral.http_client` to send the request to RingCentral API,
  which by default is the `RingCentral.HTTPClient.DefaultClient`.
  """

  @default_api_prefix "/restapi/v1.0/"

  alias RingCentral.HTTPClient
  alias RingCentral.Response

  require Logger

  @doc """
  Send a `GET` request to the REST API.

  #{@default_doc}
  """
  @spec get(RingCentral.t(), String.t(), list()) ::
          {:error, RingCentral.Error.t()} | {:ok, RingCentral.Response.t()}
  def get(ringcentral, path, headers \\ []) do
    request(ringcentral, :get, path, "", headers)
  end

  @doc """
  Send a `POST` request to the REST API.

  #{@default_doc}
  """
  @spec post(RingCentral.t(), String.t(), map(), list()) ::
          {:error, RingCentral.Error.t()} | {:ok, RingCentral.Response.t()}
  def post(ringcentral, path, body, headers \\ []) do
    req_body = RingCentral.JSON.encode!(ringcentral, body)

    request(ringcentral, :post, path, req_body, headers)
  end

  @doc """
  Send a `PUT` request to the REST API.

  #{@default_doc}
  """
  @spec put(RingCentral.t(), String.t(), map(), list()) ::
          {:error, RingCentral.Error.t()} | {:ok, RingCentral.Response.t()}
  def put(ringcentral, path, body, headers \\ []) do
    req_body = RingCentral.JSON.encode!(ringcentral, body)

    request(ringcentral, :put, path, req_body, headers)
  end

  @doc """
  Send a `DELETE` request to the REST API.

  #{@default_doc}
  """
  @spec delete(RingCentral.t(), String.t(), list()) ::
          :ok | {:error, RingCentral.Error.t()} | {:ok, RingCentral.Response.t()}
  def delete(ringcentral, path, headers \\ []) do
    with {:ok, %Response{status: 204}} <-
           request(ringcentral, :post, path, "", headers) do
      :ok
    end
  end

  @doc false
  def request(ringcentral, method, path, body, headers \\ [])

  def request(%RingCentral{token_info: nil}, _method, _path, _body, _headers) do
    raise ArgumentError, message: "Missing `token_info` in the RingCentral client."
  end

  def request(%RingCentral{} = ringcentral, method, path, body, headers) do
    headers =
      [
        {"accept", "application/json"},
        {"content-type", "application/json"},
        {"authorization", "bearer #{ringcentral.token_info["access_token"]}"}
      ]
      |> Enum.concat(headers)

    url = build_path(ringcentral, path)

    Logger.debug("Will request #{url}")

    with {:ok, resp} <- HTTPClient.perform_request(ringcentral, method, url, body, headers) do
      resp = handle_response(ringcentral, resp)
      {:ok, resp}
    end
  end

  defp handle_response(_ringcentral, %Response{body: ""} = response) do
    resp =
      response
      |> Map.put(:data, nil)

    resp
  end

  defp handle_response(ringcentral, %Response{body: body} = response) do
    resp =
      response
      |> Map.put(:data, RingCentral.JSON.decode!(ringcentral, body))

    resp
  end

  defp build_path(%RingCentral{} = client, path) do
    full_path = Path.join(@default_api_prefix, path)

    client.server_url
    |> URI.merge(full_path)
    |> URI.to_string()
  end
end
