# RingCentral

[![codebeat badge](https://codebeat.co/badges/2e46760f-58a9-4f45-84a1-547a41a8687b)](https://codebeat.co/projects/github-com-ringcentral-elixir-ringcentral_elixir-main)


A thin [RingCentral API](https://developer.ringcentral.com/api-reference) wrapper in Elixir.

## Installation

The package can be installed
by adding `ringcentral` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ringcentral, "~> 0.2.0"},

    # used by the default HTTP client implementation
    {:finch, "~> 0.6"},

    # used by the default JSON coder implementation
    {:jason, "~> 1.0"},
  ]
end
```

## Docs

The docs can be found at [https://hexdocs.pm/ringcentral](https://hexdocs.pm/ringcentral).
