class Game {
  List<String> ranks = ['', '', '', ''];
  List<Map<String, dynamic>> players;
  Game({
    required this.players,
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
}