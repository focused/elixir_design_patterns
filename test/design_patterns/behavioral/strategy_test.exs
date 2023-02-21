defmodule DesignPatterns.Behavioral.StrategyTest do
  use ExUnit.Case
  alias DesignPatterns.Behavioral.Strategy.{HTMLFormatter, Report, TextFormatter}

  test "formats as text" do
    assert Report.output(%{title: "Title", text: ["line 1", "line 2"]}, TextFormatter) == %{
             data:
               String.trim("""
               ***** Title *****
               line 1
               line 2
               """)
           }
  end

  test "formats as HTML" do
    assert Report.output(%{title: "Title", text: ["line 1", "line 2"]}, HTMLFormatter) == %{
             data: """
             <html>
               <head>
                 <title>Title</title>
               </head>
               <body>
                 <p>line 1</p>
                 <p>line 2</p>
               </body>
             </html>
             """
           }
  end
end
