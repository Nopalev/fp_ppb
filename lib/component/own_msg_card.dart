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
  // bool suspendDialog = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (BuildContext contextBuilder) {
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(contextBuilder);
                  _showUpdateDialog(contextBuilder);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05,
                      top: MediaQuery.of(context).size.height * .015,
                      bottom: MediaQuery.of(context).size.height * .025),
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Flexible(
                          child: Text(
                        "Edit",
                        style: TextStyle(fontSize: 15, letterSpacing: 0.5),
                      ))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(contextBuilder);
                  chatDatabase.deleteMessage(widget.idGame, widget.messageId);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05,
                      top: MediaQuery.of(context).size.height * .015,
                      bottom: MediaQuery.of(context).size.height * .025),
                  child: Row(
                    children: [
                      const Icon(Icons.delete),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Flexible(
                          child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 15, letterSpacing: 0.5),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController txtController = TextEditingController();
    String updatedMsg = widget.message;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 250,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Edit Text",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: updatedMsg,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  // controller: txtController,
                  onChanged: (value) => updatedMsg = value,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                        onPressed: updatedMsg.trim().isEmpty
                              ? null
                              : () {
                                  if (!updatedMsg.trim().isEmpty) {
                                    chatDatabase.updateMessage(widget.idGame, widget.messageId, updatedMsg);
                                  }
                          Navigator.pop(context);
                        },
                        child: const Text("Update"))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
