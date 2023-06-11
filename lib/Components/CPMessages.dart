
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Components/CPMessage_bubble.dart';
import 'package:fogaca_app/Model/ChatMessage.dart';
import 'package:fogaca_app/Widget/WIHistoricoCarregando.dart';
import 'package:fogaca_app/Widget/WIPedidoItem.dart';

class Messages extends StatelessWidget {
  var doc;
  var msgvazio;
  var id;
  Messages({
    required this.doc,
    required this.id,
  });


  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;


    return StreamBuilder<List<ChatMessage>>(
      stream:messagesStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('erro');
        }
        print("snapshot:::${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WIHistoricoCarregando();

        }
        print("snapshot:::${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.active) {
          print("snapshot:::${snapshot.requireData.length}");
          if (snapshot.requireData.length>0) {
            final msgs = snapshot.data!;
            return ListView.builder(
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (ctx, i) => MessageBubble(
                key: ValueKey(msgs[i].id),
                message: msgs[i],
                belongsToCurrentUser: id == msgs[i].user_id,
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.chat,color: Colors.white60,size: 50,)
                ],
              ),
            );
          }
        }
        return Container();
      },

    );
  }

  Map<String, dynamic> _toFirestore(
      ChatMessage msg,
      SetOptions? options,
      ) {
    return {
      'msg': msg.msg,
      'data_msg': msg.data_msg!.toIso8601String(),
      'user_id': msg.user_id,
      'user_nome': msg.user_nome,
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
    );
  }

  Stream<List<ChatMessage>> messagesStream() {
    final snapshots =
    FirebaseFirestore.
    instance.
    collection("chats")
        .doc(doc)
        .collection("mensagens")
        .withConverter(
      fromFirestore: _fromFirestore,
      toFirestore: _toFirestore,
    )
        .orderBy('data_msg', descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }
}
