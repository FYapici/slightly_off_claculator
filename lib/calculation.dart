import 'dart:math';

bool isNumber(String s) {
  return double.tryParse(s) != null;
}

bool isOperator(String s) {
  return s == '+' || s == '-' || s == 'X' || s == '/';
}

bool hasOtherOperator(String a) {
  for (var i = 0; i < a.length - 1; i++) {
    if (isOperator(a[i])) return true;
  }
  return false;
}

bool endsWithOperator(String a) {
  if (a.isEmpty) {
    return false;
  }
  return isOperator(a[a.length - 1]);
}

List<String> divide(String a) {
  String firstNumber = "";
  String middleOperation = "";
  String lastNumber = "";
  var i = 0;
  do {
    firstNumber += a[i];
    i++;
  } while (!isOperator(a[i]));
  middleOperation += a[i];
  i++;
  do {
    lastNumber += a[i];
    i++;
  } while (i < a.length && !isOperator(a[i]));
  return [firstNumber, middleOperation, lastNumber];
}

String rememberLastOperation(String a) {
  var returner = divide(a);
  return returner[1] + returner[2];
}

bool isDouble(String a) {
  if (double.parse(a) % 1 == 0) {
    return false;
  }
  return true;
}

List<String> divideDouble(String a) {
  String firstNumber = "";
  String lastNumber = "";
  var i = 0;
  do {
    firstNumber += a[i];
    i++;
  } while (a[i] != ".");
  i++;
  do {
    lastNumber += a[i];
    i++;
  } while (i < a.length && !isOperator(a[i]));

  i = lastNumber.length;
  while (lastNumber[lastNumber.length - 1] == "0") {
    i--;
  }
  return [firstNumber, lastNumber.substring(0, i)];
}

String intExponancialer(String a) {
  return "${a[0]}e^${a.length - 1}";
}

String decimalFloorer(String a, int x) {
  var resulter = "";
  if (x < a.length) {
    if (int.parse(a[x]) >= 5) {
      resulter = a.substring(0, x - 1) + (int.parse(a[x - 1]) + 1).toString();
    } else {
      resulter = a.substring(0, x);
    }
  } else {
    resulter = a;
  }
  return resulter;
}

bool checkNegativeExponancial(String a) {
  for (var i = 0; i < a.length - 1; i++) {
    if (a[i] == "e" && a[i + 1] == "-") {
      return true;
    }
  }
  return false;
}

String properResultString(String a) {
  if (checkNegativeExponancial(a)) {
    return "Error";
  }
  if (isDouble(a)) {
    var temp = divideDouble(a);
    var first = temp[0];
    var last = temp[1];
    if (first.length > 10) {
      return intExponancialer(first);
    } else if (a.length > 12) {
      return "$first.${decimalFloorer(last, 11 - first.length)}";
    } else {
      return a;
    }
  } else {
    if (a.length > 12) {
      return intExponancialer(trueInter(a));
    } else {
      return trueInter(a);
    }
  }
}

String trueInter(String a) {
  return double.parse(a).toInt().toString();
}

String scrambler(String a) {
  var returner = a;
  var rendomNumber = Random().nextInt(9) + 1;
  var rendomIndex = Random().nextInt(returner.length);

  while (returner[rendomIndex] == rendomNumber.toString()) {
    rendomNumber = Random().nextInt(9) + 1;
  }
  returner = returner.substring(0, rendomIndex) +
      rendomNumber.toString() +
      returner.substring(rendomIndex + 1, returner.length);
  return returner;
}

String offProperResultString(String a) {
  if (checkNegativeExponancial(a)) {
    return "42";
  }
  if (isDouble(a)) {
    var temp = divideDouble(a);
    var first = temp[0];
    var last = temp[1];
    if (first.length > 10) {
      return intExponancialer(first) + Random().nextInt(9).toString();
    } else if (a.length > 12) {
      last = decimalFloorer(last, 11 - first.length);
      return "$first.${scrambler(last)}";
    } else {
      return "$first.${scrambler(last)}";
    }
  } else {
    if (a.length > 12) {
      return intExponancialer(trueInter(a)) + Random().nextInt(9).toString();
    } else {
      return scrambler(trueInter(a));
    }
  }
}

class Calculation {
  static String calculate(String input) {
    String result = '';
    try {
      result = eval(input);
    } catch (e) {
      result = 'Error';
    }
    //return properResultString(result);
    return offProperResultString(result);
  }

  static String eval(String expression) {
    var returner = divide(expression);
    var result = applyOp(returner[1], returner[2], returner[0]);
    return result;
  }

  static String applyOp(String op, String b, String a) {
    var x = isDouble(a) ? double.parse(a) : int.parse(a);
    var y = isDouble(b) ? double.parse(b) : int.parse(b);
    switch (op) {
      case '+':
        return (x + y).toString();
      case '-':
        return (x - y).toString();
      case 'X':
        return (x * y).toString();
      case '/':
        if (y == 0) {
          return 'Error';
        }
        return (x / y).toString();
    }
    return '';
  }
}
