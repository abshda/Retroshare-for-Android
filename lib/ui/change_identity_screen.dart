import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/common/bottom_bar.dart';
import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/redux/model/identity_state.dart';
import 'package:retroshare/redux/actions/identity_actions.dart';

class ChangeIdentityScreen extends StatefulWidget {
  @override
  _ChangeIdentityScreenState createState() => _ChangeIdentityScreenState();
}

class _ChangeIdentityScreenState extends State<ChangeIdentityScreen> {
  void _undoChangesOnExit(BuildContext context) {
    final store = StoreProvider.of<IdentityState>(context);
    store.dispatch(ChangeSelectedIdentityAction(store.state.currId));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _undoChangesOnExit(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: <Widget>[
              Container(
                height: appBarHeight,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: personDelegateHeight,
                      child: Visibility(
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              size: 25,
                            ),
                            onPressed: () {
                              _undoChangesOnExit(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Change identity',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StoreConnector<IdentityState,
                    Tuple2<List<Identity>, Identity>>(
                  converter: (store) =>
                      Tuple2(store.state.ownIdsList, store.state.selectedId),
                  builder: (context, idsTuple) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: idsTuple.item1.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PersonDelegate(
                          data: PersonDelegateData(
                            name: idsTuple.item1[index].name,
                            mId: idsTuple.item1[index].mId,
                          ),
                          isSelectable: true,
                          onPressed: () {
                            final store =
                                StoreProvider.of<IdentityState>(context);
                            final id = idsTuple.item1[index];
                            store.dispatch(ChangeSelectedIdentityAction(id));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              BottomBar(
                child: Center(
                  child: SizedBox(
                    height: 2 * appBarHeight / 3,
                    child: FlatButton(
                      onPressed: () {
                        final store = StoreProvider.of<IdentityState>(context);
                        final id = store.state.selectedId;
                        store.dispatch(ChangeCurrentIdentityAction(id));
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0 + personDelegateHeight * 0.04),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF00FFFF),
                                Color(0xFF29ABE2),
                              ],
                              begin: Alignment(-1.0, -4.0),
                              end: Alignment(1.0, 4.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Change identity',
                            style: Theme.of(context).textTheme.button,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
