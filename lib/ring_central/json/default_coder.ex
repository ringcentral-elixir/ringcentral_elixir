if Code.ensure_loaded?(Jason) do
  # Only define this module when Finch exists as an dependency.
  defmodule RingCentral.JSON.DefaultCoder do
    @moduledoc """
    The default implementation for `RingCentral.JSON`. Uses `Jason` as the JSON encoder & decoder.
    """

    @behaviour RingCentral.JSON

    @impl true
    def encode!(data) do
      Jason.encode!(data)
    end

    @impl true
    def decode!(str) do
      Jason.decode!(str)
    end
  end
else
  defmodule RingCentral.JSON.DefaultCoder do
    @moduledoc """
    HTTP client with dark magic.
    """
    @behaviour RingCentral.JSON

    @impl true
    def encode!(data) do
      fail!()
    end

    def decode!(data) do
      fail!()
    end

    defp fail! do
      raise RuntimeError, """
      Please specific your own `json_coder` or add `Jason` as an dependency to your project.

      See documentation for `RingCentral` and `RingCentral.JSON` for more information.
      """
    end
  end
end
