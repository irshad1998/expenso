import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/dimens.dart';
import 'package:expenso/app/data/countries.dart';
import 'package:expenso/app/modules/login/views/login_view.dart';
import 'package:expenso/app/utilities/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CountryPicker extends StatelessWidget {
  CountryPicker({super.key, required this.initialCountry, required this.onSelect});
  final String initialCountry;
  ValueChanged<Country> onSelect;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(_buildCountryListBottomSheet(onSelect),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          clipBehavior: Clip.hardEdge),
      child: Container(
        width: 55,
        height: 49,
        decoration: BoxDecoration(
            color: Colors.transparent, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Container(
            width: 55 - 20,
            height: 40 - 16,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Image.asset(
              'assets/flags/${initialCountry.toLowerCase()}.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryListBottomSheet(Function onSelect) {
    return Container(
      width: width,
      height: height / 1.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  hintText: 'Search country',
                  hintStyle: TextStyle(fontSize: 13.s, color: Color.fromARGB(255, 167, 167, 167)),
                  contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1),
                  ),
                ),
              ),
            ),
            Container(
              height: height * 0.42,
              width: width,
              child: GetBuilder<CountryPickerController>(
                builder: (controller) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    var country = controller.countryList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          splashColor: Colors.green.withOpacity(0.1),
                          onTap: () {
                            onSelect.call(country);
                            controller.onSelect(country);
                          },
                          child: Container(
                            width: width,
                            height: height * 0.07,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60 - 20,
                                        height: 45 - 16,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                                        child: Image.asset(
                                          'assets/flags/${country.code.toLowerCase()}.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        country.name,
                                        style: TextStyle(fontSize: 14.s, fontFamily: 'one_700'),
                                      ),
                                    ],
                                  ),
                                  country.isSelected!
                                      ? SvgPicture.asset(
                                          'assets/svgs/circle_selected.svg',
                                          width: 20,
                                          height: 20,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: countries.length,
                ),
              ),
            ),
            Material(
              color: AppColors.primary,
              child: InkWell(
                splashColor: Colors.white.withOpacity(0.2),
                onTap: () => Get.back(),
                child: Container(
                  width: width,
                  height: 56,
                  child: Center(
                    child: Text(
                      'DONE',
                      style: TextStyle(fontSize: 14.s, color: Colors.white, fontFamily: 'one_700'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountryPickerController extends GetxController {
  final countryList = <Country>[...countries].obs;
  final searchList = <Country>[].obs;

  void onSelect(Country country) {
    for (int i = 0; i < countryList.length; i++) {
      if (country.code == countryList[i].code) {
        countryList[i].isSelected = true;
      } else {
        countryList[i].isSelected = false;
      }
    }
    update();
  }

  void searchCountry() {}
}
