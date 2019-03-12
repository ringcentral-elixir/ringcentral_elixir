defmodule RingCentral.API do
  @moduledoc """
  The Main module to interact with RingCentral [REST APIs](https://developer.ringcentral.com/api-reference).

  All functions are delegated to `OAuth2.Client`.

  Example:

  ```elixir
  case RingCentral.API.get(client, "/") do
    {:ok, %OAuth2.Response{body: resp}} ->
      resp
      |> IO.inspect()

    {:error, %OAuth2.Response{status_code: 401, body: body}} ->
      Logger.error("Unauthorized token")

    {:error, %OAuth2.Error{reason: reason}} ->
      Logger.error("Error: reason")
  end
  ```

  Response:

  ```elixir
  %{
    "apiVersions" => [
      %{
        "releaseDate" => "2019-02-13T00:00:00.000Z",
        "uri" => "https://platform.devtest.ringcentral.com/restapi/v1.0",
        "uriString" => "v1.0",
        "versionString" => "1.0.38"
      }
    ],
    "serverRevision" => "3c520aea",
    "serverVersion" => "11.0.1.1400",
    "uri" => "https://platform.devtest.ringcentral.com/restapi/"
  }
  ```
  """

  defdelegate delete(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate delete!(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client

  defdelegate get(client, url, headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate get!(client, url, headers \\ [], opts \\ []), to: OAuth2.Client

  defdelegate patch(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate patch!(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client

  defdelegate post(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate post!(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client

  defdelegate put!(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate put(client, url, body \\ "", headers \\ [], opts \\ []), to: OAuth2.Client
end
