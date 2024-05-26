import 'package:flutter/material.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/floating_action_button.dart';

class HowToPlayPage extends StatefulWidget {
  const HowToPlayPage({super.key});

  @override
  State<HowToPlayPage> createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage> {
  int page = 1;
  Map<int, List<String>> contents = {
    1 : [
      'lib/assets/howtoplay-1.jpg',
      'Every game room has a 8x10 game board, 4 players that can be either '
      'human or bot, 4 sets of 2 way vortex (indicated by colored tiles) that '
      'act as both snake and ladder, and a leaderboard. Each players play in turn, '
      'indicated by their color of their player pieces below the game board '
      '(the highlighted one is the one who get to roll the dice, while the dimly lit '
      'one are waiting for their turn).'
    ],
    2 : [
      'lib/assets/howtoplay-2.jpg',
      'Upon tapping the dice button below, a pop up showing the result of a dice '
      'roll would appear. Tapping the close button would close the button and '
      'the player piece that have the turn will start move towards the next tile '
      '(indicated by a number inside a tile) according to the dice roll result.'
    ],
    3 : [
      'lib/assets/howtoplay-3.jpg',
      'In this picture, the first player\'s player piece is moving to their '
      'next tile 6 times. Note the color change on the player pieces below the game board, '
      'indicating a change in turn. Finishing a turn at one of the colored tiles would means '
      'that player piece hit either a snake or ladder. Finishing at the bottom part of '
      'the colored tiles set would means the player piece would teleport to another tile '
      'with the same color. Finishing at the top part would means the exact opposite.'
    ],
    4 : [
      'lib/assets/howtoplay-4.jpg',
      'When a player piece hit the 80-th tile, that player would finished the game. '
      'They may leave the game room, or watch the rest of the game. Their username '
      'would be etched in the leaderboard above the game board.'
    ],
    5 : [
      'lib/assets/howtoplay-5.jpg',
      'If the third place has been decided, the game would finished. A pop up showing the '
      'leaderboard would show, and tapping the close button would send the player '
      'back to the home page.'
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'How to Play'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Image.asset(
                contents[page]![0],
                height: 400,
              ),
              const SizedBox(height: 20),
              Text(
                contents[page]![1],
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomFAB(
            heroTag: 'previous',
            onPressed: (page == 1) ? null : (){
              setState(() {
                page--;
              });
            },
            icon: const Icon(
              Icons.chevron_left_outlined
            )
          ),
          CustomFAB(
            heroTag: 'next',
            onPressed: (page == contents.length) ? null : (){
              setState(() {
                page++;
              });
            },
            icon: const Icon(
                Icons.chevron_right_outlined
            )
          )
        ],
      ),
    );
  }
}
