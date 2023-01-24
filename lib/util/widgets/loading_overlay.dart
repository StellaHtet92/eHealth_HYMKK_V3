
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import '../values/colors.dart';
import '../values/values.dart';

class LoadingOverlay extends ModalRoute<void> {
  final String message;

  LoadingOverlay(this.message);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _Stateful(message),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class _Stateful extends StatefulWidget{
  final String message;

  const _Stateful(this.message);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful>{
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
   return Center(
     child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         const SizedBox(
           width: 80,
           height: 80,
           child:/* Image.asset(
             "images/heart_beat_loading.gif",
             height: 125.0,
             width: 125.0,
           ),*/SpinKitFadingCube(
             color: secondaryAccentColor,
             size: 20.0,
           ),
         ),
         const SizedBox(height: m3),
         Text(
           widget.message,
           style: const TextStyle(color: Colors.white, fontSize: fontSubTitle),
         ),
         Text(formatTime(_stopwatch.elapsedMilliseconds),
           style: const TextStyle(color: Colors.white, fontSize: fontSubTitle)),
       ],
     ),
   );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}
