defmodule RingCentral.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup _tags do
    RingCentral.HTTPClient.DefaultClient.start_link(pool_size: 2)

    bypass = Bypass.open()

    ringcentral =
      RingCentral.build(
        client_id: "the-client-id",
        client_secret: "the-client-secret",
        server_url: "http://127.0.0.1:#{bypass.port}"
      )

    {:ok, bypass: bypass, ringcentral: ringcentral}
  end
end
