import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/redux/model/app_state.dart';

class PersonDelegateData {
  const PersonDelegateData(
      {this.name,
      this.mId,
      this.message = 'Lorem ipsum dolor sit...',
      this.time = '2 sec',
      this.profileImage = 'assets/profile.jpg',
      this.isOnline = false,
      this.isMessage = false,
      this.isUnread = false,
      this.isTime = false});
  final String name;
  final String mId;
  final String message;
  final String time;
  final String profileImage;
  final bool isOnline;
  final bool isMessage;
  final bool isUnread;
  final bool isTime;
}

class PersonDelegate extends StatefulWidget {
  final PersonDelegateData data;
  final Function onPressed;
  final bool isSelectable;

  const PersonDelegate({this.data, this.onPressed, this.isSelectable = false});

  @override
  _PersonDelegateState createState() => _PersonDelegateState();
}

class _PersonDelegateState extends State<PersonDelegate>
    with SingleTickerProviderStateMixin {
  final double delegateHeight = personDelegateHeight;

  Animation<Decoration> boxShadow;
  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    boxShadow = DecorationTween(
      begin: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0),
            blurRadius: 0.0,
            spreadRadius: appBarHeight / 3,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(appBarHeight / 3)),
        color: Colors.white.withOpacity(0),
      ),
      end: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(appBarHeight / 3)),
        color: Colors.white,
      ),
    ).animate(_curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) widget.onPressed();
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        height: delegateHeight,
        decoration: boxShadow.value,
        child: Row(
          children: <Widget>[
            Container(
              width: delegateHeight,
              height: delegateHeight,
              child: Stack(
                alignment: Alignment(-1.0, 0.0),
                children: <Widget>[
                  Center(
                    child: Visibility(
                      visible: widget.data.isUnread,
                      child: Container(
                        height: delegateHeight * 0.92,
                        width: delegateHeight * 0.92,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00FFFF),
                              Color(0xFF29ABE2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              delegateHeight * 0.92 * 0.33),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: widget.data.isUnread
                          ? delegateHeight * 0.85
                          : delegateHeight * 0.8,
                      width: widget.data.isUnread
                          ? delegateHeight * 0.85
                          : delegateHeight * 0.8,
                      decoration: BoxDecoration(
                        border: widget.data.isUnread
                            ? Border.all(
                                color: Colors.white,
                                width: delegateHeight * 0.03)
                            : null,
                        color: Colors.lightBlueAccent,
                        borderRadius:
                            BorderRadius.circular(delegateHeight * 0.8 * 0.33),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(widget.data.profileImage),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data.isOnline,
                    child: Positioned(
                      bottom: delegateHeight * 0.73,
                      left: delegateHeight * 0.73,
                      child: Container(
                        height: delegateHeight * 0.25,
                        width: delegateHeight * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: delegateHeight * 0.03),
                          color: Colors.lightGreenAccent,
                          borderRadius:
                              BorderRadius.circular(delegateHeight * 0.3 * 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.data.name,
                      style: widget.data.isMessage
                          ? Theme.of(context).textTheme.body2
                          : Theme.of(context).textTheme.body1,
                    ),
                    Visibility(
                      visible: widget.data.isMessage,
                      child: Text(
                        widget.data.message,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.data.isTime,
              child: Text(widget.data.time,
                  style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelectable) {
      return StoreConnector<AppState, Identity>(
        converter: (store) => store.state.selectedId,
        builder: (context, id) {
          if (id.mId == widget.data.mId)
            _animationController.value = 1;
          else
            _animationController.value = 0;

          return _build(context);
        },
      );
    } else
      return _build(context);
  }
}
