## Example

```dart
SecurePinCode(
logo: const Icon(
Icons.pin_sharp,
size: 56,
),
title: 'กรุณาใส่รหัสผ่าน',
successMessage: 'รหัสผ่านถูกต้อง',
errorMessage: 'รหัสผ่านไม่ถูกต้อง',
pin: [0, 1, 2, 3, 4 ,5],
onCallback: (bool result) {
//do after ture
print(result);
},
),
```