//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:cupertino_stackview/cupertino_stackview_controller.dart';

///See [CupertinoStackViewController].
CupertinoStackViewController cupertinoStackViewController;

final double cupertinoStackViewScaleFraction = 2540.0 / 2688.0;
final double cupertinoStackViewFirstOffsetFraction = 180.0 / 2688.0;
final double cupertinoStackViewSecondOffsetFraction = 33.0 / 2688.0;
final double cupertinoStackViewSecondHeightFraction = 2510.0 / 2688.0;

enum CupertinoStackViewStatus {
  FRONT,
  BACK,
  DISAPPEAR,
}
