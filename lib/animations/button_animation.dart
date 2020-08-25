import 'package:faem_delivery/deliveryJson/get_free_order_detail.dart';
import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/deliveryJson/update_status.dart';
import 'package:flutter/material.dart';
import '../order_screen.dart';

class ButtonAnimation extends StatefulWidget {
  final Color primaryColor;
  final Color darkPrimaryColor;
  final orderFunction;

  ButtonAnimation({Key key, this.primaryColor, this.darkPrimaryColor, this.orderFunction}) : super(key: key);

  @override
  _ButtonAnimationState createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _scaleAnimationController;
  AnimationController _fadeAnimationController;

  Animation<double> _animation;
  Animation<double> _scaleAnimation;
  Animation<double> _fadeAnimation;

  var statusCode;

  double buttonWidth = 370.0;
  double scale = 1.0;
  bool animationComplete = false;
  double barColorOpacity = .6;
  bool animationStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: responseTime - 5));

    _scaleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _fadeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _fadeAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(_fadeAnimationController);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_scaleAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleAnimationController.reverse();
          //_fadeAnimationController.forward();
          _animationController.forward();
        }
      });

    _animation = Tween<double>(begin: 0.0, end: buttonWidth)
        .animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                animationComplete = true;
                barColorOpacity = .6;
              });
            }
          });
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
            animation: _scaleAnimationController,
            builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: InkWell(
                    onTap: () async {
                      if (deliverStatus == "offer_offered") {
                        statusCode = await getStatusOrder('offer_accepted', orderDetail['offer']['uuid'], arrivalTime, null,);
                        await deliverInitData();
                      } else if (deliverStatus == "offer_accepted") {
                        setState(() {
                          clientVisibility = true;
                        });
                        statusCode = await getStatusOrder('order_start', orderDetail['offer']['uuid'], null, null);
                        await deliverInitData();
                      } else if(deliverStatus == "order_start") {
                        setState(() {
                          widget.orderFunction('ПРИБЫЛ В РЕСТОРАН');
                        });
                        Navigator.pop(context);
                      }
                      setState(() {
                        widget.orderFunction('ПРИБЫЛ В РЕСТОРАН');
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                          color: widget.primaryColor,
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                                child: animationComplete == false
                                    ? Text(
                                        "УКАЗАТЬ ВРЕМЯ ПРИБЫТИЯ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    : Text(
                                        "УКАЗАТЬ ВРЕМЯ ПРИБЫТИЯ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Positioned(
            right: 0,
            top: 0,
            width: _animation.value,
            height: 60,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: barColorOpacity,
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
