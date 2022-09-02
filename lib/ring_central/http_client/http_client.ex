defmodule RingCentral.HTTPClient do
  @moduledoc """
  HTTPClient behaviour for RingCentral

  ## Build your own HTTP client:

  ```elixir
  defmodule MyApp.AwesomeHTTPClient do
    @behaviour RingCentral.HTTPClient

    @impl true
    def request(method, url, body, headers \\ []) do
      if success
        {:ok,
        %Response{
          status: response.status,
          headers: response.headers,
          body: response.body,
          data: nil
        }}
      else
        {:error, error} ->
          {:error,
            %Error{
              code: :server_error,
              detail: error
            }
          }
      end
    end
  end
  ```

  Then Use the custom HTTP while building the client:

  ```elixir
  ringcentral =
    RingCentral.build(
      client_id: "my-client-id",
      client_secret: "my-client-secret",
      http_client: MyApp.AwesomeHTTPClient
    )
  ```

  See `RingCentral.HTTPClient.DefaultClient` for a reference implementation.
  """
  require Logger

  alias RingCentral.Response
  alias RingCentral.Error

  @type http_method :: :delete | :get | :post | :put
  @type http_headers :: [{header_name :: String.t(), header_value :: String.t()}]

  @callback request(
              method :: http_method,
              url :: String.t(),
              body :: String.t(),
              headers :: http_headers
            ) :: {:ok, Response.t()} | {:error, Error.t()}

  @spec perform_request(
          RingCentral.t(),
          http_method,
          String.t() | URI.t(),
          nil | String.t() | {:form, map()} | map(),
          http_headers
        ) :: {:ok, Response.t()} | {:error, Error.t()}
  @doc false
  def perform_request(%RingCentral{} = rc, method, url, body, headers \\ []) do
    Logger.debug(
      "perform request: #{method} #{url} with body: #{inspect(body)} and headers: #{inspect(headers)}"
    )

    url = format_url(url)
    body = format_body(rc, body)

    result = rc.http_client.request(method, url, body, headers)

    Logger.debug("response: #{inspect(result)}")

    result
  end

  defp format_url(url) when is_struct(url, URI) do
    URI.to_string(url)
  end

  defp format_url(url) when is_binary(url) do
    url
  end

  defp format_body(_rc, nil), do: ""

  defp format_body(_rc, str) when is_binary(str) do
    str
  end

  defp format_body(rc, params) when is_map(params) do
    RingCentral.JSON.encode!(rc, params)
  end

  defp format_body(_rc, {:form, form_data}) when is_map(form_data) do
    build_form_body(form_data)
  end

  defp format_body(_rc, _) do
    ""
  end

  defp build_form_body(body) do
    body
    |> Enum.map(fn {key, value} ->
      "#{key}=#{URI.encode_www_form(value)}"
    end)
    |> Enum.join("&")
  end
end
