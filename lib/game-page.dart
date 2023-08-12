import "package:flutter/material.dart";


class GamePage extends StatefulWidget{
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>{
  static const String Player_X = 'X';
  static const String Player_O = 'O';

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  static const styleText = TextStyle(
              color: Colors.green,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            );
  
  @override
  void initState() {
    initializeGame();
    super.initState();
  }
  void initializeGame(){
    currentPlayer = Player_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
          ]),
      )
    );
  }

  Widget _headerText(){
    return Column(
          children: [
            const Text("Jogo da Velha", style: styleText,
            ),
            Text("vez de $currentPlayer", style: styleText,
            ),
          ],
        );
  }

  Widget _gameContainer(){
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.height/2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3), 
          itemBuilder: (context, int index){
            return _box(index);
          }
        ),
      );
  }

  Widget _box(int index){
    return InkWell(
      onTap: (){
        if(gameEnd || occupied[index].isNotEmpty){
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
        });
      },
      child: Container(
          color: occupied[index].isEmpty ? 
          Colors.black26: occupied[index] == Player_X ? 
          Colors.greenAccent: Colors.purpleAccent,
          margin: const EdgeInsets.all(8),
          child: Center(
        child: Text(
          occupied[index],
          style: const TextStyle(fontSize: 50)
          ),
        ),
      )
    );
  }
  changeTurn(){
    if(currentPlayer == Player_X){
      currentPlayer = Player_O;
    } else{
      currentPlayer = Player_X;
    }
    checkForWinner();
  }
  checkForWinner(){
     List<List<int>> WinningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
     ];

     for(var winningPos in WinningList){
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if(playerPosition0.isNotEmpty){
        if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
     }
  }

  showGameOverMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Game Over \n $message", 
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
          )
        )
      )
    );
  }
}