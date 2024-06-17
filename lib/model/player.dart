class Player {
  String userID;
  String currentGame;
  List<String> playedGame;

  Player({
    required this.userID,
    this.currentGame = '',
    this.playedGame = const []
  });

  void setCurrentGame(String gameID){
    currentGame = gameID;
  }

  void addPlayedGame(String gameID){
    playedGame.add(gameID);
  }
}