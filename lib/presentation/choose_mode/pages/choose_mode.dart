import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musik/common/widgets/button/basic_app_button.dart';
import 'package:musik/core/configs/assets/app_images.dart';
import 'package:musik/core/configs/assets/app_vectors.dart';


class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
  vertical: 40,
  horizontal: 40,
),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.chooseModeBG),
              ),
            ),
            
          ),
          Container(
  color: Colors.black.withOpacity(0.15),
),
Padding(
  padding: const EdgeInsets.symmetric(
    vertical: 40,
    horizontal: 40,
  ),
  child: Column(
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: SvgPicture.asset(
          AppVectors.logo,
        ),
      ),
      Spacer(),
      Text(
        'Pilih Mode',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 50),
 
  const SizedBox(height: 20),
  BasicAppButton(
    onPressed: () {
      Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const ChooseModePage(),
    ),
  );
    },
    title: 'Lanjut',
  ),
    ],
  ),
),
        ],
      ),
    );
  }
}
