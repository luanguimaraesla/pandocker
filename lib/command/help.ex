defmodule Command.Help do
  @moduledoc """
  Module to display some text helpers about pandocker usage
  """
  
  @doc """
  Print a help text with some pandockers commands
  """
  def exec do
    IO.puts("""
    usage:  pandocker [new [-t template]] [compile [-f yaml-configuration]]

    COMMANDS
    
      new           Creates a new Pandocker structure
      compile       Generates the PDF file from the template

    OPTIONS

      --file (-f)       Specifies a Pandocker template file
      --template (-t)   Specifies a Git template structure

    See full documentation at https://github.com/luanguimaraesla/pandocker
    """)
  end
end
