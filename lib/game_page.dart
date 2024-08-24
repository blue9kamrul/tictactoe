

import 'package:flutter/material.dart';


class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State <GamePage> createState() =>  GamePageState();
}

class GamePageState extends State <GamePage> {
  //variables
  static const String player_x = 'X';
  static const String player_o = 'O';

  late String currentPlayer;
  late bool gameEnd;
  late List <String> occupied;

  //game starting func
  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = player_x;
    gameEnd = false;
    occupied = List.filled(9, '');
  }

  //game builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
            __restartButton(),
          ]
        ),
      ),
    );
  }

  //header text part
  Widget _headerText(){
    return Column(
      children: [
        const Text("tic tac toe",
        style: TextStyle(
          color: Colors.green,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          ),
        ),
        Text("$currentPlayer's turn",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          ),
        )       
      ],
    );
  }

  //main game container part
  Widget _gameContainer(){
    return Container(
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index){
          return _box(index);
        },
      ),
    );
  }

  //box for game container
  Widget _box(int index){
    return InkWell(
      onTap: (){
        if(gameEnd || occupied[index].isNotEmpty){
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isNotEmpty ? Colors.green : occupied[index] == player_x 
        ? Colors.blue : Colors.orange,
        margin: const EdgeInsets.all(5),
        child: Center(
          child: Text(occupied[index],
          style: const TextStyle(fontSize: 50),) ,
          ),
        )
    );
  }

  //bottom part restart button
  __restartButton(){
    return ElevatedButton(
      onPressed: (){
        setState(() {
          initializeGame();
        });
      },
      child: const Text("Restart Game"),
    );
  }

  //change turn
  void changeTurn(){
    if(currentPlayer == player_x){
      currentPlayer = player_o;
    }else{
      currentPlayer = player_x;
    }
  }

  //winner checklist

  checkForWinner(){
    List<List<int>> winningConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for(var winningPos in winningConditions){
      String playerPosition0  = occupied[winningPos[0]];
      String playerPosition1  = occupied[winningPos[1]];
      String playerPosition2  = occupied[winningPos[2]];

      if(playerPosition0.isNotEmpty){
        if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
          
            showGameOverMessage("player $playerPosition0 won the game");  
            gameEnd = true;
            return;
          }
        }
      }
   }

  //draw checklist
  checkForDraw(){
    if(gameEnd){
      return;
    }
    bool draw = true;
    for(var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        draw = false;
      }
    }

    if(draw){
      showGameOverMessage("Game Draw");
      gameEnd = true;
    }
  }

  //game over message
  showGameOverMessage(String message){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            )
          ],
        );
      }
    );
  }
}
