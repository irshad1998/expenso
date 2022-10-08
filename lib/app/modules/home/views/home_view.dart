import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/dimens.dart';
import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/utilities/screen.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.initialized;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          // controller: controller.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: Get.mediaQuery.size.height * .385,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    color: Colors.transparent,
                    child: Container(
                      width: width,
                      height: height * 0.3,
                      child: Column(
                        children: [
                          Container(
                            width: width,
                            height: height * 0.075,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30.w,
                                        height: 30.w,
                                        child: Image.asset(
                                          'assets/images/menu.png',
                                          width: 30.w,
                                          height: 30.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        Strings.appName,
                                        style: TextStyle(
                                            fontSize: 25.s, fontFamily: 'sans_bold', color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                                      lastDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: AppColors.primary,
                                              onSurface: Colors.blue,
                                            ),
                                            splashColor: AppColors.primary,
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ),
                                    child: Text(
                                      '12-03-1998',
                                      style: TextStyle(color: Colors.blue, fontFamily: 'sans_bold'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            child: Container(
                              width: width,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                // color: AppColors.primary,
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, Color.fromARGB(255, 56, 160, 246)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Balance',
                                                style: TextStyle(
                                                    fontSize: 26.s, color: Colors.white, fontFamily: 'one_700'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('₹ 18523',
                                                  style: TextStyle(
                                                      fontSize: 18.s, color: Colors.white, fontFamily: 'one_700')),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    // width: width * 0.8,
                                                    child: Text(
                                                      'Income',
                                                      style: TextStyle(
                                                          fontSize: 16.s, color: Colors.white, fontFamily: 'one_700'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    // width: width * 0.8,
                                                    child: Text('₹ 18523',
                                                        style: TextStyle(
                                                            fontSize: 14.s,
                                                            color: Colors.white,
                                                            fontFamily: 'one_700')),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 20.w),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    // width: width * 0.8,
                                                    child: Text(
                                                      'Expense',
                                                      style: TextStyle(
                                                          fontSize: 16.s, color: Colors.white, fontFamily: 'one_700'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    // width: width * 0.8,
                                                    child: Text('₹ 18523',
                                                        style: TextStyle(
                                                            fontSize: 14.s,
                                                            color: Colors.white,
                                                            fontFamily: 'one_700')),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        // color: Colors.green,
                                        height: double.infinity,
                                        // child: Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.end,
                                        //   children: [
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.05,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.055,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.07,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.055,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.1,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.05,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.04,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.055,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.08,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 6.w),
                                        //     Container(
                                        //       width: 10.h,
                                        //       height: height * 0.03,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //           width: 0.2,
                                        //           color: Color.fromARGB(
                                        //               255, 56, 160, 246),
                                        //         ),
                                        //         gradient: LinearGradient(
                                        //           colors: [
                                        //             // AppColors.primary,
                                        //             Color.fromARGB(
                                        //                     255, 56, 160, 246)
                                        //                 .withOpacity(0.2),
                                        //             AppColors.primary
                                        //                 .withOpacity(0.2),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            child: Container(
                              height: height * 0.08,
                              width: width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Container(
                                        height: height * 0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Container(
                                        height: height * 0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Container(
                                        height: height * 0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Expenso',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 12.s, fontFamily: 'sans_bold'),
                                            ),
                                            Text(
                                              'Secure+',
                                              style: TextStyle(
                                                  fontSize: 18.s, fontFamily: 'sans_bold', color: AppColors.primary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      // color: Colors.red,
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(-9),
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.blue.withOpacity(0.1),
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        indicatorWeight: 1,
                        indicatorPadding: EdgeInsets.zero,
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xff20282A).withOpacity(0.8),
                        labelStyle: TextStyle(fontFamily: 'sans_bold', fontSize: 14.s),
                        unselectedLabelStyle: TextStyle(fontFamily: 'sans_medium', fontSize: 12.s),
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        controller: controller.primaryTabController,
                        tabs: controller.primaryTabList.map((e) {
                          var index = controller.primaryTabList.indexWhere((element) => e == element);
                          return Tab(
                            child: Text('$e'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              if (direction == ScrollDirection.reverse) {
                controller.showFab.value = false;
              } else if (direction == ScrollDirection.forward) {
                controller.showFab.value = true;
              }
              return true;
            },
            child: TabBarView(
              controller: controller.primaryTabController,
              children: [
                Container(
                  width: width,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          width: width,
                          height: height * 0.13,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                height: (height * 0.13) * 0.7,
                                // color: Colors.green,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 55.w,
                                            height: 55.w,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20), color: AppColors.primary),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  bottom: -4,
                                                  right: -4,
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: Colors.white.withOpacity(0.1),
                                                  ),
                                                ),
                                                // 135 incoming
                                                // 315 outgoing
                                                RotationTransition(
                                                  turns: AlwaysStoppedAnimation(315 / 360),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Image.asset(
                                                      'assets/images/arrwo_white.png',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Column(
                                            children: [
                                              SizedBox(height: 2.h),
                                              SizedBox(
                                                width: width * 0.6,
                                                child: Text(
                                                  'Paid to',
                                                  style: TextStyle(fontFamily: 'one_400'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.6,
                                                child: Text(
                                                  'Mr. Irshad KP',
                                                  style: TextStyle(fontFamily: 'one_700', fontSize: 14.s),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '₹ 32',
                                        style: TextStyle(fontFamily: 'one_700', fontSize: 14.s),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '12-03-1998 10:38 PM',
                                      style: TextStyle(fontFamily: 'one_400', fontSize: 11.s),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Debited from: ',
                                          style: TextStyle(fontFamily: 'one_400', fontSize: 12.s),
                                        ),
                                        Text(
                                          'Axis Bank',
                                          style: TextStyle(fontFamily: 'one_700', fontSize: 12.s),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: width,
                                  height: 0.1,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
                Container(),
                Container(),
                // buildAllTab(controller),
                // buildUpcomingTab(controller),
                // buildOnGoingTab(controller),
                // buildCompletedTab(controller),
                // buildCancelledTab(controller),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: Obx(
        () => AnimatedSlide(
          duration: Duration(milliseconds: 300),
          offset: controller.showFab.value ? Offset.zero : const Offset(4, 0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: controller.showFab.value ? 1 : 0,
            child: FloatingActionButton(
              focusColor: AppColors.primary,
              backgroundColor: AppColors.primary,
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      width: width,
      height: height * 0.078,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...controller.navIcoData.asMap().entries.map(
                  (e) => InkWell(
                    onTap: () => controller.selectedIndex.value = e.key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          child: Icon(
                            e.value,
                            color: Colors.white,
                            size: 16,
                          ),
                          backgroundColor: controller.selectedIndex.value == e.key ? AppColors.primary : Colors.grey,
                        ),
                        Text(
                          'data',
                          style: TextStyle(
                            fontSize: 12.s,
                          ),
                        )
                      ],
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
