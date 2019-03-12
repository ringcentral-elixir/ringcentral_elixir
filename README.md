# RingCentral

A thin [RingCentral API](https://developer.ringcentral.com/api-reference) wrapper in Elixir.

## Installation

The package can be installed
by adding `ringcentral` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ringcentral, "~> 0.1.0"}
  ]
end
```

## Docs

The docs can be found at [https://hexdocs.pm/ringcentral](https://hexdocs.pm/ringcentral).

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
#   %{
#    "apiVersions" => [
#      %{
#        "releaseDate" => "2019-02-13T00:00:00.000Z",
#        "uri" => "https://platform.devtest.ringcentral.com/restapi/v1.0",
#        "uriString" => "v1.0",
#        "versionString" => "1.0.38"
#      }
#    ],
#    "serverRevision" => "3c520aea",
#    "serverVersion" => "11.0.1.1400",
#    "uri" => "https://platform.devtest.ringcentral.com/restapi/"
#  }
```
