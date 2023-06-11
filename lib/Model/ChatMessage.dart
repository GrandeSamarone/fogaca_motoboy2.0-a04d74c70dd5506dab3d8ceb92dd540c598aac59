class ChatMessage {
  final String ? id;
  final String ? msg;
  final String? id_doc;
  final String? id_from;
  final DateTime ?data_msg;

  final String? user_id;
  final String ?user_nome;

  const ChatMessage({
    this.id,
    this.msg,
    this.id_from,
    this.id_doc,
    this.data_msg,
    this.user_id,
    this.user_nome,
  });

  ChatMessage.fromJson(Map<String,dynamic> dados)
      :  id= dados["id"],
        msg= dados["msg"],
        id_from= dados["id_from"],
        id_doc= dados["id_doc"],
        data_msg= dados["data_msg"],
        user_id= dados["user_id"],
        user_nome= dados["user_nome"];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'msg': msg,
        'id_from': id_from,
        'id_doc': id_doc,
        'user_id': user_id,
        'user_nome':user_nome,
      };

}