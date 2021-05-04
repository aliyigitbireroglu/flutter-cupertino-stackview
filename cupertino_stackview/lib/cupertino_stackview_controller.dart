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
import 'package:flutter/material.dart';

///The class that is responsible of all Cupertino StackView related logic.
class CupertinoStackViewController {
  ///The [GlobalKey] used for the [navigatorKey] property of your [CupertinoApp] or [MaterialApp].
  final GlobalKey<NavigatorState> _navigatorState;

  ///The map that is to be used when navigating between the [CupertinoStackView]s in the Cupertino StackView system.
  final Map<String, Function(BuildContext context, dynamic parameters)> _builders;

  ///The duration that is to be used for [CupertinoStackView] animations. The default value corresponds the default Flutter value..
  final Duration duration;

  ///See [initialise].
  late double height;

  ///See [initialise].
  double? width;

  final List<_ListPair> _map = [];
  final List<_ListPair> _siblingMap = [];
  final Map<String, BuildContext?> _contexts = Map<String, BuildContext?>();

  String get currentNavigation => _map.first._navigation;
  BuildContext? get currentContext => _contexts[currentNavigation];

  ///Callback for when any [CupertinoStackView] moves.
  final Function(String, CupertinoStackViewStatus)? onMoved;

  ///Callback for when any [CupertinoStackView] is dismissed.
  final Function(String?)? onDismissed;

  CupertinoStackViewController(
    this._navigatorState,
    this._builders, {
    this.duration: const Duration(milliseconds: 250),
    this.onMoved,
    this.onDismissed,
  });

  bool _isMapped(String navigation) {
    return _map.indexWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation) > -1;
  }

  bool _isSiblingMapped(String navigation) {
    return _siblingMap.indexWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation) > -1;
  }

  bool _hasSibling(String navigation) {
    return _siblingMap.indexWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation) > -1;
  }

  void introduce(String navigation, CupertinoStackViewState cupertinoStackViewState) {
    if (_isMapped(navigation)) {
      _map.firstWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation)._cupertinoStackViewState = cupertinoStackViewState;
    } else {
      _map.insert(0, _ListPair(navigation, cupertinoStackViewState));
    }
  }

  void introduceAsSibling(String navigation, CupertinoStackViewState cupertinoStackViewState) {
    if (_isSiblingMapped(navigation)) {
      _siblingMap.firstWhere((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation)._cupertinoStackViewState = cupertinoStackViewState;
    } else {
      _siblingMap.insert(0, _ListPair(navigation, cupertinoStackViewState));
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
        _map[i]._cupertinoStackViewState!.move(_index == 0
            ? CupertinoStackViewStatus.FRONT
            : _index == 1
                ? CupertinoStackViewStatus.BACK
                : CupertinoStackViewStatus.DISAPPEAR);
        if (onMoved != null) {
          onMoved!(
              _map[i]._navigation,
              _index == 0
                  ? CupertinoStackViewStatus.FRONT
                  : _index == 1
                      ? CupertinoStackViewStatus.BACK
                      : CupertinoStackViewStatus.DISAPPEAR);
        }
        if (_hasSibling(_map[i]._navigation)) {
          _organiseSiblings(_map[i]._navigation, _index);
        }
      }
      _index++;
    }
  }

  void _organiseSiblings(String navigation, int index) {
    List<_ListPair> _siblings = _siblingMap.where((_ListPair navigationStackStatePair) => navigationStackStatePair._navigation == navigation).toList();
    for (int i = 0; i < _siblings.length; i++) {
      if (_siblings[i]._cupertinoStackViewState != null) {
        _siblings[i]._cupertinoStackViewState!.move(index == 0
            ? CupertinoStackViewStatus.FRONT
            : index == 1
                ? CupertinoStackViewStatus.BACK
                : CupertinoStackViewStatus.DISAPPEAR);
        if (onMoved != null) {
          onMoved!(
              _siblings[i]._navigation,
              index == 0
                  ? CupertinoStackViewStatus.FRONT
                  : index == 1
                      ? CupertinoStackViewStatus.BACK
                      : CupertinoStackViewStatus.DISAPPEAR);
        }
      }
    }
  }

  ///Use this method to go back to the primary [CupertinoStackView] in the Cupertino StackView system.
  Future backToPrimary() async {
    while (_map.length != 1) {
      _navigatorState.currentState!.pop();
      _contexts.remove(currentNavigation);
      _map.removeAt(0);
      _organise();
      await Future.delayed(duration);
    }
  }

  ///Use this method to go back one [CupertinoStackView] in the Cupertino StackView system.
  Future back({String? navigation, bool isDismissed: false}) async {
    await navigate(_map[1]._navigation, null, null);
    if (isDismissed && onDismissed != null) {
      onDismissed!(navigation);
    }
  }

  ///Use this method to go to a [CupertinoStackView] in the Cupertino StackView system.
  Future navigate(String targetNavigation, BuildContext? context, dynamic parameters) async {
    if (_isMapped(targetNavigation)) {
      while (_map.first._navigation != targetNavigation) {
        _navigatorState.currentState!.pop();
        _contexts.remove(currentNavigation);
        _map.removeAt(0);
        _organise();
        await Future.delayed(duration);
      }
    } else {
      _map.insert(0, _ListPair(targetNavigation, null));
      _contexts[targetNavigation] = context;
      _organise();
      showCupertinoModalPopup(
          context: context!,
          builder: (BuildContext context) {
            return Stack(
              children: [
                Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.transparent,
                ),
                _builders[targetNavigation]!(context, parameters),
              ],
            );
          });
    }
  }
}

class _ListPair {
  final String _navigation;
  CupertinoStackViewState? _cupertinoStackViewState;

  _ListPair(
    this._navigation,
    this._cupertinoStackViewState,
  );
}
