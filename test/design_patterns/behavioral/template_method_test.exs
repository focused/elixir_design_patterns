defmodule DesignPatterns.Behavioral.TemplateMethodTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias DesignPatterns.Behavioral.TemplateMethod.{HTMLReport, TextReport}

  test "formats as text" do
    assert capture_io(fn -> TextReport.output() end) == """
           **** Monthly Report ****

           Things are going
           really really well
           """
  end

  test "formats as HTML" do
    assert capture_io(fn -> HTMLReport.output() end) == """
           <html>
           <head>
             <title>Monthly Report</title>
           </head>
           <body>
             <p>Things are going</p>
             <p>really really well</p>
           </body>
           </html>
           """
  end
end
