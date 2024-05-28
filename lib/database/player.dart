import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/model/player.dart';

class PlayerDatabase{
  final players = FirebaseFirestore.instance.collection('player');

  Future<void> create(Player player){
    final data = {
      'user_id': player.user!.uid,
      'timestamp': Timestamp.now()
    };
    return players.add(data);
  }

  Stream<QuerySnapshot> getPlayersStream(){
    return players.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> update(String id, String note){
    final data = {
      'note': note,
      'timestamp': Timestamp.now()
    };
    return players.doc(id).update(data);
  }

  Future<void> delete(String id){
    return players.doc(id).delete();
  }
}