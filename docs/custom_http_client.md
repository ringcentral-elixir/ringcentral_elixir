# Using a custom HTTP Client

By default, the `RingCentral.HTTPClient.DefaultClient` will be used as the HTTP client.

But if you need, you can build a customized HTTP Client by implement the `RingCentral.HTTPClient` behaviour.

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
