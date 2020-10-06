defmodule GameLogic do
  @moduledoc """
  Documentation for `GameLogic`.
  Module contains the game logic for running matrix_numbers game
  """

  @doc """
  Generates the game field players start with

  ## Examples
      iex> GameLogic.generate_game_field(3,3)
      [[11,12,13],[21,22,23],[31,32,33]]
  """
  def generate_start_game_field(rows, columns),
    do:
      for(
        row <- 0..(rows - 1),
        do: Enum.to_list(first_value_in_row(row)..last_value_in_row(row, columns))
      )

  @doc """
  Generates a new game field from the starting game_field and removes blocks of numbers
  depending on the value to be removed

  ## Examples
      iex> GameLogic.generate_new_game_field([[11,12,13],[21,22,23],[31,32,33]], 22)
      [[11,12,13],[21,-1,-1],[31,-1,-1]]
  """
  def generate_new_game_field(game_field, remove_val),
    do:
      Enum.map(
        game_field,
        fn row ->
          Enum.map(
            row,
            fn current_val ->
              if(should_value_be_removed?(current_val, remove_val)) do
                -1
              else
                current_val
              end
            end
          )
        end
      )

  @doc """
  Decides if the game is over.

  ## Examples
      iex> GameLogic.game_over?([[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]])
      true
  """
  def game_over?(game_field),
    do:
      Enum.all?(
        game_field,
        fn row ->
          Enum.all?(
            row,
            fn val -> val == -1 end
          )
        end
      )

  @doc """
  Returns the game_field as a string

  ## Examples
      iex> GameLogic.game_field_as_string([[11,12,13],[21,-1,-1],[31,-1,-1]], 22)
      Game field
      ---------------
      11 12 13
      21
      31
      ---------------
  """
  def game_field_as_string(game_field) do
    game_field_str =
      Enum.map(
        game_field,
        fn row ->
          Enum.join(row, " ")
          |> String.replace("-1", " ")
        end
      )
      |> Enum.join("\n")

    "\nGame field \n---------------\n" <> game_field_str <> "\n---------------\n"
  end

  @doc """
  Checks if the number is a valid number existing in the game field

  ## Examples
      iex> GameLogic.number_exist_in_game_field([[11,12,13],[21,-1,-1],[31,-1,-1]], 13)
      true
  """
  def number_exist_in_game_field?(game_field, number),
    do:
      game_field
      |> Enum.any?(fn row -> number in row end)

  defp should_value_be_removed?(current_val, remove_val) do
    current_val_row = getRow(current_val)
    current_val_col = getCol(current_val)
    remove_val_row = getRow(remove_val)
    remove_val_col = getCol(remove_val)

    case current_val do
      x when current_val_row == remove_val_row and x >= remove_val ->
        true

      x
      when remove_val_row < current_val_row and
             current_val_col >= remove_val_col and
             x >= remove_val ->
        true

      _ ->
        false
    end
  end

  defp first_value_in_row(n), do: (n + 1) * 10 + 1

  defp last_value_in_row(current_row, columns), do: first_value_in_row(current_row) + columns - 1

  defp getRow(val), do: div(val, 10) - 1

  defp getCol(val), do: rem(val, 10)
end
