import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/ChatMessage.dart';


class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.belongsToCurrentUser,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Colors.grey.withAlpha(80)
                    : Colors.red.withAlpha(80),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: belongsToCurrentUser
                      ? Radius.circular(12)
                      : Radius.circular(0),
                  bottomRight: belongsToCurrentUser
                      ? Radius.circular(0)
                      : Radius.circular(12),
                ),
              ),
              width: 180,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 8,
              ),
              child: belongsToCurrentUser ?
              Column(
                crossAxisAlignment: belongsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.msg!,
                    textAlign:
                    TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Brand Bold",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ):Column(
                crossAxisAlignment: belongsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.user_nome!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message.msg!,
                    textAlign:
                    TextAlign.left,
                    style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Positioned(
        //   top: 0,
        //   left: belongsToCurrentUser ? null : 165,
        //   right: belongsToCurrentUser ? 165 : null,
        //   child: _showUserImage(message.userImageURL),
        // ),
      ],
    );
  }
}
