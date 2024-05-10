import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_userinfo.dart';
import 'profile_exeldata.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'APIfile.dart';
import 'providers/userprofile_providers.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
late UserInfo userInfo;
late UserProfile userProfile;

File? _image;
// String calorieIntake = '0';
// String carbIntake = '0';
// String proteinIntake = '0';
// String fatIntake = '0';
// String natriumIntake = '0';
// List<String> selectedChronicIllnesses = [];
// List<String> selectedAllergies = [];

final FlutterSecureStorage storage = FlutterSecureStorage();

Future<List<String?>> _loadUserInfo() async {

  List<Future<String?>> futures = [
    storage.read(key: 'real_name'),
    storage.read(key: 'gender'),
    storage.read(key: 'age'),
    storage.read(key: 'height'),
    storage.read(key: 'weight'),
    storage.read(key: 'avatar'),
    storage.read(key: 'id'),
    storage.read(key: 'disease'),
    storage.read(key: 'allergy'),
    storage.read(key: 'goals_calories'),
    storage.read(key: 'goals_carb'),
    storage.read(key: 'goals_protein'),
    storage.read(key: 'goals_fat'),
    storage.read(key: 'goals_natrium'),
  ];

  List<String?> results = await Future.wait(futures);

  print("result List: $results");

  return results;
}

Future<void> inituserinfo() async {
  List<String?> info = await _loadUserInfo();

  String? userName = info[0]??'userName';
  String? sex = info[1]??'Other';
  String? age = info[2]??'25';
  String? height = info[3]??'180';
  String? weight = info[4]??'75';
  String? avartar = info[5]??'avatarPath';
  String? id = info[6]??'defaultID';
  String? disease = info[7]??'';
  String? allergy = info[8]??'';
  String? goals_calories = info[9]??'0';
  String? goals_carb = info[10]??'0';
  String? goals_protein = info[11]??'0';
  String? goals_fat = info[12]??'0';
  String? goals_natrium = info[13]??'0';

  print("info List: $info");
  print(disease);
  print(userName);
  print(sex);
  print(age);
  print(height);
  print(weight);

  userInfo = UserInfo(
    userName: userName,
    sex: sex,
    age: age,
    height: height,
    weight: weight,
  );

  userProfile = UserProfile(
    // sex:sex,
    // age:age,
    // height:height,
    // weight:weight,
    chronicIllnesses: disease.replaceAll('[', '').replaceAll(']', '').split(','),
    allergies: allergy.replaceAll('[', '').replaceAll(']', '').split(','),
    calorieIntake: goals_calories,
    carbIntake: goals_carb,
    proteinIntake: goals_protein,
    fatIntake: goals_fat,
    natriumIntake:goals_natrium,
  );

  setState(() {
    UserInfo(
      userName: userName,
      sex: sex,
      age: age,
      height: height,
      weight: weight,
    );

    UserProfile(
      // sex:sex,
      // age:age,
      // height:height,
      // weight:weight,
      chronicIllnesses: disease.replaceAll('[', '').replaceAll(']', '').split(','),
      allergies: allergy.replaceAll('[', '').replaceAll(']', '').split(','),
      calorieIntake: goals_calories,
      carbIntake: goals_carb,
      proteinIntake: goals_protein,
      fatIntake: goals_fat,
      natriumIntake:goals_natrium,
    );
  });
}

  @override
  void initState(){
    super.initState();
    inituserinfo().then((_) =>{
    setState(() {

    })
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              iconSize: 28,
              icon: Row(
                children: [
                  Text('저장'), // 텍스트// 저장 아이콘
                  SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                  Icon(Icons.save),
                ],
              ),
              onPressed: () async{
                // 저장 버튼을 눌렀을 때의 동작 구현
                // 예: _saveProfile();
                try{
                  await allApi().uploadToServer(
                    userProfile.image,
                    userInfo.sex,
                    userInfo.age,
                    userInfo.height,
                    userInfo.weight,
                    // selectedChronicIllnesses,
                    // selectedAllergies,
                    userProfile.chronicIllnesses,
                    userProfile.allergies,
                    userProfile.calorieIntake,
                    userProfile.carbIntake,
                    userProfile.proteinIntake,
                    userProfile.fatIntake,
                    userProfile.natriumIntake,
                  );

                  await inituserinfo().then((_) =>{
                    setState(() {

                    })
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update profile: $e'))
                  );
                }

                  // _loadUserInfo();
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          GestureDetector(
            onTap: _editProfilePicture,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[600],
              child: _image != null
                  ? ClipOval(
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              )
                  : Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          EditableUserName(
            userInfo: userInfo, // 이전에 정의된 userInfo 객체를 사용합니다
            initialName: userInfo.userName, // userInfo 객체의 userName 속성을 사용합니다
            onUpdateUserInfo: (UserInfo updatedUserInfo) {
              setState(() {
                userInfo = updatedUserInfo; // 상태 업데이트
              });
            },
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                UserInfoSection(
                  userInfo: userInfo,
                  onUpdateUserInfo: (UserInfo updatedUserInfo) {
                    setState(() {
                      userInfo = updatedUserInfo;
                    });
                  },
                ),

                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Chronic Illnesses',
                  color: Colors.lightBlue.shade100,
                  onTap: () {
                    _showChronicIllnessesDialog();
                  },
                  // selectedItems: selectedChronicIllnesses,
                  selectedItems: userProfile.chronicIllnesses,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Allergies',
                  color: Colors.pink.shade100,
                  onTap: () {
                    _showAllergiesDialog();
                  },
                  // selectedItems: selectedAllergies,
                  selectedItems: userProfile.allergies,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Desired daily intake',
                  color: Colors.orange.shade100,
                  onTap: () {
                    _showDesiredDailyIntakeDialog();
                  },
                  selectedItems: [
                    'Calories: ${userProfile.calorieIntake} kcal',
                    'Carbohydrates: ${userProfile.carbIntake} g',
                    'Protein: ${userProfile.proteinIntake} g',
                    'Fat: ${userProfile.fatIntake} g',
                    'natrium: ${userProfile.natriumIntake} g',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 로그아웃 버튼을 눌렀을 때의 동작 구현
          // 예: _logout();
          _showLogoutConfirmationDialog();

        },
        child: Icon(Icons.logout),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("LogOut"),
          content: Text("로그아웃 하시겠습니까?(로그아웃 시, 앱이 종료됩니다.)"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No를 선택한 경우 다이얼로그만 닫기
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes를 선택한 경우 다이얼로그 닫고 로그아웃 수행
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    ).then((logoutConfirmed) {
      if (logoutConfirmed ?? false) {
        SystemNavigator.pop(); // Yes를 선택한 경우 앱이 종료 됨. 안드에서만 작동하고, IOS에서는 작동 안한다고 함.
        // exit(0); // 이거는 안드, IOS 가릴거 없이 전부 종료된다고 함
        //재시작도 고려해봐야 할듯 그거는 flutter_restart: ^0.0.8 의존성을 추가하고 사용하는듯 함.
        print("Louout Logic Operating");
      }
    });
  }

  void _editProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Selected image path: ${image.path}");
      setState(() {
        _image = File(image.path);
      });
    } else {
      print("No image selected");
    }
  }

  void _showChronicIllnessesDialog() {
    List<String> tempSelectedChronicIllnesses = List.from(userProfile.chronicIllnesses);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // List<String> tempSelectedChronicIllnesses = List.from(selectedChronicIllnesses);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Chronic Illnesses'),
              content: Container(
                width: double.minPositive,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: chronicIllnesses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final illness = chronicIllnesses[index];
                    return CheckboxListTile(
                      title: Text(illness),
                      value: tempSelectedChronicIllnesses.contains(illness),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            if (!tempSelectedChronicIllnesses.contains(illness)) {
                              tempSelectedChronicIllnesses.add(illness);
                            }
                          } else {
                            tempSelectedChronicIllnesses.remove(illness);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('완료'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        if(result){
          setState(() {
            // selectedChronicIllnesses = List<String>.from(result);
            userProfile.chronicIllnesses = List<String>.from(tempSelectedChronicIllnesses);
          });
        }
      }
    });
  }

  void _showAllergiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // List<String> tempSelectedAllergies = List.from(selectedAllergies);
        List<String> tempSelectedAllergies = List.from(userProfile.allergies);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Allergies'),
              content: Container(
                width: double.minPositive,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: allergies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final allergy = allergies[index];
                    return CheckboxListTile(
                      title: Text(allergy),
                      value: tempSelectedAllergies.contains(allergy),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            if (!tempSelectedAllergies.contains(allergy)) {
                              tempSelectedAllergies.add(allergy);
                            }
                          } else {
                            tempSelectedAllergies.remove(allergy);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('완료'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedAllergies);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          // selectedAllergies = List<String>.from(result);
          userProfile.allergies = List<String>.from(result);
        });
      }
    });
  }

  // Desired daily intake 다이얼로그 표시 메서드
  void _showDesiredDailyIntakeDialog() {
    // 각 입력 필드에 대한 컨트롤러 생성
    TextEditingController calorieController = TextEditingController(text: userProfile.calorieIntake);
    TextEditingController carbController = TextEditingController(text: userProfile.carbIntake);
    TextEditingController proteinController = TextEditingController(text: userProfile.proteinIntake);
    TextEditingController fatController = TextEditingController(text: userProfile.fatIntake);
    TextEditingController natriumController = TextEditingController(text: userProfile.natriumIntake);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Desired daily intake'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField('Calories', 'Calories', calorieController),
                _buildInputField('Carbohydrates', 'Carbs (g)', carbController),
                _buildInputField('Protein', 'Protein (g)', proteinController),
                _buildInputField('Fat', 'Fat (g)', fatController),
                _buildInputField('Natrium', 'Natrium (g)', natriumController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('완료'),
              onPressed: () {
                // 입력된 내용 저장 후 다이얼로그 닫기
                _saveDesiredDailyIntake(
                  calorieController.text,
                  carbController.text,
                  proteinController.text,
                  fatController.text,
                  natriumController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildInputField(String nutrientName, String labelText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void _saveDesiredDailyIntake(String calories, String carbs, String protein, String fat, String natrium) {
    setState(() {
      userProfile.calorieIntake = calories;
      userProfile.carbIntake = carbs;
      userProfile.proteinIntake = protein;
      userProfile.fatIntake = fat;
      userProfile.natriumIntake = natrium;
    });
  }
}

class ProfileSectionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final List<String> selectedItems;

  const ProfileSectionButton({
    required this.title,
    required this.color,
    required this.onTap,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              color: color, // ProfileSectionButton의 배경색과 동일하게 설정
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedItems
                      .map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfile {
  File? image;
  // String sex;
  // String age;
  // String height;
  // String weight;
  List<String> chronicIllnesses;
  List<String> allergies;
  String calorieIntake;
  String carbIntake;
  String proteinIntake;
  String fatIntake;
  String natriumIntake;

  UserProfile({
    // required this.sex,
    // required this.age,
    // required this.height,
    // required this.weight,
    required this.chronicIllnesses,
    required this.allergies,
    required this.calorieIntake,
    required this.carbIntake,
    required this.proteinIntake,
    required this.fatIntake,
    required this.natriumIntake,
  });


}




