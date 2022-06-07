// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:model_s/constanins.dart';
import 'package:model_s/home_controller.dart';
import 'package:model_s/models/TyrePsi.dart';
import 'package:model_s/screens/components/door_lock.dart';
import 'package:model_s/screens/components/tesla_bottom_navigationbar.dart';
import 'package:model_s/screens/components/battery_status.dart';
import 'package:model_s/screens/components/tmp_btn.dart';
import 'package:model_s/screens/components/tyre_psi_card.dart';

import 'components/temp_details.dart';
import 'components/tyres.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempanimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowinfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationController;
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  late List<Animation<double>> _tyreAnimations;
  void setupBatteryanimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: Interval(0.0, 0.5),
    );
    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: Interval(0.6, 1),
    );
  }

  void SetupTempanimation() {
    _tempanimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationCarShift = CurvedAnimation(
      parent: _tempanimationController,
      curve: Interval(0.2, 0.4),
    );
    _animationTempShowinfo = CurvedAnimation(
      parent: _tempanimationController,
      curve: Interval(0.45, 0.65),
    );
    _animationCoolGlow = CurvedAnimation(
      parent: _tempanimationController,
      curve: Interval(0.7, 1),
    );
  }

  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animationTyre1Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.34, 0.5));
    _animationTyre2Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.5, 0.66));
    _animationTyre3Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.66, 0.82));
    _animationTyre4Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.82, 1));
  }

  @override
  void initState() {
    setupBatteryanimation();
    SetupTempanimation();
    setupTyreAnimation();
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempanimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        //thsi animation need listenable
        animation: Listenable.merge([
          _controller,
          _batteryAnimationController,
          _tempanimationController,
          _tyreAnimationController,
        ]),
        builder: (context, _) {
          return Scaffold(
              bottomNavigationBar: TeslaBottomNavigationBar(
                onTap: (index) {
                  if (index == 1)
                    _batteryAnimationController.forward();
                  else if (_controller.selectedBottomTab == 1 && index != 1)
                    _batteryAnimationController.reverse(from: 0.7);

                  if (index == 2)
                    _tempanimationController.forward();
                  else if (_controller.selectedBottomTab == 2 && index != 2)
                    _tempanimationController.reverse(from: 0.4);

                  if (index == 3)
                    _tyreAnimationController.forward();
                  else if (_controller.selectedBottomTab == 3 && index != 3)
                    _tyreAnimationController.reverse();

                  _controller.showTyreController(index);
                  _controller.tyreStatusController(index);
                  _controller.onBottomNavigationTabChange(index);
                },
                selectedTab: _controller.selectedBottomTab,
              ),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: ((context, constraints) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                        ),
                        Positioned(
                          left: constraints.maxWidth /
                              2 *
                              _animationCarShift.value,
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.1),
                            child: SvgPicture.asset(
                              "assets/icons/Car.svg",
                              width: double.infinity,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: defaultDuration,
                          right: _controller.selectedBottomTab == 0
                              ? constraints.maxWidth * 0.05
                              : constraints.maxWidth / 2,
                          child: AnimatedOpacity(
                            duration: defaultDuration,
                            opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                            child: DoorLock(
                              isLock: _controller.isRightDoorLock,
                              press: _controller.updateRightDoorlock,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: defaultDuration,
                          left: _controller.selectedBottomTab == 0
                              ? constraints.maxWidth * 0.05
                              : constraints.maxWidth / 2,
                          child: AnimatedOpacity(
                            duration: defaultDuration,
                            opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                            child: DoorLock(
                              isLock: _controller.isLeftDoorLock,
                              press: _controller.updateLeftDoorlock,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: defaultDuration,
                          top: _controller.selectedBottomTab == 0
                              ? constraints.maxHeight * 0.13
                              : constraints.maxHeight / 2,
                          child: AnimatedOpacity(
                            duration: defaultDuration,
                            opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                            child: DoorLock(
                              isLock: _controller.isBonnetLock,
                              press: _controller.updateBonnetDoorlock,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: defaultDuration,
                          bottom: _controller.selectedBottomTab == 0
                              ? constraints.maxHeight * 0.17
                              : constraints.maxHeight / 2,
                          child: AnimatedOpacity(
                            duration: defaultDuration,
                            opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                            child: DoorLock(
                              isLock: _controller.isTrunkLock,
                              press: _controller.updateTrunkDoorlock,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _animationBattery.value,
                          child: SvgPicture.asset(
                            "assets/icons/Battery.svg",
                            width: constraints.maxWidth * 0.45,
                          ),
                        ),
                        Positioned(
                          top: 50 * (1 - _animationBatteryStatus.value),
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: Opacity(
                            opacity: _animationBatteryStatus.value,
                            child: BatteryStatus(
                              constraints: constraints,
                            ),
                          ),
                        ),
                        Positioned(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          top: 60 * (1 - _animationTempShowinfo.value),
                          child: Opacity(
                            opacity: _animationTempShowinfo.value,
                            child: TempDetails(controller: _controller),
                          ),
                        ),
                        Positioned(
                          right: -180 * (1 - _animationCoolGlow.value),
                          child: AnimatedSwitcher(
                            duration: defaultDuration,
                            child: _controller.isCoolSelected
                                ? Image.asset(
                                    "assets/images/Cool_glow_2.png",
                                    key: UniqueKey(),
                                    width: 200,
                                  )
                                : Image.asset(
                                    "assets/images/Hot_glow_4.png",
                                    key: UniqueKey(),
                                    width: 200,
                                  ),
                          ),
                        ),
                        if (_controller.isShowTyre) ...tyres(constraints),
                        if (_controller.isShowTyreStatus)
                          GridView.builder(
                            itemCount: 4,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: defaultPadding,
                              crossAxisSpacing: defaultPadding,
                              childAspectRatio:
                                  constraints.maxWidth / constraints.maxHeight,
                            ),
                            itemBuilder: (context, index) => ScaleTransition(
                              scale: _tyreAnimations[index],
                              child: TyrePsiCard(
                                isBottomTwoTyre: index > 1,
                                tyrePsi: demoPsiList[index],
                              ),
                            ),
                          )
                      ],
                    );
                  }),
                ),
              ));
        });
  }
}
