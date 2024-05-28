class Game {
  List<String> players, rank = [], usernames;
  Game({
    required this.players,
    required this.usernames
  });

  void changeRank(int index){
    rank.add(usernames[index]);
  }
}