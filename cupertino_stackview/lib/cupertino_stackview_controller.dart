//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/cupertino.dart';

import 'package:cupertino_stackview/cupertino_stackview.dart';
import 'package:cupertino_stackview/misc.dart';

///The class that is responsible of all Cupertino StackView related logic.
class CupertinoStackViewController {
  ///The [GlobalKey] used for the [navigatorKey] property of your [CupertinoApp] or [MaterialApp].
  final GlobalKey<NavigatorState> _navigatorState;

  ///The map that is to be used when navigating between the [CupertinoStackView]s in the Cupertino StackView system.
  final Map<String, Function(BuildContext context, dynamic parameters)> _builders;

  ///The duration that is to be used for [CupertinoStackView] animations. The default value corresponds the default Flutter value..
  final Duration duration;

  ///See [initialise].
  double height;

  ///See [initialise].
  double width;

  final List<_ListPair> _map = List<_ListPair>();

  String get currentNavigation => _map.first._navigation;

  CupertinoStackViewController(
    this._navigatorState,
    this._builders, {
    this.duration: const Duration(milliseconds: 250),
  });

  bool _isMapped(String navigation) {
    return _map.indexWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation) > -1;
  }

  void introduce(String navigation, CupertinoStackViewState cupertinoStackViewState) {
    if (_isMapped(navigation)) {
      _map.firstWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation)._cupertinoStackViewState = cupertinoStackViewState;
    } else {
      _map.insert(0, _ListPair(navigation, cupertinoStackViewState));
    }
  }

  ///[CupertinoStackViewController] has to be initialised as soon as the application starts.
  ///Use this method with the [MediaQuery.of(context).size.height] and [MediaQuery.of(context).size.width] values.
  void initialise(double height, double width) {
    this.height = height;
    this.width = width;
  }

  void _organise() {
    int _index = 0;
    for (int i = 0; i < _map.length; i++) {
      if (_map[i]._cupertinoStackViewState != null) {
        _map[i]._cupertinoStackViewState.move(_index == 0 ? CupertinoStackViewStatus.FRONT : _index == 1 ? CupertinoStackViewStatus.BACK : CupertinoStackViewStatus.DISAPPEAR);
      }
      _index++;
    }
  }

  ///Use this method to go back to the primary [CupertinoStackView] in the Cupertino StackView system.
  Future backToPrimary() async {
    while (_map.length != 1) {
      _navigatorState.currentState.pop();
      _map.removeAt(0);
      _organise();
      await Future.delayed(duration);
    }
  }

  ///Use this method to go back one [CupertinoStackView] in the Cupertino StackView system.
  Future back(BuildContext context, dynamic parameters) async {
    await navigate(_map[1]._navigation, context, parameters);
  }

  ///Use this method to go to a [CupertinoStackView] in the Cupertino StackView system.
  Future navigate(String targetNavigation, BuildContext context, dynamic parameters) async {
    if (_isMapped(targetNavigation)) {
      while (_map.first._navigation != targetNavigation) {
        _navigatorState.currentState.pop();
        _map.removeAt(0);
        _organise();
        await Future.delayed(duration);
      }
    } else {
      _map.insert(0, _ListPair(targetNavigation, null));
      _organise();
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return _builders[targetNavigation](context, parameters);
          });
    }
  }
}

class _ListPair {
  final String _navigation;
  CupertinoStackViewState _cupertinoStackViewState;

  _ListPair(
    this._navigation,
    this._cupertinoStackViewState,
  );
}
