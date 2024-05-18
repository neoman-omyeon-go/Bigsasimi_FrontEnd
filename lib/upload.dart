import 'package:capstone/intakenGraph.dart';
import 'package:capstone/localMapRestaurant.dart';
import 'package:capstone/todaysNews.dart';
import 'package:capstone/upload2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'APIfile.dart';
import 'upload3.dart';
import 'profile.dart' as profile;

//처음 화면 초기화시에, 로그인 성공~ 하면서 뜨게 해줄거임
//loginSuccessed();
dynamic imgpath;
XFile? image;
bool loading = false;
Map<String, dynamic>? responseData;
Map<String, String> controlData = Map();

class uploadScreen extends StatefulWidget {
  @override
  _uploadScreenState createState() => _uploadScreenState();
}

class _uploadScreenState extends State<uploadScreen> {
  int _selectedIndex = 2;  // Upload 페이지를 초기 선택된 탭으로 설정
  bool _isLoading = false; // 로딩 상태 변수
  List<Widget> _pages = [];

  @override
  void initState() {
    allApi().getUserNutrition();
    super.initState();
    _pages = [
      TodaysNews(),
      map(),
      UploadScreen(), // UploadScreen의 메인 컨텐츠
      HealthInfoGraph(),
      Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    // 2초간 로딩 인디케이터를 표시한 후 페이지 전환
    Future.delayed(Duration(milliseconds: 120), () {
      setState(() {
        _selectedIndex = index;
        _isLoading = false; // 로딩 종료
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  final ImagePicker _picker = ImagePicker();

  // 카메라에서 사진을 찍는 함수
  Future<void> _takePicture() async {
    image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // 사진 파일 사용
      print("찍은 사진의 경로: ${image!.path}");
      //api로 로드하기
      setState(() {
        imgpath = image!.path;
        image;
      });
    }
  }

  // 갤러리에서 사진을 선택하는 함수
  Future<void> _pickImage() async {

    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 사진 파일 사용
      print("선택된 사진의 경로: ${image!.path}");
      //api로 로드하기
      setState(() {
        imgpath = image!.path;
        image;
      });
    }
  }

  Future<void> _uploadImage() async {
    // 로딩 팝업 표시
    showDialog(
      context: context,
      barrierDismissible: false, // 팝업 외부를 터치해도 팝업이 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("서버로 업로드 중..."),
            ],
          ),
        );
      },
    );

    // API 호출
    responseData = await allApi().postTakeaPickture(imgpath);
    bool success;
    if(responseData == null){
      print("responseData: ${responseData}");
      success = false;
    }else{
      print("responseData: ${responseData}");
      success = true;
    }

    // 팝업 닫기
    Navigator.pop(context);

    if (success) {
      // responseData를 controlData로 매핑
      controlData['calories'] = responseData!['kcal'];
      controlData['carb'] = responseData!['탄수화물'];
      controlData['protein'] = responseData!['단백질'];
      controlData['fat'] = responseData!['지방'];
      controlData['natrium'] = responseData!['나트륨'];
      controlData['sugar'] = responseData!['당류'];
      controlData['cholesterol'] = responseData!['콜레스테롤'];
      controlData['imgpath'] = responseData!['image_path'];

      print("controlData: ${controlData}");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("응답 데이터 확인"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    'http://175.45.204.16:8001${controlData['imgpath']}',
                    width: 260,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['calories'].toString(),
                      decoration: InputDecoration(labelText: 'calories'),
                      onChanged: (value) {
                        controlData['calories'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['carb'].toString(),
                      decoration: InputDecoration(labelText: 'carb'),
                      onChanged: (value) {
                        controlData['carb'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['protein'].toString(),
                      decoration: InputDecoration(labelText: 'protein'),
                      onChanged: (value) {
                        controlData['protein'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['fat'].toString(),
                      decoration: InputDecoration(labelText: 'fat'),
                      onChanged: (value) {
                        controlData['fat'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['natrium'].toString(),
                      decoration: InputDecoration(labelText: 'natrium'),
                      onChanged: (value) {
                        controlData['natrium'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['sugar'].toString(),
                      decoration: InputDecoration(labelText: 'sugar'),
                      onChanged: (value) {
                        controlData['sugar'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: controlData['cholesterol'].toString(),
                      decoration: InputDecoration(labelText: 'cholesterol'),
                      onChanged: (value) {
                        controlData['cholesterol'] = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    image = null;
                  });
                },
              ),
              TextButton(
                child: Text("확인"),
                onPressed: () async{
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "확인 버튼을 눌렀습니다.");
                  bool check = false;

                  print("carb: ${controlData['carb']}");
                  check = await allApi().postNutritionInfoWithAI(
                      image!.path,
                      controlData['calories']!,
                      controlData['carb']!,
                      controlData['protein']!,
                      controlData['fat']!,
                      controlData['natrium']!,
                      controlData['cholesterol']!,
                      controlData['sugar']!,
                  );

                  if(check){
                    print("API Send Success");
                    profile.nutrition = Nutrition(
                      calories: profile.nutrition.calories + double.parse(controlData['calories']!),
                      carbs: profile.nutrition.carbs + double.parse(controlData['carb']!),
                      protein: profile.nutrition.protein + double.parse(controlData['protein']!),
                      fats: profile.nutrition.fats + double.parse(controlData['fat']!),
                      sodium: profile.nutrition.sodium + double.parse(controlData['natrium']!),
                      cholesterol: profile.nutrition.cholesterol + double.parse(controlData['cholesterol']!),
                      sugars: profile.nutrition.sugars + double.parse(controlData['sugar']!),
                    );
                  }else{
                    print("API Send NO No No Success");
                  }

                  setState(() {
                    image = null;
                  });
                },
              ),
            ],
          );
        },
      );

      Fluttertoast.showToast(msg: "업로드 성공!");
    } else {
      Fluttertoast.showToast(msg: "인식에 실패하였습니다. 영양성분 표를 찍어서 올려주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
      body: ListView( // 화면이 작을 경우 스크롤이 가능하도록 ListView를 사용합니다.
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 50, right: 210),
              child: Text(
                'Record your diet.',
                style: TextStyle(
                  fontSize: 30, // 텍스트의 크기를 더 크게 변경합니다.
                  fontWeight: FontWeight.bold, // 글씨체를 굵게 합니다.
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Please take a photo of the foods Nutrition information',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _showChoiceDialog,
            child: DashedBorderBox(),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
            child: TextButton(
              onPressed: _uploadImage,
              child: Text('Send to server'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // 텍스트 색상을 지정합니다.
                backgroundColor: Colors.black, // 배경 색상을 지정합니다.
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: <Widget>[
                Icon(
                  Icons.report, // 느낌표 아이콘
                  color: Color.fromRGBO(237, 118, 81, 1.0),
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 사이에 간격 추가
                Expanded( // 텍스트가 화면 너비를 벗어나지 않도록 Expanded 위젯을 사용합니다.
                  child: Text(
                    'If you would like to enter more accurate information manually, please click the button below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, right: 20.0), // 우측 하단으로 이동
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200.0, // 버튼의 가로 크기
                height: 40.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // 그림자 색상
                      spreadRadius: 2, // 그림자 확산 정도
                      blurRadius: 5, // 그림자의 흐릿한 정도
                      offset: Offset(5, 5), // 그림자 위치 (가로, 세로)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.0), // 버튼의 둥근 모양
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // 'Click!' 버튼을 눌렀을 때 실행될 액션을 여기에 추가합니다.
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => upload2()),
                    );
                  },
                  child: Text('Click!'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 버튼의 사각형 모양
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 내부 여백
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(237, 118, 81, 1.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 사용자가 탭했을 때 다이얼로그를 표시하는 함수
  Future<void> _showChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("사진 촬영 OR 선택"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("사진 찍기"),
                    onTap: () {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      _takePicture(); // 사진 찍기 함수 호출
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("갤러리에서 사진 가져오기"),
                    onTap: () {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      _pickImage(); // 갤러리에서 사진 선택 함수 호출
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.search),
                    title: Text("음식 검색"),
                    onTap: () {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FoodSearch()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

class DashedBorderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        dashPattern: [8, 4],
        strokeWidth: 2,
        child: Container(
          color: Colors.white,
          width: 330,
          height: 400,
          alignment: Alignment.center,
          child: image == null
              ? Icon(
            Icons.add,
            color: Colors.grey,
            size: 50,
          )
              : Image.file(
            File(image!.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
