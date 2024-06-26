class Game {
  List<String> ranks = ['', '', '', ''];
  List<Map<String, dynamic>> players;
  String host;
  bool multiplayer;
  Game({
    required this.players,
    required this.host,
    required this.multiplayer
  });

  void changeRank(int index, int rank){
    players[index]['rank'] = rank;
    setRank();
  }

  void setRank(){
    for(int i=0; i<players.length; i++){
      if(players[i]['rank'] != 0){
        ranks[players[i]['rank'] - 1] = players[i]['username'];
      }
    }
  }

  int playerTurn(String uid){
    for(int i=0; i<players.length; i++){
      if(players[i]['id'] == uid){
        return i+1;
      }
    }
    return 0;
  }

  int getRank(String uid){
    for(int i=0; i<players.length; i++){
      if(players[i]['id'] == uid){
        return players[i]['rank'];
      }
    }
    return 0;
  }

  void addPlayer(Map<String, dynamic> player){
    players.add(player);
  }
}