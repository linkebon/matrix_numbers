defmodule Matrix_Numbers do
  use Application

  def start(_type, _args) do
    GameServer.initiate_server()
  end

end