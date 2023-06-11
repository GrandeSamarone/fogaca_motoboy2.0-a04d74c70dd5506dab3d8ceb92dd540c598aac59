import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

abstract class ChatModel extends StatelessWidget {
  var chatId;
  var chatIdColec;
  //var chat_collection_Id;
  var firestore = FirebaseFirestore.instance;

  sendMessage(text, user) {
    var id = Uuid().v1();
    var message = types.TextMessage(
      id: id,
      text: text,
      author: user,
      createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    firestore
        .collection("chats")
        .doc(chatId)
        .collection(chatIdColec)
        .doc(id)
        .set(message.toJson());

    firestore.collection("chats").doc(chatId).update({
      "lastMessages": [message.toJson()],
      "mode": "message"
    });
  }
}
