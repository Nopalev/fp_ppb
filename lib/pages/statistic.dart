import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/floating_action_button.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late String userId;
  int page = 1;
  Map<int, List<String>> contents = {
    1: ['Rank', 'Count', 'Statistic'],
    2: ['Date', 'Rank', 'History'],
  };

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: contents[page]![2]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: page == 1 ? _buildStatisticsTable() : _buildHistoryTable(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomFAB(
            heroTag: 'previous',
            onPressed: (page == 1)
                ? null
                : () {
              setState(() {
                page--;
              });
            },
            icon: const Icon(Icons.chevron_left_outlined),
          ),
          CustomFAB(
            heroTag: 'next',
            onPressed: (page == contents.length)
                ? null
                : () {
              setState(() {
                page++;
              });
            },
            icon: const Icon(Icons.chevron_right_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore
          .instance
          .collection('game')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var games = snapshot.data!.docs;
        Map<int, int> rankCounts = {1: 0, 2: 0, 3: 0, 4: 0};

        // Debugging
        var userGames = games.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return data['players'].any((player) => player['id'] == userId);
        }).toList();
        // print("Games data: ${userGames.map((doc) => doc.data()).toList()}");
        // print("User data: $userId");
        //Debugging

        for (var game in games) {
          var players = game['players'];
          for (var player in players) {
            if (player['id'] == userId) {
              rankCounts[player['rank']] = (rankCounts[player['rank']] ?? 0) + 1;
            }
          }
        }

        return DataTable(
          columns: [
            DataColumn(label: Text(contents[page]![0])),
            DataColumn(label: Text(contents[page]![1])),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('1')),
              DataCell(Text(rankCounts[1].toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('2')),
              DataCell(Text(rankCounts[2].toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('3')),
              DataCell(Text(rankCounts[3].toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('4')),
              DataCell(Text(rankCounts[4].toString())),
            ]),
          ],
        );
      },
    );
  }

  Widget _buildHistoryTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('game')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var games = snapshot.data!.docs;
        List<DataRow> rows = [];
        // print("Number of games: ${games.length}");
        for (var game in games) {
          var players = game['players'];
          int? rank;
          String? date;
          for (var player in players) {
            // print("Player ID: ${player['id']}");
            if (player['id'] == userId) {
              rank = player['rank'];
              date = DateFormat('dd MMM yyyy')
                  .format((game['timestamp'] as Timestamp)
                  .toDate());
              rows.add(DataRow(cells: [
                DataCell(Text(date)),
                DataCell(Text('Rank $rank')),
              ]));
              // print("Player ID: ${player['id']}");
              // print("Player rank: $rank");
              // print("Date: $date");
              break;
            }
          }

        }
        return SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text(contents[page]![0])),
              DataColumn(label: Text(contents[page]![1])),
            ],
            rows: rows,
          ),
        );
      },
    );
  }
}
