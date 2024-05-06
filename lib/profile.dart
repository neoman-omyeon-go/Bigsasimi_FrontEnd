import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_userinfo.dart';
import 'profile_exeldata.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserInfo userInfo = UserInfo(
    userName: 'User name',
    sex: 'Male',
    age: '25',
    height: '180',
    weight: '75',
  ); // userInfo 변수 추가 및 초기화


  UserProfile userProfile = UserProfile(
      sex: 'sex',
      age: '25',
      height: '180',
      weight: '75',
      chronicIllnesses: [],
      allergies: [],
      calorieIntake: '0',
      carbIntake: '0',
      proteinIntake: '0',
      fatIntake: '0',
  );

  File? _image;
  String calorieIntake = '0';
  String carbIntake = '0';
  String proteinIntake = '0';
  String fatIntake = '0';
  List<String> selectedChronicIllnesses = [];
  List<String> selectedAllergies = [];

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
              onPressed: () {
                // 저장 버튼을 눌렀을 때의 동작 구현
                // 예: _saveProfile();
                userProfile.uploadToServer(
                  _image,
                  userInfo.sex,
                  userInfo.age,
                  userInfo.height,
                  userInfo.weight,
                  selectedChronicIllnesses,
                  selectedAllergies,
                  calorieIntake,
                  carbIntake,
                  proteinIntake,
                  fatIntake,
                );
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
                  selectedItems: selectedChronicIllnesses,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Allergies',
                  color: Colors.pink.shade100,
                  onTap: () {
                    _showAllergiesDialog();
                  },
                  selectedItems: selectedAllergies,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Desired daily intake',
                  color: Colors.orange.shade100,
                  onTap: () {
                    _showDesiredDailyIntakeDialog();
                  },
                  selectedItems: [
                    'Calories: $calorieIntake kcal',
                    'Carbohydrates: $carbIntake g',
                    'Protein: $proteinIntake g',
                    'Fat: $fatIntake g',
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
        },
        child: Icon(Icons.logout),
      ),
    );
  }

  void _editProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelectedChronicIllnesses = List.from(selectedChronicIllnesses);
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
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('완료'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedChronicIllnesses);
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
          selectedChronicIllnesses = List<String>.from(result);
        });
      }
    });
  }

  void _showAllergiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelectedAllergies = List.from(selectedAllergies);
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
          selectedAllergies = List<String>.from(result);
        });
      }
    });
  }

  // Desired daily intake 다이얼로그 표시 메서드
  void _showDesiredDailyIntakeDialog() {
    // 각 입력 필드에 대한 컨트롤러 생성
    TextEditingController calorieController = TextEditingController(text: calorieIntake);
    TextEditingController carbController = TextEditingController(text: carbIntake);
    TextEditingController proteinController = TextEditingController(text: proteinIntake);
    TextEditingController fatController = TextEditingController(text: fatIntake);

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

  void _saveDesiredDailyIntake(String calories, String carbs, String protein, String fat) {
    setState(() {
      calorieIntake = calories;
      carbIntake = carbs;
      proteinIntake = protein;
      fatIntake = fat;
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
  String sex;
  String age;
  String height;
  String weight;
  List<String> chronicIllnesses;
  List<String> allergies;
  String calorieIntake;
  String carbIntake;
  String proteinIntake;
  String fatIntake;

  UserProfile({
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
    required this.chronicIllnesses,
    required this.allergies,
    required this.calorieIntake,
    required this.carbIntake,
    required this.proteinIntake,
    required this.fatIntake,
  });

  Future<void> uploadToServer(File? profileimg, String sex, String age, String height, String weight, List<String> chronicIllnesses,
      List<String> allergies, String calorieIntake, String carbIntake, String proteinIntake, String fatIntake) async {
    // allergies.join(",");
    var url = 'http://127.0.0.1:8000/api/profile/';

    print(sex);
    print(age);
    print(height);
    print(weight);
    print(allergies.join(","));
    print(chronicIllnesses.join(","));
    print(calorieIntake);
    print(carbIntake);

    var data = {
      'real_name': 'testName',
      'gender': sex,
      'age': age,
      'height': height,
      'weight': weight,
      'goals_calories': calorieIntake,
      'goals_carb': carbIntake,
      'goals_protein': proteinIntake,
      'goals_fat': fatIntake,
      'disease': chronicIllnesses.join(","),
      'allergy': allergies.join(","),
      'avatar': profileimg
    };

    try{
      var dio = Dio();
      Response response = await dio.put(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);
      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Upload userdata(no name) seccess!");
      }
    } catch (error) {
      // 예외 처리
      print("Error occurred: $error");
    }

    // 서버로 유저 프로필 정보를 업로드하는 코드 작성
    // 예를 들어, HTTP 요청을 사용하여 서버로 정보를 전송할 수 있습니다.
    // 이 메서드는 비동기로 작성되어야 합니다.
    // 이미지 파일의 경우 파일 경로를 서버에 업로드하거나 이미지 데이터를 바이트로 변환하여 전송할 수 있습니다.
  }
}




