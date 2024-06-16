import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/model/player.dart';

class PlayerDatabase{
  final players = FirebaseFirestore.instance.collection('player');

  Future<DocumentReference> create(String uid){
    final data = {
      'user_id': uid,
      'current_game': '',
      'played_game': [],
      'timestamp': Timestamp.now()
    };
    return players.add(data);
  }

  Future<Player> getPlayer(String uid) async {
    final playerData = await players.where('user_id',isEqualTo: uid).get();
    return Player(
      userID: playerData.docs.first.data()['user_id'],
      currentGame: playerData.docs.first.data()['current_game'],
      playedGame: List<String>.from(playerData.docs.first.data()['played_game'])
    );
  }

  Future<void> update(Player player) async {
    final playerData = await players.where('user_id',isEqualTo: player.userID).get();
    final data = {
      'user_id': player.userID,
      'current_game': player.currentGame,
      'played_game': player.playedGame,
      'timestamp': Timestamp.now()
    };
    return players.doc(playerData.docs.first.id).update(data);
  }

  Future<void> delete(String id){
    return players.doc(id).delete();
  }
}