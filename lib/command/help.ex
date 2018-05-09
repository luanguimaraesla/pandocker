defmodule Command.Help do
  @moduledoc """
  Module to display some text helpers about pandocker usage
  """
  
  @doc """
  Print a help text with some pandockers commands
  """
  def exec do
    IO.puts("""
    usage:  pandocker [compile|help] [-f yaml-configuration-file]

    See full documentation at https://github.com/luanguimaraesla/pandocker
    """)
  end
end
