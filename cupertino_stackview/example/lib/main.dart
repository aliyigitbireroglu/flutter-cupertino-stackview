//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spring_button/spring_button.dart';
import 'package:cupertino_stackview/cupertino_stackview.dart';

GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

List<PageInfo> pageInfos = [
  PageInfo(
    "Stack I",
    "Lorem Ipsum Dolor",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  ),
  PageInfo(
    "Stack II",
    "Sed ut Perspiciatis",
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit,.",
  ),
  PageInfo(
    "Stack III",
    "Adipisci Velit",
    "Sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.",
  ),
  PageInfo(
    "Stack IV",
    "Ut Enim ad Minima",
    "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
  ),
];

void main() {
  cupertinoStackViewController = CupertinoStackViewController(
    navigatorState,
    {
      "Stack I": (BuildContext context, dynamic parameters) {
        return MyPage(
          0,
        );
      },
      "Stack II": (BuildContext context, dynamic parameters) {
        return MyPage(
          1,
        );
      },
      "Stack III": (BuildContext context, dynamic parameters) {
        return MyPage(
          2,
        );
      },
      "Stack IV": (BuildContext context, dynamic parameters) {
        return MyPage(
          3,
        );
      },
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupertino Stack View Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyPage(0),
      navigatorKey: navigatorState,
    );
  }
}

class MyPage extends StatefulWidget {
  final int index;

  MyPage(
    this.index, {
    Key key,
  }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    cupertinoStackViewController.initialise(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return CupertinoStackView(
      widget.index == 0,
      pageInfos[widget.index].navigation,
      Scaffold(
        backgroundColor: const Color(0xFF29292A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B1D1E),
          leading: widget.index == 0
              ? null
              : SpringButton(
                  SpringButtonType.OnlyScale,
                  Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  useCache: true,
                  onTapUp: (_) {
                    cupertinoStackViewController.back(context, null);
                  },
                ),
          title: Text(pageInfos[widget.index].navigation),
        ),
        body: Column(
          children: [
            MyPadding(
              Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(height: 200),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(const Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 50.0,
                          spreadRadius: 2.5,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(const Radius.circular(20)),
                    child: Container(
                      constraints: BoxConstraints.expand(height: 200),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/" + widget.index.toString() + ".jpeg",
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.75),
                            blurRadius: 100.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyPadding(
              RichText(
                text: TextSpan(
                  text: pageInfos[widget.index].title + "\n\n",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: pageInfos[widget.index].text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            if (widget.index != pageInfos.length - 1)
              Expanded(
                child: Align(
                  alignment: Alignment(0.0, 0.75),
                  child: MyPadding(
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        height: 60,
                        width: 175,
                        decoration: const BoxDecoration(
                          color: const Color(0xFF1B1D1E),
                          borderRadius: const BorderRadius.all(const Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "Open Stack",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      useCache: true,
                      onTapUp: (_) {
                        cupertinoStackViewController.navigate(pageInfos[widget.index + 1].navigation, context, null);
                      },
                    ),
                  ),
                ),
              ),
            if (widget.index == pageInfos.length - 1)
              Expanded(
                child: Align(
                  alignment: Alignment(0.0, 0.75),
                  child: MyPadding(
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        height: 60,
                        width: 175,
                        decoration: const BoxDecoration(
                          color: const Color(0xFF1B1D1E),
                          borderRadius: const BorderRadius.all(const Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "Go to Home",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      useCache: true,
                      onTapUp: (_) {
                        cupertinoStackViewController.navigate(pageInfos[0].navigation, context, null);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      Colors.black,
    );
  }
}

class PageInfo {
  final String navigation;
  final String title;
  final String text;

  PageInfo(
    this.navigation,
    this.title,
    this.text,
  );
}

class MyPadding extends StatelessWidget {
  final Widget _child;

  const MyPadding(
    this._child, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: _child,
    );
  }
}
