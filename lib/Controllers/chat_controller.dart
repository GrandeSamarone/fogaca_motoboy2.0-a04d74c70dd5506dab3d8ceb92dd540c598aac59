import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatController extends ChangeNotifier {
  User? user;

  List<types.Room> chatList = [];
  List<types.TextMessage> messages = [];
  var selectedChat = "";
  var selectedIdCollection = "";

  StreamSubscription? streamMessages;
  StreamSubscription? streamChats;

  ChatController() {
    user = FirebaseAuth.instance.currentUser!;
    //listenChats();
  }

  listenChats() {
    if (streamChats != null) streamChats!.cancel();
    chatList.clear();
    notifyListeners();
    streamChats = FirebaseFirestore.instance
        .collection("chats")
        .where("boy_id", isEqualTo: user!.uid)
        .where("status", isGreaterThan: 0)
        .snapshots()
        .listen((data) {
      chatList.clear();
      data.docs.forEach((doc) {
        chatList.add(types.Room.fromJson(doc.data()));
        notifyListeners();
      });
    });
  }

  listenMessages() {
    if (streamMessages != null) streamMessages!.cancel();

    print("chat $selectedChat");
    print("chat $selectedIdCollection");
    streamMessages = FirebaseFirestore.instance
        .collection("chats")
        .doc(selectedChat)
        .collection(selectedIdCollection)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((data) {
      messages.clear();
      print("new message");
      messages.addAll(
          data.docs.map((e) => types.TextMessage.fromJson(e.data())).toList());
      notifyListeners();
    });
  }
}
