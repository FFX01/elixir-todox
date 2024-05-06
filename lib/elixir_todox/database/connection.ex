defmodule ElixirTodox.Database.Connection do
  @db_path Path.expand("elixir_todox.sqlite3", File.cwd!())

  def conn do
    :sqlite.open(@db_path)
  end
end
