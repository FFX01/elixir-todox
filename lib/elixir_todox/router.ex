defmodule ElixirTodox.Router do
  use Plug.Router

  alias ElixirTodox.Database
  alias ElixirTodox.View

  plug Plug.Logger
  plug Plug.Parsers,
    parsers: [:urlencoded]
  plug Plug.Static,
    at: "/static",
    from: :elixir_todox
  plug :html
  plug :match
  plug :dispatch

  def html(conn, _opts) do
    conn
    |> put_resp_content_type("text/html")
  end

  get "/" do
    body = View.index(Database.Todo.list())
    send_resp(conn, 200, body)
  end

  get "/todos" do
    body = Database.Todo.list()
    |> View.todo_list()
    conn
    |> send_resp(200, body)
  end

  post "/todos" do
    %Plug.Conn{params: %{"value" => value}} = conn

    body = Database.Todo.create(value)
    |> View.todo_item()

    send_resp(conn, 200, body)
  end

  put "/todos/:id" do
    body = Database.Todo.toggle(id)
    |> View.todo_item()

    send_resp(conn, 200, body)
  end

  delete "/todos/:id" do
    Database.Todo.delete(id)

    send_resp(conn, 201, "")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end
