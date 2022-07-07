//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'package:cupertino_stackview/misc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'package:cupertino_stackview/cupertino_stackview_controller.dart';
export 'package:cupertino_stackview/misc.dart';

///The widget that is responsible of all Cupertino StackView related UI.
class CupertinoStackView extends StatefulWidget {
  ///Set this value to true if the [_child] is the first page of the Cupertino StackView system. In theory, there should only be one [CupertinoStackView] with [_isPrimary] set to true.
  final bool isPrimary;

  ///The navigation path that is to be mapped to this [CupertinoStackView] in the Cupertino StackView system. This value has to be unique for each [CupertinoStackView].
  final String navigation;

  ///The widget that is to be displayed by this [CupertinoStackView].
  final Widget child;

  ///The color that is to be shown when this [CupertinoStackView] moves behind the Cupertino StackView system.
  final Color backgroundColor;

  ///The navigation path that is to link this [CupertinoStackView] to another [CupertinoStackView]. Leave null if you don't want a link.
  final String siblingNavigation;

  ///Set this value to false you don't want the [_child] to be dismissible by vertical dragging.
  final bool isDismissible;

  ///The clipping radius that is to be used to clip this [CupertinoStackView] when it moves behind the Cupertino StackView system. The default value corresponds to the default iOS 13 value.
  final Radius radius;

  ///Set this value to true if you don't want this [CupertinoStackView] to be clipped via [radius] while in the front of the Cupertino StackView system.
  final bool ignoreRadiusWhenFront;

  ///Callback for when this [CupertinoStackView] moves.
  final Function(CupertinoStackViewStatus)? onMoved;

  ///Callback for when this [CupertinoStackView] is dismissed.
  final Function? onDismissed;

  const CupertinoStackView({
    required this.isPrimary,
    required this.navigation,
    required this.child,
    required this.backgroundColor,
    Key? key,
    this.siblingNavigation: "",
    this.isDismissible: true,
    this.radius: const Radius.circular(10.0),
    this.ignoreRadiusWhenFront: false,
    this.onMoved,
    this.onDismissed,
  }) : super(key: key);

  @override
  CupertinoStackViewState createState() {
    return CupertinoStackViewState();
  }
}

class CupertinoStackViewState extends State<CupertinoStackView>
    with SingleTickerProviderStateMixin {
  final GlobalKey _dismissible = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _scale;
  late Animation<Offset> _firstOffset;
  late Animation<Offset> _secondOffset;
  CupertinoStackViewStatus? _currentStatus;

  double get _radius => widget.radius.x;
  double get _dynamicRadius =>
      _radius * _animationController.value.clamp(0.0, 1.0);
  Radius get _realRadius => widget.isPrimary || widget.ignoreRadiusWhenFront
      ? Radius.circular(_dynamicRadius)
      : widget.radius;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: cupertinoStackViewController.duration,
    );
    _scale = Tween(
      begin: 1.0,
      end: cupertinoStackViewScaleFraction,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.decelerate,
        ),
      ),
    );
    _firstOffset = Tween<Offset>(
      begin: widget.isPrimary
          ? Offset.zero
          : Offset(
              0.0,
              cupertinoStackViewFirstOffsetFraction *
                  cupertinoStackViewController.height),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.decelerate,
        ),
      ),
    );
    _secondOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
          0.0,
          cupertinoStackViewSecondOffsetFraction *
              cupertinoStackViewController.height),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
    _currentStatus = CupertinoStackViewStatus.FRONT;
    if (widget.siblingNavigation.isEmpty) {
      cupertinoStackViewController.introduce(widget.navigation, this);
    } else {
      cupertinoStackViewController.introduceAsSibling(
          widget.siblingNavigation, this);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void move(CupertinoStackViewStatus targetStatus) {
    switch (_currentStatus) {
      case CupertinoStackViewStatus.FRONT:
        _animationController.value = 0.0;
        break;
      case CupertinoStackViewStatus.BACK:
        _animationController.value = 0.5;
        break;
      case CupertinoStackViewStatus.DISAPPEAR:
        _animationController.value = 1.0;
        break;
    }

    _currentStatus = targetStatus;

    switch (targetStatus) {
      case CupertinoStackViewStatus.FRONT:
        _animationController.animateTo(0.0);
        break;
      case CupertinoStackViewStatus.BACK:
        _animationController.animateTo(0.5);
        break;
      case CupertinoStackViewStatus.DISAPPEAR:
        _animationController.animateTo(1.0);
        break;
    }
    if (widget.onMoved != null) {
      widget.onMoved!(targetStatus);
    }
  }

  Future<bool> _isDismissed(DismissDirection dismissDirection) async {
    cupertinoStackViewController.back(
        navigation: widget.navigation, isDismissed: true);
    if (widget.onDismissed != null) {
      widget.onDismissed!();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.isPrimary
          ? AnimatedBuilder(
              animation: _animationController,
              child: widget.child,
              builder: (BuildContext buildContext, Widget? cachedWidget) {
                return _Clipper(
                  cachedWidget,
                  widget.backgroundColor,
                  _realRadius,
                );
              },
            )
          : widget.isDismissible
              ? Dismissible(
                  key: _dismissible,
                  direction: DismissDirection.down,
                  dismissThresholds: {DismissDirection.down: 0.5},
                  confirmDismiss: _isDismissed,
                  child: _Positioner(
                    widget.ignoreRadiusWhenFront
                        ? AnimatedBuilder(
                            animation: _animationController,
                            child: widget.child,
                            builder: (BuildContext buildContext,
                                Widget? cachedWidget) {
                              return _Clipper(
                                cachedWidget,
                                widget.backgroundColor,
                                _realRadius,
                              );
                            },
                          )
                        : _Clipper(
                            widget.child,
                            widget.backgroundColor,
                            widget.radius,
                          ),
                  ),
                )
              : _Positioner(
                  widget.ignoreRadiusWhenFront
                      ? AnimatedBuilder(
                          animation: _animationController,
                          child: widget.child,
                          builder: (BuildContext buildContext,
                              Widget? cachedWidget) {
                            return _Clipper(
                              cachedWidget,
                              widget.backgroundColor,
                              _realRadius,
                            );
                          },
                        )
                      : _Clipper(
                          widget.child,
                          widget.backgroundColor,
                          widget.radius,
                        ),
                ),
      builder: (BuildContext context, Widget? cachedWidget) {
        return Transform.translate(
          offset: _animationController.value < 0.5
              ? _firstOffset.value
              : _secondOffset.value,
          child: Transform.scale(
            scale: _scale.value,
            alignment: const Alignment(0.0, 1.0),
            child: cachedWidget,
          ),
        );
      },
    );
  }
}

class _Clipper extends StatelessWidget {
  final Widget? _child;
  final Color _backgroundColor;
  final Radius _radius;

  const _Clipper(
    this._child,
    this._backgroundColor,
    this._radius,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: _radius,
        topRight: _radius,
      ),
      child: Container(
        color: _backgroundColor,
        child: _child,
      ),
    );
  }
}

class _Positioner extends StatelessWidget {
  final Widget _child;

  const _Positioner(
    this._child,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0.0,
          left: 0.0,
          width: cupertinoStackViewController.width,
          height: cupertinoStackViewSecondHeightFraction *
              cupertinoStackViewController.height,
          child: _child,
        )
      ],
    );
  }
}
