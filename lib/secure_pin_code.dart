library secure_pin_code;

import 'dart:math';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter/material.dart';

typedef OnCallback = void Function(bool result);

class SecurePinCode extends StatefulWidget {
  const SecurePinCode({
    super.key,
    required this.logo,
    required this.title,
    required this.successMessage,
    required this.errorMessage,
    required this.pin,
    required this.onCallback,
    this.messageSize = 16,
    this.bulletSize = 16,
    this.numberSize = 22,
  });

  final Widget logo;
  final String title;
  final String successMessage;
  final String errorMessage;
  final List<int> pin;
  final OnCallback onCallback;
  final double? messageSize;
  final double? bulletSize;
  final double? numberSize;

  @override
  State<SecurePinCode> createState() => _SecurePinCodeState();
}

class _SecurePinCodeState extends State<SecurePinCode> {
  @override
  void initState() {
    super.initState();
    random = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    keyinPin = [];
  }

  final shakeKey = GlobalKey<ShakeWidgetState>();
  List<int> random = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> keyinPin = [];
  bool? isSuccess;

  @override
  Widget build(BuildContext context) {
    if (random.isEmpty) {
      setState(() {
        random = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure pin code'),
      ),
      body: ShakeMe(
        key: shakeKey,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.logo,
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: isSuccess == null
                  ? Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.messageSize,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : isSuccess!
                  ? Text(
                widget.successMessage,
                style: TextStyle(
                  fontSize: widget.messageSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
                  : Text(
                widget.errorMessage,
                style: TextStyle(
                  fontSize: widget.messageSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            buildBullets(widget.pin),
            Padding(
              padding: const EdgeInsets.only(left: 56.0, right: 56, bottom: 56),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  12,
                      (index) {
                    if (index == 9) {
                      return const SizedBox.shrink();
                    } else if (index == 11) {
                      return IconButton(
                        icon: const Icon(Icons.backspace),
                        onPressed: keyinPin.isEmpty
                            ? null
                            : () {
                          setState(() {
                            keyinPin.removeLast();
                          });
                        },
                      );
                    } else {
                      Random rnd = Random();
                      int selected = 0;
                      if (random.isNotEmpty) {
                        selected = rnd.nextInt(random.length);
                      } else {
                        setState(() {
                          random = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
                        });
                      }
                      String choose = random[selected].toString();
                      random.removeAt(selected);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              keyinPin.add(int.parse(choose));
                              if (widget.pin.length == keyinPin.length) {
                                bool isMatching = true;
                                for (int i = 0; i < widget.pin.length; i++) {
                                  if (widget.pin[i] != keyinPin[i]) {
                                    isMatching = false;
                                    continue;
                                  }
                                }
                                if (isMatching) {
                                  keyinPin.clear();
                                  isSuccess = true;
                                  widget.onCallback(true);
                                } else {
                                  widget.onCallback(false);
                                  isSuccess = false;
                                  keyinPin.clear();
                                  shakeKey.currentState?.shake();
                                }
                              } else {
                                isSuccess = null;
                                widget.onCallback(false);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: Text(
                            choose,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.numberSize,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBullets(List<int> bullets) {
    List<Widget> list = <Widget>[];
    for (var i = 1; i <= bullets.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: widget.bulletSize,
            height: widget.bulletSize,
            decoration: BoxDecoration(
              color: keyinPin.length >= i ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }
}
