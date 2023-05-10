import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:secure_pin_code/secure_pin_code.dart';

void main() {
  test('adds one to input values', () {
    final securePinCode = SecurePinCode(
      logo: SizedBox.shrink(),
      title: '',
      successMessage: '',
      errorMessage: '',
      pin: [],
      onCallback: (bool test) {},
    );
    expect(securePinCode.bulletSize, 16);
    expect(securePinCode.numberSize, 22);
  });
}
