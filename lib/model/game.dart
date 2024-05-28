class Game {
  List<String> players, rank = [];
  Game({
    required this.players
  });

  void changeRank(int index){
    rank.add(players[index]);
  }
}