defmodule Matrix_Numbers do
  use Application

  def start(_type, _args) do
    Game_Server.initiate_server()
  end

end