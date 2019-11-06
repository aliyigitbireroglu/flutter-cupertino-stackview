# example

Example Project for Example Project for cupertino_stackview.


# cupertino_stackview

[comment]: <> (Badges)
<a href="https://www.cosmossoftware.coffee">
   <img alt="Cosmos Software" src="https://img.shields.io/badge/Cosmos%20Software-Love%20Code-red" />
</a>
<a href="https://www.cosmossoftware.coffee">
   <img alt="Cosmos Software" src="https://img.shields.io/badge/Developer's-Choice-yellow" />
</a>

[![Pub](https://img.shields.io/pub/v/cupertino_stackview?color=g)](https://pub.dev/packages/cupertino_stackview)
[![License](https://img.shields.io/github/license/aliyigitbireroglu/flutter-cupertino-stackview?color=blue)](https://github.com/aliyigitbireroglu/flutter-cupertino-stackview/blob/master/LICENSE)

[comment]: <> (Introduction)
A very easy-to-use navigation tool/widget for having iOS 13 style stacks.

**It is highly recommended to read the documentation and run the example project on a real device to fully understand and inspect the full range of capabilities.**

[comment]: <> (ToC)
[Media](#media) | [Description](#description) | [Installation](#installation) | [How-to-Use](#howtouse)


[comment]: <> (Media)
<a name="media"></a>
## Media

Watch on **Youtube**:

[v1.0.0](https://youtu.be/XvwOScBMvEE)
<br><br>
<img src="https://www.cosmossoftware.coffee/Common/Portfolio/GIFs/FlutterCupertinoStackView.gif" height="450" max-height="450"/>
<br><br>


[comment]: <> (Description)
<a name="description"></a>
## Description
The "StackView" system, as I like to call it because I don't know the real name, is now the default navigation system for iOS 13. As a fan of this, I decided to implement a very easy-to-use version of it for Flutter as well.


[comment]: <> (How-to-Use)
<a name="howtouse"></a>
## How-to-Use
First, instantiate the cupertinoStackViewController that is provided by "misc.dart" with the required parameters:

```
cupertinoStackViewController = CupertinoStackViewController(
    navigatorState,
    {
      "Page I": (BuildContext context, dynamic parameters) {
        return PageI();
      },
      "Page II": (BuildContext context, dynamic parameters) {
        return PageII();
      },
      "Page III": (BuildContext context, dynamic parameters) {
        return PageIII();
      },
      "Page IV": (BuildContext context, dynamic parameters) {
        return PageIV();
      },
      ...,
    },
);
```

Then create a CupertinoStackView widget as shown in the example:

```
CupertinoStackView(
  true,             //_isPrimary 
  "Page I",         //_navigation
  Scaffold(...),    //_child
  Colors.black,     //_backgroundColor 
 {Key key,
  radius    : Radius.circular(10.0)})
```

**Further Explanations:**

*For a complete set of descriptions for all parameters and methods, see the [documentation](https://pub.dev/documentation/cupertino_stackview/latest/).*

* The [cupertinoStackViewController] from 'misc.dart' has to be initialised as soon as the application starts via the [void initialise(double height, double width)] method. Use this method with the [MediaQuery.of(context).size.height] and [MediaQuery.of(context).size.width] values.
* Use [CupertinoStackViewController]'s [Future back(BuildContext context, dynamic parameters) async] and [Future navigate(String targetNavigation, BuildContext context, dynamic parameters) async] methods for the corresponding actions. Do not call [Navigator] methods directly.


[comment]: <> (Notes)
## Notes
Any help, suggestion or criticism is appreciated! 

Cheers.

[comment]: <> (CosmosSoftware)
<br><br>
<img align="right" src="https://www.cosmossoftware.coffee/Common/Images/CosmosSoftwareIconTransparent.png" width="150" height="150"/>
<br><br>

