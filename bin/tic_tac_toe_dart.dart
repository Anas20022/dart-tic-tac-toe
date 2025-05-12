import 'dart:io';

// 3x3 board (init with spaces)
List<String> board = List.generate(9, (i) => ' ');

// Scores
int player1Wins = 0;
int player2Wins = 0;
int draws = 0;

// Draw board
void printBoard() {
  print('');
  print(' ${board[0]} | ${board[1]} | ${board[2]} ');
  print('---+---+---');
  print(' ${board[3]} | ${board[4]} | ${board[5]} ');
  print('---+---+---');
  print(' ${board[6]} | ${board[7]} | ${board[8]} ');
  print('');
}

// Check win
bool checkWin(String symbol) {
  List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6],            // Diagonals
  ];

  for (var pattern in winPatterns) {
    if (pattern.every((i) => board[i] == symbol)) {
      return true;
    }
  }
  return false;
}

// Check for a draw (all cells are filled)
bool checkDraw() {
  return board.every((cell) => cell != ' ');
}

// Ask the player for a valid move (1–9)
int getValidMove(String player) {
  while (true) {
    stdout.write('$player, enter a number from 1 to 9: ');
    var input = stdin.readLineSync();

    if (input == null || int.tryParse(input) == null) {
      print('⚠️  Please enter a valid number.');
      continue;
    }

    int move = int.parse(input) - 1;

    if (move < 0 || move > 8) {
      print('❌ Invalid position on the board.');
    } else if (board[move] != ' ') {
      print('❌ Cell is already taken. Try another one.');
    } else {
      return move;
    }
  }
}

// Main game logic
void startGame() {
  print('\n🎮 Welcome to Tic-Tac-Toe (developed by me!)');
  printBoard();

  String symbol1;
  while (true) {
    stdout.write('Player 1, choose your symbol (X or O): ');
    var input = stdin.readLineSync()?.toUpperCase();

    if (input == 'X' || input == 'O') {
      symbol1 = input!;
      break;
    } else {
      print('⚠️  Only X or O is allowed.');
    }
  }

  String symbol2 = (symbol1 == 'X') ? 'O' : 'X';
  print('✅ Player 1: $symbol1 | Player 2: $symbol2');

  String currentPlayer = 'Player 1';
  String currentSymbol = symbol1;

  while (true) {
    printBoard();
    int move = getValidMove(currentPlayer);
    board[move] = currentSymbol;

    if (checkWin(currentSymbol)) {
      printBoard();
      print('🏆 Congratulations $currentPlayer, you won!');
      if (currentPlayer == 'Player 1') {
        player1Wins++;
      } else {
        player2Wins++;
      }
      break;
    }

    if (checkDraw()) {
      printBoard();
      print('🤝 It\'s a draw!');
      draws++;
      break;
    }

    // Switch turns
    if (currentPlayer == 'Player 1') {
      currentPlayer = 'Player 2';
      currentSymbol = symbol2;
    } else {
      currentPlayer = 'Player 1';
      currentSymbol = symbol1;
    }
  }
}

void main() {
  while (true) {
    board = List.generate(9, (i) => ' ');
    startGame();

    // Show scoreboard after each game
    print('\n📊 Scoreboard:');
    print('Player 1 wins: $player1Wins');
    print('Player 2 wins: $player2Wins');
    print('Draws: $draws');

    stdout.write('\n🔁 Do you want to play again? (y/n): ');
    String? again = stdin.readLineSync()?.toLowerCase();

    if (again != 'y') {
      print('👋 Thanks for playing. Goodbye!');
      break;
    }
  }
}
