defmodule Data do
  def read_header do
    [n_books, n_libraries, n_days] = read_input() |> Enum.take(3)
    {n_books, n_libraries, n_days}
  end

  def read_books(n) do
    read_input() |> Enum.take(n)
  end

  def read_libraries(n) do
    Enum.map(0..(n - 1), fn n ->
      [n_books, signup_days, n_concurent_book] = read_input()
      books = read_input() |> Enum.take(n_books)
      {n, books, n_books, signup_days, n_concurent_book}
    end)
  end

  defp read_input do
    read_list() |> Enum.map(&String.to_integer/1)
end

  defp read_list do
    IO.read(:line) |> String.trim() |> String.split(" ")
  end
end

defmodule Hashcode do
  require Logger

  def main do
    # Read the header
    {n_books, n_libraries, budget} = Data.read_header()
    _book_ids = Data.read_books(n_books)
    libraries = Data.read_libraries(n_libraries)

    # Read all libraries stock
    Logger.info(["Number of books: ", n_books |> to_string()])
    Logger.info(["Number of libraries: ", n_libraries |> to_string()])
    Logger.info(["Budget: ", budget |> to_string()])

    libraries = rank_libraries(libraries, budget)
    offset_days = signup_libraries(libraries, budget)

    IO.inspect(libraries)
    IO.inspect(offset_days)

    # libraries = select_libraries(libraries, offset_days)
    # invest(libraries, budget)
  end

  defp rank_libraries(libraries, budget) do
    Enum.sort_by(libraries, &score(&1, budget))
  end

  defp signup_libraries(libraries, budget) do
    Enum.reduce_while(libraries, budget, fn {_, _, _, signup_days, _}, acc ->
      case acc - signup_days do
        rest when rest > 0 -> {:cont, rest}
        _ -> {:halt, budget}
      end
    end)
  end

  # defp select_libraries(libraries, days) do
  #   select_libraries(libraries)
  # end

  # defp invest(libraries, 0, res) do
  #   res
  # end

  # defp invest([{n, books, n_books, signup_days, n_concurent_book} | rest], budget) do
  #   rest_days = budget - signup_days
  #   process_books = floor((n_books - days) / n_concurent_book)
  #   invest(libraries, days, books |> Enum.take(process_books))
  # end

  defp score({n, _, n_books, signup_days, n_concurent_book}, budget) do
    budget - (n_books  / n_concurent_book) + signup_days
  end
end

