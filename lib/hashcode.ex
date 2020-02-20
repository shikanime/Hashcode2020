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
    _order = Data.read_books(n_books)
    libraries = Data.read_libraries(n_libraries)

    Logger.info(["Number of books: ", n_books |> to_string()])
    Logger.info(["Number of libraries: ", n_libraries |> to_string()])
    Logger.info(["Budget: ", budget |> to_string()])

    libraries = rank_libraries(libraries, budget)
    {signup_days, libraries} = select_libraries(libraries, budget)

    IO.inspect(libraries)
    Logger.info(["Starting days: ", signup_days |> to_string()])

    selected_books = invest_libraries(libraries, budget - signup_days)

    IO.inspect(selected_books)
  end

  defp rank_libraries(libraries, budget) do
    Enum.sort_by(libraries, &score(&1, budget))
  end

  defp score({_, _, n_books, signup_days, n_concurent_book}, budget) do
    budget - (n_books  / n_concurent_book) + signup_days
  end

  defp select_libraries(libraries, budget, offset \\ 0, res \\ [])

  defp select_libraries([library | rest], budget, offset, res) do
    {_, _, _, signup_days, _} = library

    case offset + signup_days do
      next when next <= budget ->
          select_libraries(rest, budget, next, [library | res])

        _ ->
        {offset, res}
    end
  end

  defp select_libraries([], _, offset, res) do
    {offset, res}
  end

  defp invest_libraries(libraries, days) do
    Enum.map(libraries, fn {n, books, n_books, _, n_concurent_book} ->
      process_books = floor((n_books - days) * n_concurent_book)
      {n, Enum.take(books, process_books)}
    end)
  end

  # defp score_book(libraries, order) do
  #   Enum.sort_by(libraries, fn library ->
  #     {score, _} =
  #       order
  #       |> Enum.with_index()
  #       |> Enum.find(fn {_, index} -> library == index end)

  #     score
  #   end, :desc)
  # end
end

