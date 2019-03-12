defmodule RingCentral.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup _tags do
    bypass = Bypass.open()

    {:ok, bypass: bypass}
  end
end
