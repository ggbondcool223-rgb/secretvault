class NumberUtils {

  static String toChineseUppercase(String numberStr) {
    try {

      numberStr = numberStr.replaceAll(',', '').replaceAll(' ', '');

      final number = double.parse(numberStr);


      if (number < 0) {
        return 'Negative ${toChineseUppercase(number.abs().toString())}';
      }


      if (number == 0) {
        return 'Zero';
      }


      final parts = numberStr.split('.');
      final integerPart = int.parse(parts[0]);
      final decimalPart = parts.length > 1 ? parts[1] : '';

      final result = StringBuffer();


      if (integerPart > 0) {
        result.write(_convertIntegerPart(integerPart));
      }


      if (decimalPart.isNotEmpty) {
        final jiao = decimalPart.isNotEmpty ? int.parse(decimalPart[0]) : 0;
        final fen = decimalPart.length >= 2 ? int.parse(decimalPart[1]) : 0;

        if (jiao > 0) {
          if (result.isNotEmpty) result.write(' ');
          result.write(_digitToChinese(jiao));
          result.write(' Jiao');
        }

        if (fen > 0) {
          if (result.isNotEmpty) result.write(' ');
          result.write(_digitToChinese(fen));
          result.write(' Fen');
        }
      }

      return result.toString().trim();
    } catch (e) {
      return numberStr;
    }
  }

  static String _convertIntegerPart(int number) {
    if (number == 0) return '';
    if (number < 0) return '';

    final digits = [
      'Zero',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
    ];
    final units = ['', 'Ten', 'Hundred', 'Thousand'];

    final result = StringBuffer();
    final numStr = number.toString();
    final length = numStr.length;


    for (int i = 0; i < length; i++) {
      final digit = int.parse(numStr[i]);
      final position = length - i - 1;

      if (digit != 0) {
        if (result.isNotEmpty) result.write(' ');
        result.write(digits[digit]);

        if (position > 0) {
          final unitIndex = position % 4;
          if (unitIndex > 0) {
            result.write(' ${units[unitIndex]}');
          }
        }
      }
    }

    return result.toString();
  }

  static String _digitToChinese(int digit) {
    const digits = [
      'Zero',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
    ];
    return digit >= 0 && digit <= 9 ? digits[digit] : '';
  }
}
