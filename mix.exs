defmodule RingCentral.MixProject do
  use Mix.Project

  @version "0.2.2"
  @url "https://github.com/ringcentral-elixir/ringcentral_elixir"

  def project do
    [
      app: :ringcentral,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: "RingCentral",
      description: "A thin RingCentral API Wrapper in Elixir",
      source_url: @url,
      homepage_url: @url,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RingCentral.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # runtime deps
      {:finch, "~> 0.6", optional: true},
      {:jason, "~> 1.0", optional: true},

      # test
      {:bypass, "~> 2.1", only: :test},

      # doc
      {:ex_doc, "~> 0.14", only: [:dev, :docs]},

      # utils
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      name: :ringcentral,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ringcentral-elixir/ringcentral_elixir"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      extras: [
        "docs/guide.md",
        "docs/custom_http_client.md"
      ],
      groups_for_modules: [
        "HTTP Client": [
          ~r"RingCentral.HTTPClient"
        ],
        JSON: [
          ~r"RingCentral.JSON"
        ],
        Authorization: [
          ~r"RingCentral.OAuth"
        ],
        "REST API": [
          ~r"RingCentral.API"
        ]
      ]
    ]
  end
end
