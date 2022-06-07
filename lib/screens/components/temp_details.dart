import 'package:flutter/material.dart';
import 'package:model_s/constanins.dart';
import 'package:model_s/screens/components/tmp_btn.dart';

import '../../home_controller.dart';
class TempDetails extends StatelessWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  }) : _controller = controller, super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                  isActive: _controller.isCoolSelected,
                  svgSrc: "assets/icons/coolShape.svg",
                  title: "Cool",
                  press: _controller.updateCollSelectedTab,
                ),
                SizedBox(width: defaultPadding),
                 TempBtn(
                  isActive: !_controller.isCoolSelected,
                  svgSrc: "assets/icons/heatShape.svg",
                  title: "Heat",
                  activeColor: redColor,
                  press: _controller.updateCollSelectedTab,
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_up, size: 48,)
                ),
                Text(
              "29" + "\u2103",
              style: TextStyle(fontSize: 86),
            ),
            IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.arrow_drop_down, size: 48,)
            ),
            ],
          ),
            Spacer(),
            Text("CURRENT TEMPERATURE"),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inside".toUpperCase(),
                    ),
                    Text(
                      "20" + "\u2103",
                      style:  Theme.of(context).textTheme.headline5,
                    )
                  ],
                ),
                const SizedBox(width: defaultPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inside".toUpperCase(),
                      style: TextStyle(color: Colors.white54),
                    ),
                    Text(
                      "35" + "\u2103",
                      style:  Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white54),
                    )
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}