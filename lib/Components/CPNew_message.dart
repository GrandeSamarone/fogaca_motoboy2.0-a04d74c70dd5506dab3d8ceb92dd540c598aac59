import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/ChatMessage.dart';

class NewMessage extends StatefulWidget {
  var doc;
  var msgvazio;
  var id;
  var nome;
  var token_from;
  var id_from;

  NewMessage({
    required this.doc,
    required this.id,
    required this.nome,
    required this.token_from,
    required this.id_from,
  });

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();
  var auth = FirebaseAuth.instance;

  Future<void> _sendMessage() async {

    _messageController.clear();

    // EnviarNotification();

    if (widget.id != null) {
      await save(_message);



    }
  }
  Future<ChatMessage?> save(String text) async {
    final store = FirebaseFirestore.instance;

    ChatMessage chatMessage=new ChatMessage();

    chatMessage= ChatMessage(
        id: '',
        msg: text,
        data_msg: DateTime.now(),
        user_id: widget.id,
        user_nome: widget.nome,
        id_from: widget.id_from,
        id_doc:widget.doc
    );

    final docRef = await store
        .collection("chats")
        .doc(widget.doc)
        .collection("mensagens")
        .withConverter(
      fromFirestore: _fromFirestore,
      toFirestore: _toFirestore,
    ).add(chatMessage);

    await store.collection("chats").doc(widget.doc).update({
      "lastMessages": [chatMessage.toJson()],
      "mode": "message"
    });
    final doc = await docRef.get();
    return doc.data()!;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(

            controller: _messageController,
            onChanged: (msg) => setState(() => _message = msg),
            decoration: InputDecoration(
                labelText: 'Enviar mensagem...'
                ,labelStyle:TextStyle(color: Colors.white70)
            ),

            onSubmitted: (_) {
              if (_message.trim().isNotEmpty) {
                _sendMessage();
              }
            },
            style: TextStyle(
              color: const Color(0xffFDFDFD),
              fontSize: 14.0,
              fontFamily: "Brand-Regular",),
          ),
        ),

        IconButton(
          icon: Icon(Icons.send,
            color: Colors.white70,
          ),
          onPressed: _message.trim().isEmpty ? null : _sendMessage,
        ),
      ],
    );
  }


  // ChatMessage => Map<String, dynamic>
  Map<String, dynamic> _toFirestore(
      ChatMessage msg,
      SetOptions? options,
      ) {
    return {
      'msg': msg.msg,
      'data_msg': msg.data_msg!.toIso8601String(),
      'user_id': msg.user_id,
      'user_nome': msg.user_nome,
      'id_from': msg.id_from,
      'id_doc': msg.id_doc,
      'from': "motoboy",
    };
  }

  // Map<String, dynamic> => ChatMessage
  ChatMessage _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      SnapshotOptions? options,
      ) {
    return ChatMessage(
      id: doc.id,
      msg: doc['msg'],
      data_msg: DateTime.parse(doc['data_msg']),
      user_id: doc['user_id'],
      user_nome: doc['user_nome'],
      id_from: '',
    );
  }
}