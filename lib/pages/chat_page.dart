import 'package:chat_app_test/widgets/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatWidget> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Column(
            children: [
              CircleAvatar(
                child: Text('Ru', style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text(
                'Russell Pena',
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
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: CupertinoButton(
                child: Text('Enviar'),
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
    print(text);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatWidget(
      uid: '123',
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
  }

  @override
  void dispose() {
    for (ChatWidget message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
