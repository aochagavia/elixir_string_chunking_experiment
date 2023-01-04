defmodule StringChunking.MixProject do
  use Mix.Project

  def project do
    [
      app: :string_chunking,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:unicode_string, "~> 1.1.0"},
      {:rustler, "~> 0.26.0"},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
