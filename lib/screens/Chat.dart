import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/MockData.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.channel);

  final Channel channel;

  @override
  State createState() => new ChatScreenState(channel);
}

class ChatScreenState extends State<ChatScreen>  with TickerProviderStateMixin{

  ChatScreenState(this.channel);

  final Channel channel;

  final TextEditingController _textController = new TextEditingController();

  bool _isComposing = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Message _msg = new Message(localUser, text);
    MessageItem messageItem = new MessageItem(
      message: _msg,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 100),
        vsync: this,
      ),
    );
    setState(() {
      channel.messages.insert(0, _msg);
    });
    messageItem.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(channel.name),
        backgroundColor: Color(0xFF0A3D91),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.open_in_new),
            onPressed: (){
              channels.remove(channel);
              notPartChannels.add(channel);
              ChannelOverview _chnOvrview = getChannelOverviewFrom(channel.name, channelOverviews);
              channelOverviews.remove(_chnOvrview);
              notPartChannelOverviews.add(_chnOvrview);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                Message _msg = channel.messages[index];
                MessageItem _msgItm = new MessageItem(
                  message: _msg,
                  animationController: new AnimationController(
                    duration: new Duration(milliseconds: 100),
                    vsync: this,
                  ),
                );
                _msgItm.animationController.forward();
                return _msgItm;
              },
              itemCount: channel.messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  if (!_isComposing) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  }
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    )
                  : new IconButton(
                      color: Color(0xFF0A3D91),
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
