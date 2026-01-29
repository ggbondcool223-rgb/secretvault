import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/index.dart';
import 'package:secret_vault/utils/number_utils.dart';
import 'package:secret_vault/utils/sound_service.dart';

class SvCalculatorLogic extends GetxController {
  final displayExpression = ''.obs;
  final displayResult = '0'.obs;
  final showUppercase = false.obs;
  final _isShowingResult = false.obs;

  String _currentNumber = '';
  String _operator = '';
  double? _firstOperand;
  bool _shouldResetDisplay = false;

  final _db = Get.find<DatabaseService>();
  late SoundService _soundService;

  @override
  void onInit() {
    super.onInit();
    _soundService = Get.find<SoundService>();
    _loadDecimalSettings();
  }

  void _loadDecimalSettings() {}

  void onKeyTap(String key) async {
    try {
      if (key == 'C') {
        _clear();
      } else if (key == '←') {
        _backspace();
      } else if (key == '=') {
        await _calculate();
      } else if (['+', '-', '×', '÷'].contains(key)) {
        _handleOperator(key);
      } else if (key == '.' || key == '·') {
        _handleDecimalPoint();
      } else if (key == '+/-') {
        _handleToggleSign();
      } else if (key == '%') {
        _handlePercentage();
      } else {
        _handleNumber(key);
      }

      _playSound();
    } catch (e) {
      errorToast('Calculation error');
    }
  }

  void _clear() {
    _currentNumber = '';
    _operator = '';
    _firstOperand = null;
    _shouldResetDisplay = false;
    _isShowingResult.value = false;
    displayExpression.value = '';
    displayResult.value = '0';
    showUppercase.value = false;

    displayExpression.refresh();
  }

  void _backspace() {
    if (_currentNumber.isNotEmpty) {
      _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
      _isShowingResult.value = false;
      showUppercase.value = false;

      displayExpression.refresh();
    }
  }

  void _handleNumber(String number) {
    if (_shouldResetDisplay) {
      if (_isShowingResult.value) {
        _clear();
      } else {
        _currentNumber = '';
        _shouldResetDisplay = false;
      }
    }

    _currentNumber += number;
    _isShowingResult.value = false;
    showUppercase.value = false;

    displayExpression.refresh();
  }

  void _handleDecimalPoint() {
    if (_shouldResetDisplay) {
      if (_isShowingResult.value) {
        _clear();
        _currentNumber = '0';
      } else {
        _currentNumber = '0';
        _shouldResetDisplay = false;
      }
    }

    if (!_currentNumber.contains('.')) {
      _currentNumber += _currentNumber.isEmpty ? '0.' : '.';
      _isShowingResult.value = false;
      showUppercase.value = false;

      displayExpression.refresh();
    }
  }

  void _handleToggleSign() {
    if (_currentNumber.isEmpty || _currentNumber == '0') return;

    if (_currentNumber.startsWith('-')) {
      _currentNumber = _currentNumber.substring(1);
    } else {
      _currentNumber = '-$_currentNumber';
    }

    _isShowingResult.value = false;
    showUppercase.value = false;

    displayExpression.refresh();
  }

  void _handlePercentage() {
    if (_currentNumber.isEmpty ||
        _currentNumber == '0' ||
        _shouldResetDisplay) {
      return;
    }

    final number = double.tryParse(_currentNumber);
    if (number != null) {
      _currentNumber = (number / 100).toString();
      _isShowingResult.value = false;
      showUppercase.value = false;

      displayExpression.refresh();
    }
  }

  void _handleOperator(String op) {
    if (_currentNumber.isEmpty && _firstOperand == null) return;

    if (_firstOperand != null &&
        _currentNumber.isNotEmpty &&
        _operator.isNotEmpty) {
      _performCalculation();

      _firstOperand = double.tryParse(_currentNumber);
    } else if (_currentNumber.isNotEmpty) {
      _firstOperand = double.tryParse(_currentNumber);
    }

    _operator = op;
    _shouldResetDisplay = true;
    _isShowingResult.value = false;
    showUppercase.value = false;

    displayExpression.refresh();
  }

  Future<void> _calculate() async {
    if (_firstOperand == null || _currentNumber.isEmpty || _operator.isEmpty) {
      return;
    }

    try {
      _isShowingResult.value = true;

      _performCalculation();

      await _saveToHistory();

      _firstOperand = double.tryParse(displayResult.value);
      _operator = '';
      _shouldResetDisplay = true;
    } catch (e) {
      errorToast('Calculation error');
    }
  }

  void _performCalculation() {
    final secondOperand = double.tryParse(_currentNumber);
    if (secondOperand == null) return;

    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          errorToast('Cannot divide by zero');
          _clear();
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
    }

    final expression =
        '${_formatNumber(_firstOperand!)} $_operator ${_formatNumber(secondOperand)}';
    displayExpression.value = expression;

    final formattedResult = _formatResultWithDecimalPlaces(result);
    displayResult.value = formattedResult;

    _currentNumber = formattedResult;
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toString();
  }

  String _formatResultWithDecimalPlaces(double result) {
    final decimalPlaces = UserPreferences.decimalPlaces;

    if (result == result.toInt()) {
      return result.toInt().toString();
    }

    return result.toStringAsFixed(decimalPlaces);
  }

  Future<void> _saveToHistory() async {
    if (displayExpression.value.isEmpty || displayResult.value == '0') {
      return;
    }

    try {
      final history = CalculatorHistory(
        expression: displayExpression.value,
        result: displayResult.value,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _db.insertCalculatorHistory(history);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  void _playSound() async {
    try {
      final soundType = UserPreferences.soundType;

      if (soundType != 'off') {
        HapticFeedback.lightImpact();
      }

      await _soundService.playKeySound();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void onCopyTap() {
    try {
      final textToCopy = showUppercase.value
          ? NumberUtils.toChineseUppercase(displayResult.value)
          : displayResult.value;

      Clipboard.setData(ClipboardData(text: textToCopy));
      successToast('Copied');
    } catch (e) {
      errorToast('Copy failed');
    }
  }

  void onUppercaseTap() {
    if (!_isShowingResult.value ||
        displayResult.value == '0' ||
        displayResult.value.isEmpty) {
      return;
    }

    final resultValue = displayResult.value;
    if (!_isValidNumber(resultValue)) {
      return;
    }

    showUppercase.value = !showUppercase.value;
  }

  bool _isValidNumber(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  bool get canConvertUppercase {
    return _isShowingResult.value &&
        displayResult.value != '0' &&
        displayResult.value.isNotEmpty &&
        _isValidNumber(displayResult.value);
  }

  String get uppercaseResult {
    if (!showUppercase.value) {
      return displayResult.value;
    }

    return NumberUtils.toChineseUppercase(displayResult.value);
  }

  String get currentInput {
    final _ = displayExpression.value;

    if (_isShowingResult.value) {
      return showUppercase.value ? uppercaseResult : displayResult.value;
    } else {
      String input = '';

      if (_firstOperand != null) {
        input = _formatNumber(_firstOperand!);
        if (_operator.isNotEmpty) {
          input += ' $_operator';

          if (!_shouldResetDisplay && _currentNumber.isNotEmpty) {
            input += ' $_currentNumber';
          }
        }
      } else if (_currentNumber.isNotEmpty) {
        input = _currentNumber;
      } else {
        input = '0';
      }

      return input;
    }
  }

  void loadFromHistory(String expression, String result) {
    try {
      _clear();

      displayExpression.value = expression;
      displayResult.value = result;

      _parseExpression(expression, result);

      _isShowingResult.value = true;
    } catch (e) {
      errorToast('Failed to load history');
    }
  }

  void _parseExpression(String expression, String result) {
    try {
      final operators = ['+', '-', '×', '÷'];
      String? foundOperator;

      for (final op in operators) {
        if (expression.contains(' $op ')) {
          foundOperator = op;
          break;
        }
      }

      if (foundOperator != null) {
        _firstOperand = double.tryParse(result);
        _currentNumber = result;
        _operator = '';
        _shouldResetDisplay = true;
      }
    } catch (e) {
      _currentNumber = result;
    }
  }
}
