import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/room/messages_tab.dart';
import 'package:retroshare/ui/room/room_friends_tab.dart';

import 'package:retroshare/model/chat.dart';

class RoomScreen extends StatefulWidget {
  final bool isRoom;
  final Chat chat;
  RoomScreen({Key key, this.isRoom = false, this.chat}) : super(key: key);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final bool isOnline = false;

  Animation<Color> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: widget.isRoom ? 2 : 1);

    _iconAnimation =
        ColorTween(begin: Colors.black, end: Colors.lightBlueAccent)
            .animate(_tabController.animation);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            Container(
              height: appBarHeight,
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: personDelegateHeight,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: !widget.isRoom,
                    child: Container(
                      width: appBarHeight,
                      height: appBarHeight,
                      child: Stack(
                        alignment: Alignment(-1.0, 0.0),
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: appBarHeight * 0.70,
                              width: appBarHeight * 0.70,
                              decoration: BoxDecoration(
                                border: null,
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(
                                    appBarHeight * 0.70 * 0.33),
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: widget.chat.interlocutorId == null
                                      ? MemoryImage(base64.decode(''))
                                      : MemoryImage(base64.decode(
                                          widget.chat.interlocutorId.avatar)),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isOnline,
                            child: Positioned(
                              bottom: appBarHeight * 0.63,
                              left: appBarHeight * 0.63,
                              child: Container(
                                height: appBarHeight * 0.25,
                                width: appBarHeight * 0.25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: appBarHeight * 0.03),
                                  color: Colors.lightGreenAccent,
                                  borderRadius: BorderRadius.circular(
                                      appBarHeight * 0.3 * 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.isRoom
                          ? widget.chat.chatName
                          : widget.chat.interlocutorId.name,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  Visibility(
                    visible: widget.isRoom,
                    child: AnimatedBuilder(
                      animation: _tabController.animation,
                      builder: (BuildContext context, Widget widget) {
                        return IconButton(
                          icon: Icon(
                            Icons.people,
                            size: 25,
                          ),
                          color: _iconAnimation.value,
                          onPressed: () {
                            _tabController.animateTo(1 - _tabController.index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    List<Widget>.generate(widget.isRoom ? 2 : 1, (int index) {
                  if (index == 0)
                    return MessagesTab(chat: widget.chat);
                  else
                    return RoomFriendsTab(chat: widget.chat);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
