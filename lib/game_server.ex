defmodule Game_Server do
  require Logger

  @moduledoc """
  Documentation for `Game_Server`.
  Lets two clients connect to the server by for example telnet
  The game starts when two players are connected.
  """

  @doc """
  Starts a game server listening on two ports
  First player should connect to port_player1 then second player connects to port_player2
  ## Examples
      iex> GameLogic.start_game(4000,4001)
  """
  def start_game(port_player1, port_player2) do
    {:ok, socket_p1} =
      :gen_tcp.listen(port_player1, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port_player1}")

    {:ok, socket_p2} =
      :gen_tcp.listen(port_player2, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port_player2}")

    {:ok, client1} = :gen_tcp.accept(socket_p1)
    Logger.info("Player 1 connected")

    {:ok, client2} = :gen_tcp.accept(socket_p2)
    Logger.info("Player 2 connected")

    initiate_game(client1, client2)
  end

  defp initiate_game(socket_p1, socket_p2) do
    player1 = {:player1, socket_p1}
    player2 = {:player2, socket_p2}
    write_to_clients("\n\nWelcome to Matrix game!", player1, player2)
    game_field = Game_Logic.generate_start_game_field(9, 9)
    write_to_clients(Game_Logic.game_field_as_string(game_field), player1, player2)
    current_player = which_players_turn?(player1, player2)
    new_turn(game_field, current_player, player1, player2)
  end

  defp new_turn(game_field, current_player, player1, player2) do
    other_player = other_players_turn(current_player, player1, player2)
    write_line("\nIt's your turn\n", elem(current_player, 1))
    write_line("\nOther players turn.. Please wait", elem(other_player, 1))
    remove_val = number_exist_in_game_field?(game_field, current_player)

    write_line(
      "Other player removed number: #{remove_val}\n\n",
      elem(other_player, 1)
    )

    new_game_field = Game_Logic.generate_new_game_field(game_field, remove_val)
    write_to_clients(Game_Logic.game_field_as_string(new_game_field), player1, player2)
    game_over?(new_game_field, current_player, player1, player2)
  end

  defp number_exist_in_game_field?(game_field, player) do
    write_line("Enter number to remove: ", elem(player, 1))
    remove_val = read_int_from_client(elem(player, 1))

    if(Game_Logic.number_exist_in_game_field?(game_field, remove_val)) do
      remove_val
    else
      number_exist_in_game_field?(game_field, player)
    end
  end

  defp player_atom_str(player), do: Atom.to_string(elem(player, 0))

  defp other_players_turn(current_player, player1, player2) do
    case elem(current_player, 0) do
      :player1 -> player2
      :player2 -> player1
    end
  end

  defp which_players_turn?(player1, player2, current_player \\ nil) do
    case current_player do
      nil ->
        player1

      _ ->
        if(elem(current_player, 0) == :player1) do
          Logger.info("player2")
          player2
        else
          Logger.info("player1")
          player1
        end
    end
  end

  defp game_over?(game_field, current_player, player1, player2) do
    if(Game_Logic.game_over?(game_field)) do
      write_line(
        "You won!!! Congratulations!",
        elem(other_players_turn(current_player, player1, player2), 1)
      )

      write_line(
        "You lost.. You took the last element and therefore you lost!",
        elem(current_player, 1)
      )
    else
      next_player = which_players_turn?(player1, player2, current_player)
      write_to_clients("#{player_atom_str(next_player)}'s turn! \n", player1, player2)
      new_turn(game_field, next_player, player1, player2)
    end
  end

  defp read_int_from_client(socket) do
    case read_line(socket)
         |> String.trim()
         |> Integer.parse() do
      {parsed, _} ->
        parsed

      :error ->
        write_line("\nInvalid number provided.. Try again \n", socket)
        read_int_from_client(socket)
    end
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_to_clients(line, player1, player2) do
    write_line(line, elem(player1, 1))
    write_line(line, elem(player2, 1))
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
