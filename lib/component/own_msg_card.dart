import 'package:flutter/material.dart';
import 'package:fp_ppb/database/chat.dart';

class OwnMsgCard extends StatefulWidget {
  // Attribute
  final String idGame;
  final String messageId;
  final String message;
  final String timestamp;

  const OwnMsgCard(
      {super.key,
      required this.idGame,
      required this.messageId,
      required this.message,
      required this.timestamp});

  @override
  State<OwnMsgCard> createState() => _OwnMsgCardState();
}

class _OwnMsgCardState extends State<OwnMsgCard> {
  // Firestore
  final ChatDatabase chatDatabase = ChatDatabase();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showButtomSheet();
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color(0xFF3C0753),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    // MESSAGE
                    padding: const EdgeInsets.fromLTRB(10, 5, 40, 20),
                    child: Text(
                      widget.message,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )),
                Positioned(
                    bottom: 4,
                    right: 10,
                    child: Text(
                      widget.timestamp,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showButtomSheet() {
    // if(!mounted) return;
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (BuildContext buildContext) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                  height: 2,
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * .015,
                      horizontal: MediaQuery.of(context).size.width * .4),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8))),
              const Text(
                "Option",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              _OptionItem(
                  icon: const Icon(
                    Icons.edit,
                    size: 26,
                  ),
                  name: "Edit Text",
                  onTap: () {
                    setState(() {
                      
                    });
                    _showUpdateDialog();
                    // Navigator.pop(buildContext);
                  }),
              _OptionItem(
                  icon: const Icon(
                    Icons.delete,
                    size: 26,
                  ),
                  name: "Delete Text",
                  onTap: () {
                    chatDatabase.deleteMessage(widget.idGame, widget.messageId);
                    Navigator.pop(buildContext);
                  }),
            ],
          );
        });
  }

  // update dialog
  // void _showUpdateDialog() {
  //   String updatedMsg = widget.message;
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24, right: 24, top: 20, bottom: 10),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             title: const Text("Update Message"),
  //             content: TextFormField(
  //               initialValue: updatedMsg,
  //               maxLines: null,
  //               onChanged: (value) => updatedMsg = value,
  //               decoration: InputDecoration(
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10))),
  //             ),
  //             actions: [
  //               MaterialButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text(
  //                   "Cancel",
  //                   style: TextStyle(color: Colors.red, fontSize: 16),
  //                 ),
  //               ),
  //               MaterialButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   chatDatabase.updateMessage(
  //                       widget.idGame, widget.messageId, updatedMsg);
  //                 },
  //                 child: const Text(
  //                   "Update",
  //                   style: TextStyle(color: Colors.blue, fontSize: 16),
  //                 ),
  //               )
  //             ],
  //           ));
  // }

  void _showUpdateDialog() {
    final TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    chatDatabase.updateMessage(
                        widget.idGame, widget.messageId, textController.text);
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .05,
            top: MediaQuery.of(context).size.height * .015,
            bottom: MediaQuery.of(context).size.height * .025),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: MediaQuery.of(context).size.width * .02,
            ),
            Flexible(
                child: Text(
              name,
              style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
