
import 'package:flutter/material.dart';

class AnimationPageRoute extends PageRouteBuilder{
  final Widget child;

  AnimationPageRoute(this.child)
    :super(pageBuilder: (BuildContext context, Animation<double> animation,
       Animation<double> secondaryAnimation){
        return child;
       }, transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,Widget child ){
            return Transform.scale(
              scale: animation.value,
              child: Transform.rotate(
                angle: 9 - 9 * animation.value,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                  ),
              ),
            );
       }    
    );
       
}
