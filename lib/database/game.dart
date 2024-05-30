import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/model/game.dart';

class GameDatabase{
  final games = FirebaseFirestore.instance.collection('game');

  Future<DocumentReference> create(Game game){
    final data = {
      'players': game.players,
      'timestamp': Timestamp.now()
    };
    return games.add(data);
  }

  Stream<QuerySnapshot> getPlayersStream(){
    return games.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> update(String id, Game game){
    final data = {
      'players': game.players,
      'timestamp': Timestamp.now()
    };
    return games.doc(id).update(data);
  }

  Future<void> delete(String id){
    return games.doc(id).delete();
  }
}