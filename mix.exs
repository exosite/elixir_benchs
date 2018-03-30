defmodule Mix.Tasks.Compile.IsoFormat do
  @shortdoc "Compiles IsoFormat"

  def run(_) do
      {result, _error_code} = System.cmd("sh", ["build_isoformat.sh"], stderr_to_stdout: true)
      Mix.shell.info result
  end
end

defmodule IsoTimeFormatting.Mixfile do
  use Mix.Project

  def project do
    [app: :iso_time_formatting,
     version: "0.1.0",
     elixir: "~> 1.4",
     compilers: [:iso_format, :elixir, :app],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:timex, "~> 3.0"},
      {:benchee, "~> 0.11.0", only: :dev}
    ]
  end
end
