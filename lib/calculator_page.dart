import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'calculation.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '0';
  bool resetNext = false;
  bool resetExep = false;
  String rememberance = "";
  Color aGri = const Color.fromRGBO(165, 165, 165, 1);
  Color kGri = const Color.fromRGBO(65, 60, 56, 1);
  Color sari = const Color.fromRGBO(241, 151, 49, 1);
  void _buttonPressed(String buttonText) {
    setState(() {
      if (isOperator(buttonText)) {
        resetExep = false;
        if (endsWithOperator(_input)) {
          if (hasOtherOperator(_input)) {
            if (kDebugMode) {
              print("How the fuck?");
            }
            throw (Error);
          } else {
            _input = _input.substring(0, _input.length - 1) + buttonText;
          }
        } else {
          if (hasOtherOperator(_input)) {
            _result = Calculation.calculate(_input);
            _input = _result + buttonText;
            resetNext = true;
          } else {
            _input += buttonText;
            resetNext = true;
          }
        }
      } else if (isNumber(buttonText)) {
        if (resetNext) {
          _input += buttonText;
          _result = buttonText;
          if (resetExep) {
            _input = buttonText;
            resetExep = false;
            rememberance = "";
          }
        } else {
          _input += buttonText;
          if (_result == "0") {
            _result = buttonText;
          } else {
            _result += buttonText;
          }
        }
      } else if (buttonText == "AC") {
        resetNext = true;
        resetExep = false;
        _input = "";
        _result = "0";
        rememberance = "";
      } else if (buttonText == "=") {
        resetNext = true;
        resetExep = true;
        if (_input.isNotEmpty && !hasOtherOperator(_input)) {
          if (rememberance.isNotEmpty) {
            if (endsWithOperator(_input)) {
              _result = Calculation.calculate(
                  _input.substring(0, _input.length - 1) + rememberance);
              rememberance = rememberLastOperation(
                  _input.substring(0, _input.length - 1) + rememberance);
              _input = _result;
            } else {
              _result = Calculation.calculate(_input + rememberance);
              rememberance = rememberLastOperation(_input + rememberance);
              _input = _result;
            }
          }
        } else if (_input.isNotEmpty) {
          if (endsWithOperator(_input)) {
            _result =
                Calculation.calculate(_input.substring(0, _input.length - 1));
            rememberance = rememberLastOperation(
                _input.substring(0, _input.length - 1) + rememberance);
            _input = _result;
          } else if (hasOtherOperator(_input)) {
            _result = Calculation.calculate(_input);
            rememberance = rememberLastOperation(_input + rememberance);
            _input = _result;
          }
        }
      }
    });
  }

  Widget _buildButtonWithColor(String buttonText, Color test) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextButton(
          onPressed: () => _buttonPressed(buttonText),
          style: TextButton.styleFrom(
            backgroundColor: test,
            padding: const EdgeInsets.all(18),
            shape: const CircleBorder(eccentricity: 0),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 38, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildZeroWithColor(String buttonText, Color test) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
        child: TextButton(
          onPressed: () => _buttonPressed(buttonText),
          style: TextButton.styleFrom(
            backgroundColor: test,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(25, 18, 18, 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 38, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //Debug(resetNext: resetNext, resetExep: resetExep, rememberance: rememberance, input: _input),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: Text(
                _result,
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButtonWithColor('AC', aGri),
                  _buildButtonWithColor('±', aGri),
                  _buildButtonWithColor('%', aGri),
                  _buildButtonWithColor('/', sari),
                ],
              ),
              Row(
                children: [
                  _buildButtonWithColor('7', kGri),
                  _buildButtonWithColor('8', kGri),
                  _buildButtonWithColor('9', kGri),
                  _buildButtonWithColor('X', sari),
                ],
              ),
              Row(
                children: [
                  _buildButtonWithColor('4', kGri),
                  _buildButtonWithColor('5', kGri),
                  _buildButtonWithColor('6', kGri),
                  _buildButtonWithColor('-', sari),
                ],
              ),
              Row(
                children: [
                  _buildButtonWithColor('1', kGri),
                  _buildButtonWithColor('2', kGri),
                  _buildButtonWithColor('3', kGri),
                  _buildButtonWithColor('+', sari),
                ],
              ),
              Row(
                children: [
                  _buildZeroWithColor('0', kGri),
                  _buildButtonWithColor(',', kGri),
                  _buildButtonWithColor('=', sari),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Debug extends StatelessWidget {
  const Debug({
    super.key,
    required this.resetNext,
    required this.resetExep,
    required this.rememberance,
    required String input,
  }) : _input = input;

  final bool resetNext;
  final bool resetExep;
  final String rememberance;
  final String _input;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomRight,
        child: Text(
          "$resetNext | $resetExep | $rememberance | $_input",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
