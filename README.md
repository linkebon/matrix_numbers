# MatrixNumbers

Matrix numbers game that can be played with 2 clients
Start a server with 2 port: Game_Server.start_game(4050, 4051)
Connect with 2 telnet clients on each port
client1: telnet ip 4050
client2: telnet ip 4051

Play the game by creating a numbers matrix by defining amount of rows and columns the game field should have
Then each player removes values by providing a number on the game field.

The player that removes the last element loose.

Game field generated by 9 rows and 9 columns below
```
--------------
1 12 13 14 15 16 17 18 19
1 22 23 24 25 26 27 28 29
1 32 33 34 35 36 37 38 39
1 42 43 44 45 46 47 48 49
1 52 53 54 55 56 57 58 59
1 62 63 64 65 66 67 68 69
1 72 73 74 75 76 77 78 79
1 82 83 84 85 86 87 88 89
1 92 93 94 95 96 97 98 99
--------------
```
## Installation
mix compile 



