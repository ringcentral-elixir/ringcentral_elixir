defmodule RingCentral do
  @moduledoc """

  A thin [RingCentral API](https://developer.ringcentral.com/api-reference) wrapper in Elixir.

  ## Usage

  ```elixir
  client =
    RingCentral.Client.new(
      client_id: "CLIENT_ID",
      client_secret: "CLIENT_SECRET",
      redirect_uri: "https://ringcentral-elixir.test",
      server_url: "https://platform.devtest.ringcentral.com"
    )

  authorize_url = RingCentral.OAuth.authorize_url!(client, ui_options: "hide_logo")

  client = RingCentral.OAuth.get_token!(client, code: "AUTH_CODE")

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
  """
end
