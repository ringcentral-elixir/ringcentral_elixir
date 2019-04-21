# Guide

## Usage

Add the default HTTP client `RingCentral.HTTPClient.DefaultClient` to the supervision tree:

```elixir
# lib/your_app/application.ex
def start(_type, _args) do
  children = [
    ...
    {RingCentral.HTTPClient.DefaultClient, []}
  ]

  ...
end
```

Build the RingCentral Client

```elixir
ringcentral =
  RingCentral.build(
    client_id: "the-client-id",
    client_secret: "the-client-secret",
    server_url: RingCentral.production_server_url()
  )
# %RingCentral{
#  client_id: "the-client-id",
#  client_secret: "the-client-secret",
#  http_client: RingCentral.HTTPClient.DefaultClient,
#  server_url: "https://platform.ringcentral.com",
#  token_info: nil
#}
```

Initial the OAuth flow

```elixir
{:ok, authorization_url} = RingCentral.OAuth.authorize(ringcentral, %{
  response_type: "code",
  redirect_uri: "https://ringcentral-elixir.test"
})
# {:ok, "https://service.ringcentral.com/..."}
```

Exchange the code for token

```elixir
{:ok, token_info} = RingCentral.OAuth.get_token(ringcentral, %{
  grant_type: "authorization_code",
  code: "U0pDMDFQMDRQQVMwMnxBQUFGTVUyYURGYi0wUEhEZ2VLeGFiamFvZlNMQlZ5TExBUHBlZVpTSVlhWk",
  redirect_uri: "https://ringcentral-elixir.test"
})
# {:ok, %{"access_token": "...", "token_type": "bearer", "refresh_token": "..."}}
```

Update client with the token_info

```elixir
ringcentral_with_token_info =
  RingCentral.build(
    client_id: "the-client-id",
    client_secret: "the-client-secret",
    server_url: RingCentral.production_server_url(),
    token_info: token_info
  )
```

Then you can call the REST API with `RingCentral.API` module:

```elixir
{:ok, response} = RingCentral.API.get(ringcentral_with_token_info, "/")
# {:ok,
#  %RingCentral.Response{
#    body: "{\n  \"uri\" : \"https://platform.ringcentral.com/restapi/v1.0/\",\n  \"versionString\" : \"1.0.45\",\n  \"releaseDate\" : \"2021-02-12T00:00:00.000Z\",\n  \"uriString\" : \"v1.0\"\n}",
#    data: %{
#      "releaseDate" => "2021-02-12T00:00:00.000Z",
#      "uri" => "https://platform.ringcentral.com/restapi/v1.0/",
#      "uriString" => "v1.0",
#      "versionString" => "1.0.45"
#    },
#    headers: [
#      {"server", "nginx"},
#      {"date", "Sun, 28 Mar 2021 05:34:01 GMT"},
#      {"content-type", "application/json;charset=utf-8"},
#      {"content-length", "162"},
#      {"connection", "keep-alive"},
#      {"rcrequestid", "33baa9e6-8f87-11eb-be5a-005056b5eaad"},
#      {"routingkey", "AMS01P35PAS01"},
#      {"content-language", "en"},
#      {"vary", "Accept-Encoding, User-Agent"}
#    ],
#    status: 200
#  }}
```
