defmodule DesignPatterns.Behavioral.Strategy do
  defmodule Formatter do
    @callback output_report(context :: map) :: binary
  end

  defmodule TextFormatter do
    @behaviour Formatter

    def output_report(context) do
      Enum.join(["***** #{context.title} *****" | context.text], "\n")
    end
  end

  defmodule HTMLFormatter do
    @behaviour Formatter

    def output_report(context) do
      """
      <html>
        <head>
          <title>#{context.title}</title>
        </head>
        <body>
        #{Enum.map_join(context.text, "\n  ", &"  <p>#{&1}</p>")}
        </body>
      </html>
      """
    end
  end

  defmodule Report do
    @formatters [TextFormatter, HTMLFormatter]

    def output(context, formatter) when formatter in @formatters do
      %{data: formatter.output_report(context)}
    end
  end
end
