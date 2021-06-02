import 'package:chat_app_test/models/messages_response.dart';
import 'package:chat_app_test/services/auth_service.dart';
import 'package:chat_app_test/services/chat_service.dart';
import 'package:chat_app_test/services/socket_service.dart';
import 'package:chat_app_test/widgets/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  List<ChatWidget> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService!.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService!.userPara!.uid!);
    super.initState();
  }

  void _cargarHistorial(String userID) async {
    List<Message> messages = await chatService!.getMessages(userID);
    final history = messages.map((m) => ChatWidget(
          text: m.message,
          uid: m.de!,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatWidget message = ChatWidget(
      text: payload['message'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userPara = chatService!.userPara!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(userPara.name!.substring(0, 2),
                    style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text(
                userPara.name!,
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i],
                ),
              ),
              Divider(height: 1),
              Container(
                color: Colors.white,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (text) {
                  setState(() {
                    if (text.trim().length > 0) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: CupertinoButton(
                child: Text('Send'),
                onPressed: _isWriting
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatWidget(
      uid: authService!.user!.uid!,
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });

    socketService!.socket.emit('mensaje-personal', {
      'de': authService!.user!.uid,
      'para': chatService!.userPara!.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatWidget message in _messages) {
      message.animationController.dispose();
    }
    socketService!.socket.off('mensaje-personal');
    super.dispose();
  }
}
