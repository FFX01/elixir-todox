defmodule ElixirTodox.View do
  require EEx

  @template_dir Path.expand("lib/templates", File.cwd!())

  EEx.function_from_file(:def, :index, @template_dir <> "/index.html.eex", [:todos])
  EEx.function_from_file(:def, :todo_item, @template_dir <> "/todo_item.html.eex", [:todo])
  EEx.function_from_file(:def, :todo_list, @template_dir <> "/todo_list.html.eex", [:todos])
  EEx.function_from_file(:def, :todo_form, @template_dir <> "/todo_form.html.eex", [:value])
end
