defmodule DesignPatterns.Behavioral.TemplateMethod do
  defmodule Report do
    defmacro __using__(_) do
      quote do
        @title "Monthly Report"
        @text ["Things are going", "really really well"]

        def output do
          doc_start()
          head()
          body_start()
          lines()
          body_end()
          doc_end()
        end

        def doc_start, do: nil

        def head, do: nil

        def body_start, do: nil

        def lines, do: Enum.each(@text, &line/1)

        def line(line), do: raise(ArgumentError, "not implemented")

        def body_end, do: nil

        def doc_end, do: nil

        defoverridable doc_start: 0,
                       head: 0,
                       body_start: 0,
                       line: 1,
                       body_end: 0,
                       doc_end: 0
      end
    end
  end

  defmodule TextReport do
    use Report

    def head, do: IO.puts("**** #{@title} ****\n")

    def line(line), do: IO.puts(line)
  end

  defmodule HTMLReport do
    use Report

    def doc_start, do: IO.puts("<html>")

    def head do
      IO.puts("<head>")
      IO.puts("  <title>#{@title}</title>")
      IO.puts("</head>")
    end

    def body_start, do: IO.puts("<body>")

    def line(line), do: IO.puts("  <p>#{line}</p>")

    def body_end, do: IO.puts("</body>")

    def doc_end, do: IO.puts("</html>")
  end
end
