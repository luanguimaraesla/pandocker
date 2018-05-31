defmodule Command.Help do
  @moduledoc """
  Module to display some text helpers about pandocker usage
  """
  
  @doc """
  Print a help text with some pandockers commands
  """
  def exec do
    IO.puts("""
    usage:  pandocker [compile|help|new] [-f yaml-configuration-file -t template]

    See full documentation at https://github.com/luanguimaraesla/pandocker
    """)
  end
end
