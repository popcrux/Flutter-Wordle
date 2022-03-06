/*
 * @Author       : Linloir
 * @Date         : 2022-03-05 20:55:53
 * @LastEditTime : 2022-03-06 17:28:40
 * @Description  : Input pannel class
 */

import 'package:flutter/material.dart';
import 'package:wordle/validation_provider.dart';
import './event_bus.dart';

class InputPannelWidget extends StatefulWidget {
  const InputPannelWidget({Key? key}) : super(key: key);

  @override
  State<InputPannelWidget> createState() => _InputPannelWidgetState();
}

class _InputPannelWidgetState extends State<InputPannelWidget> {
  final _keyState = <String, int>{};
  final List<List<String>> _keyPos = List<List<String>>.unmodifiable([
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
  ]);
  Map<String, int> _cache = {};

  void _onLetterValidation(dynamic args) {
    _cache = args as Map<String, int>;
  }

  void _onAnimationStops(dynamic args) {
    _cache.forEach((key, value) {
      setState(() {
        _keyState[key] = value;
      });
    });
  }

  void _onNewGame(dynamic args) {
    setState(() {
      var aCode = 'A'.codeUnitAt(0);
      var zCode = 'Z'.codeUnitAt(0);
      var alphabet = List<String>.generate(
        zCode - aCode + 1,
        (index) => String.fromCharCode(aCode + index),
      );
      for(String c in alphabet) {
        _keyState[c] ??= 0;
        _keyState[c] = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var aCode = 'A'.codeUnitAt(0);
    var zCode = 'Z'.codeUnitAt(0);
    var alphabet = List<String>.generate(
      zCode - aCode + 1,
      (index) => String.fromCharCode(aCode + index),
    );
    for(String c in alphabet) {
      _keyState[c] ??= 0;
      _keyState[c] = 0;
    }
    mainBus.onBus(event: "Validation", onEvent: _onLetterValidation);
    mainBus.onBus(event: "AnimationStops", onEvent: _onAnimationStops);
    mainBus.onBus(event: "NewGame", onEvent: _onNewGame);
  }

  @override
  void dispose() {
    mainBus.offBus(event: "Validation", callBack: _onLetterValidation);
    mainBus.offBus(event: "AnimationStops", callBack: _onAnimationStops);
    mainBus.offBus(event: "NewGame", callBack: _onNewGame);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            for(int i = 0; i < 10; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: SizedBox(
                  width: 25.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                      backgroundColor: MaterialStateProperty.all<Color?>(
                        _keyState[_keyPos[0][i]]! == 0 ? Colors.grey[400] :
                        _keyState[_keyPos[0][i]]! == 1 ? Colors.green[600] :
                        _keyState[_keyPos[0][i]]! == 2 ? Colors.orange[600] :
                        Colors.grey[850]
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _keyPos[0][i],
                        style: TextStyle (
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _keyState[_keyPos[0][i]]! == 0 ? Colors.grey[850] : Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      InputNotification(type: InputType.singleCharacter, msg: _keyPos[0][i]).dispatch(context);
                    },
                  )
                ),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            for(int i = 0; i < 9; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: SizedBox(
                  width: 25.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                      backgroundColor: MaterialStateProperty.all<Color?>(
                        _keyState[_keyPos[1][i]]! == 0 ? Colors.grey[400] :
                        _keyState[_keyPos[1][i]]! == 1 ? Colors.green[600] :
                        _keyState[_keyPos[1][i]]! == 2 ? Colors.orange[600] :
                        Colors.grey[850]
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _keyPos[1][i],
                        style: TextStyle (
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _keyState[_keyPos[1][i]]! == 0 ? Colors.grey[850] : Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      InputNotification(type: InputType.singleCharacter, msg: _keyPos[1][i]).dispatch(context);
                    },
                  )
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: SizedBox(
                width: 50,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[700]),
                  ),
                  child: const Icon(
                    Icons.backspace_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    const InputNotification(type: InputType.backSpace, msg: "").dispatch(context);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            for(int i = 0; i < 7; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: SizedBox(
                  width: 25.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                      backgroundColor: MaterialStateProperty.all<Color?>(
                        _keyState[_keyPos[2][i]]! == 0 ? Colors.grey[400] :
                        _keyState[_keyPos[2][i]]! == 1 ? Colors.green[600] :
                        _keyState[_keyPos[2][i]]! == 2 ? Colors.orange[600] :
                        Colors.grey[850]
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _keyPos[2][i],
                        style: TextStyle (
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _keyState[_keyPos[2][i]]! == 0 ? Colors.grey[850] : Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      InputNotification(type: InputType.singleCharacter, msg: _keyPos[2][i]).dispatch(context);
                    },
                  )
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: SizedBox(
                width: 70,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    backgroundColor: MaterialStateProperty.all<Color?>(Colors.green[600]),
                  ),
                  child: const Icon(
                    Icons.keyboard_return_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    const InputNotification(type: InputType.inputConfirmation, msg: "").dispatch(context);
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}