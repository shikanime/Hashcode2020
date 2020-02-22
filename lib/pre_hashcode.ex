defmodule Data do
  def read_header do
    IO.read(:line)
    |> String.split()
    |> List.first()
    |> String.to_integer()
  end

  def read_pizzas do
    IO.read(:line)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp put_types(orders) do
    orders
    |> length()
    |> IO.puts()
  end

  defp put_orders(orders) do
    orders
    |> Enum.intersperse(" ")
    |> Enum.map(&to_string/1)
    |> IO.puts()
  end
end

defmodule PreHashcode do
  def solve do
    n = read_header()
    pizzas = read_pizzas()
    orders = PreHashcode.solve(pizzas, n)
    put_types(orders)
    put_orders(orders)
  end

  def solve(pizzas, n) do
    pizzas
    |> Enum.with_index()
    |> Enum.sort()
    |> Enum.reverse()
    |> do_solve(n)
  end

  defp do_solve(pizzas, n, m \\ 0, acc \\ [])

  defp do_solve([{pizza, idx} | rest], n, m, acc) when n >= m + pizza do
    do_solve(rest, n, pizza + m, [idx | acc])
  end

  defp do_solve([_ | rest], n, m, acc) do
    do_solve(rest, n, m, acc)
  end

  defp do_solve([], _, _, acc) do
    acc
  end
end
