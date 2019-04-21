if Code.ensure_loaded?(Finch) do
  # Only define this module when Finch exists as an dependency.
  defmodule RingCentral.HTTPClient.DefaultClient do
    @moduledoc """
    The default implementation for `RingCentral.HTTPClient`. Uses `Finch` as the HTTP client.

    Add the `RingCentral.HTTPClient.DefaultClient` to your application's supervision tree:

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

    Or start it dynamically with `start_link/1`
    """

    alias RingCentral.Response
    alias RingCentral.Error

    @behaviour RingCentral.HTTPClient

    @doc false
    def child_spec(opts) do
      %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [opts]}
      }
    end

    @doc """
    Start an instance of the defalut HTTPClient.

    The following options will be passed to the `Finch.start_link/1`:

    ```elixir
    [
      name: __MODULE__
      pools: %{
        RingCentral.sandbox_server_url() => [size: 1],
        RingCentral.production_server_url() => [size: 10]
      }
    ]
    ```

    You override the default options with `opts`, see `Finch.start_link/1` for detail.

    ## Example

    ```elixir
    opts = [
      pools: %{
        RingCentral.production_server_url() => [size: 30]
      }
    ]

    RingCentral.HTTPClient.DefaultClient.start_link(opts)
    ```
    """
    def start_link(opts) do
      opts =
        [
          name: __MODULE__,
          pools: %{
            RingCentral.sandbox_server_url() => [size: 1],
            RingCentral.production_server_url() => [size: 10]
          }
        ]
        |> Keyword.merge(opts)

      Finch.start_link(opts)
    end

    @impl RingCentral.HTTPClient
    def request(method, url, body, headers \\ []) do
      request = Finch.build(method, url, headers, body)

      result = Finch.request(request, __MODULE__)

      with {:ok, %Finch.Response{} = response} <- result do
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
             code: :finch_error,
             detail: error
           }}
      end
    end
  end
else
  defmodule RingCentral.HTTPClient.DefaultClient do
    @moduledoc """
    HTTP client with dark magic.
    """
    @behaviour RingCentral.HTTPClient

    @impl true
    def request(_method, _url, _body, _headers \\ []) do
      raise RuntimeError, """
      Please specific your own `http_client` or add `Finch` as an dependency to your project.

      See documentation for `RingCentral` and `RingCentral.HTTPClient` for more information.
      """
    end
  end
end
