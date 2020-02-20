defmodule Data do
  def read_header(device) do
    [n_books, n_libraries, n_days] = read_input(device) |> Enum.take(3)
    {n_books, n_libraries, n_days}
  end

  def read_books(device, n) do
    read_input(device) |> Enum.take(n)
  end

  def read_libraries(device, n) do
    Enum.map(0..(n - 1), fn n ->
      [n_books, signup_days, n_concurent_book] = read_input(device)
      books = read_input(device) |> Enum.take(n_books)
      {n, books, n_books, signup_days, n_concurent_book}
    end)
  end

  defp read_input(device) do
    read_list(device) |> Enum.map(&String.to_integer/1)
  end

  defp read_list(device) do
    IO.read(device, :line) |> String.trim() |> String.split(" ")
  end

  def format_libraries(libraries) do
    libraries
    |> Enum.map(fn {n, books} ->
      [
        [n |> to_string(), length(books) |> to_string()] |> Enum.intersperse(" "),
        books |> Enum.map(&to_string/1) |> Enum.intersperse(" ")
      ]
      |> Enum.intersperse("\n")
    end)
    |> Enum.reverse()
    |> Enum.intersperse("\n")
  end
end

defmodule Hashcode do
  def main do
    {:ok, device} = File.open("./data/f_libraries_of_the_world.txt")
    # Read the header
    {n_books, n_libraries, budget} = Data.read_header(device)
    _order = Data.read_books(device, n_books)
    libraries = Data.read_libraries(device, n_libraries)

    IO.puts(["Number of books: ", n_books |> to_string()])
    IO.puts(["Number of libraries: ", n_libraries |> to_string()])
    IO.puts(["Budget: ", budget |> to_string()])

    libraries = rank_libraries(libraries, budget)
    {signup_days, libraries} = select_libraries(libraries, budget)

    IO.puts(["Starting days: ", signup_days |> to_string()])

    libraries = invest_libraries(libraries, budget - signup_days)

    IO.puts(libraries |> length() |> to_string())
    IO.puts(libraries |> Data.format_libraries())
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

Hashcode.main
