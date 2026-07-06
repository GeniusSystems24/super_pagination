# تقرير إعادة هيكلة SuperPagination

## الهدف

أُعيد تنظيم حزمة `smart_pagination` باسم `super_pagination` مع الحفاظ على طريقة
الاستخدام الحالية قدر الإمكان، وإضافة أسماء `SuperPagination*` الجديدة دون حذف
أسماء `SmartPagination*` القديمة.

## التغييرات المعمارية

- فصل نماذج المجال والأخطاء عن Flutter.
- نقل عقود مزودي البيانات والحالات وسياسة إعادة المحاولة إلى Application.
- إبقاء Flutter وBLoC وProvider وLogger وScroll Observer داخل Presentation.
- تقسيم Presentation وفق MVC إلى Models وControllers وViews.
- فصل ميزة Pagination عن ميزة Search بدلاً من جمع جميع الملفات في مكتبة `part`
  واحدة على مستوى الحزمة كلها.
- جعل `super_pagination.dart` نقطة الدخول الرسمية.
- إبقاء `pagination.dart` ومسارات `core` و`data` كتصديرات توافقية.

## التوافق

التغيير الإلزامي الوحيد هو اسم الحزمة داخل `import`:

```dart
import 'package:super_pagination/pagination.dart';
```

تبقى جميع منشئات وخصائص واستدعاءات `SmartPagination*` متاحة، ويمكن استخدام
`SuperPagination*` الجديدة اختيارياً.

## الاختبارات المضافة

- اختبار أسماء SuperPagination الجديدة وتوافقها مع الأنواع القديمة.
- اختبار حدود Domain وApplication ومنع اعتمادهما على Flutter أو Presentation.
- فاحص ساكن في `tool/verify_architecture.py` لمسارات imports وexports وparts.
