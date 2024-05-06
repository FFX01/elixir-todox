defmodule ElixirTodox.Database.Todo do
  alias ElixirTodox.Database.Connection

  defmodule Todo do
    defstruct id: nil,
              value: "",
              is_completed: false
  end

  defp create_statement(conn) do
    :sqlite.prepare(conn, "INSERT INTO todo (value) VALUES (?1);", %{persistent: true})
  end

  defp to_todo({id, value, is_completed}) do
    %Todo{id: id, value: value, is_completed: int_to_bool(is_completed)}
  end

  defp toggle_statement(conn) do
    statement = """
      UPDATE todo
      SET is_completed = CASE WHEN is_completed = 1 THEN 0 ELSE 1 END
      WHERE id = ?;
    """
    |> String.trim()
    :sqlite.prepare(conn, statement, %{persistent: true})
  end

  defp delete_statement(conn) do
    :sqlite.prepare(conn, "DELETE FROM todo WHERE id = ?;", %{persistent: true})
  end

  defp int_to_bool(0), do: false
  defp int_to_bool(1), do: true

  def create(value) do
    conn = Connection.conn()
    conn
    |> create_statement()
    |> :sqlite.execute([value])
    conn
    |> :sqlite.get_last_insert_rowid()
    |> get_by_id()
  end

  def list do
    Connection.conn()
    |> :sqlite.query("SELECT * FROM todo;")
    |> Enum.map(&to_todo/1)
  end

  def get_by_id(id) do
    Connection.conn()
    |> :sqlite.query("SELECT * FROM todo WHERE id = ?", [id])
    |> Enum.fetch!(0)
    |> to_todo()
  end

  def toggle(todo_id) do
    conn = Connection.conn()

    toggle_statement(conn)
    |> :sqlite.execute([todo_id])

    get_by_id(todo_id)
  end

  def delete(id) do
    conn = Connection.conn()

    delete_statement(conn)
    |> :sqlite.execute([id])
  end
end
