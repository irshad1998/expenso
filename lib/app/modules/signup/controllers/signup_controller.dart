import 'package:expenso/app/data/countries.dart';
import 'package:expenso/app/widgets/country_picker.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final initialCountry = 'in'.obs;
  final initialCountryCode = '91'.obs;

  void setCountry(Country country) {
    initialCountry.value = country.code;
    initialCountryCode.value = country.dialCode;
  }

  @override
  void onInit() {
    super.onInit();
    Get.put(CountryPickerController());
  }

  @override
  void dispose() {
    Get.delete<CountryPickerController>(force: true);
    super.dispose();
  }
}
