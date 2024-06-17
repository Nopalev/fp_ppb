import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/model/game.dart';

class GameDatabase{
  final games = FirebaseFirestore.instance.collection('game');

  Future<DocumentReference> create(Game game) async {
    final data = {
      'host': game.host,
      'multiplayer': game.multiplayer,
      'players': game.players,
      'timestamp': Timestamp.now()
    };
    DocumentReference documentReference = await games.add(data);
    await createGameLog(documentReference.id);
    return documentReference;
  }

  Future<Game> getGame(String id) async {
    final data = await games.doc(id).get();
    List<dynamic> playerData = data.get('players');
    List<Map<String, dynamic>> players = [];
    for(int i=0; i<playerData.length; i++){
      players.add({
        'bot': playerData[i]['bot'],
        'rank': playerData[i]['rank'],
        'turn': playerData[i]['turn'],
        'id': playerData[i]['id'],
        'username': playerData[i]['username'],
      });
    }
    return Game(
      host: data.get('host').toString(),
      multiplayer: (data.get('multiplayer').toString() == 'true') ? true : false,
      players: players
    );
  }

  Future<void> createGameLog(String id) async {
    await games.doc(id).collection('game_log').add({
      'log': []
    });
  }

  Future<void> addGameLog(String id, String log) async {
    QuerySnapshot<Map<String, dynamic>> gameLog = await games.doc(id).collection('game_log').get();
    String logID = gameLog.docs.first.id;
    List<String> logs = List<String>.from(gameLog.docs.first.data()['log']);
    logs.add(log);
    await games.doc(id).collection('game_log').doc(logID).update({'log': logs});
  }

  Future<List<QueryDocumentSnapshot>> getLog(String id) async {
    QuerySnapshot<Map<String, dynamic>> gameLog = await games.doc(id).collection('game_log').get();
    return gameLog.docs;
  }

  Future<int> getPlayerDiceResult(String id, int player, int turn) async {
    String logMsg = '$player:$turn:';
    while(true){
      QuerySnapshot<Map<String, dynamic>> gameLog = await games.doc(id).collection('game_log').get();
      List<String> logs = List<String>.from(gameLog.docs.first.data()['log']);
      List<String> result = logs.where((element){
        return element.contains(logMsg);
      }).toList();
      if(result.isNotEmpty){
        String dice = result.first.split(':').last.split(']').first;
        return int.parse(dice);
      }
    }
  }

  Future<List<DocumentChange>> logChange(String id) async {
    QuerySnapshot<Map<String, dynamic>> gameLog = await games.doc(id).collection('game_log').get();
    return gameLog.docChanges;
  }

  Future<void> update(String id, Game game){
    final data = {
      'host': game.host,
      'multiplayer': game.multiplayer,
      'players': game.players,
      'timestamp': Timestamp.now()
    };
    return games.doc(id).update(data);
  }

  Future<void> delete(String id){
    return games.doc(id).delete();
  }
}