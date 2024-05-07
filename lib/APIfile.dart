import 'dart:io';
import 'dart:math';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:capstone/Register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class allApi{
   final storage = FlutterSecureStorage();
  // var accessToken;
  // var refreshToken;
  //Login API Request
  Future<bool> login(String username, String password) async {
    var url = 'http://127.0.0.1:8080/api/login/';
    // var url = 'http://223.130.154.147:8080/api/login/';
    var checkdata;

    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
    };

    // var dio = Dio();
    // Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

    try {
      var dio = Dio();
      Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);
      if (response.statusCode == 200 || response.statusCode == 400) {
        // 성공적으로 요청이 완료된 경우
        print("Login successfully!");

        Map<String, dynamic> responseMap = response.data;
        var accessToken = responseMap["data"]["access"];
        var refreshToken = responseMap["data"]["refresh"];
        var error = responseMap["error"];

        print("Access: $accessToken");
        print("Refress: $refreshToken");
        print("Error value in Status 200 : $error");

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refeshToken', value: refreshToken);
        await storage.write(key: 'error', value: error);

        // print(await storage.read(key: 'accessToken'));
        // 보니까 storage에서 read 할때도 await가 필요한거 같아. 그러지 않으면 토큰이 비동기처리로 넘어오기때문에, 안넘어올수도 있음 await를 안쓰면
        checkdata = loginCheck();
      }
    } catch (error) {
      // 예외 처리
      print("Error occurred: $error");
      storage.write(key: 'error', value: "error");
      checkdata = false;
    }
    return checkdata;
  }

  Future<bool> loginCheck() async{
    bool check = false;
    String? value = await storage.read(key: 'error');
    print("Login check error:${value}");
    if(value == null){
      check = true;
      print(check);
    }
    print(check);
    return check;
  }


//SignUp API Request
  Future<bool> signUp(String username, String password, String email) async {
    var url = 'http://127.0.0.1:8000/api/signup/';
    // var url = 'http://223.130.154.147:8080/api/signup/';
    var registerCheckvalue;
    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
      'email': email,
    };

    try {
      var dio = Dio();
      final response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Signed up successfully!");
        print("${response.data}");
        print("statusCode: ${response.statusCode}");
        await storage.write(key: 'msg', value: null);

        registerCheckvalue = registerCheck();
      }
    } catch (error) {
      // 예외 처리
      // 어짜피 200을 제외한 모든 Status Code는 catch에서 잡힌다니까
      // 그럼 여기서 토스트 메세지를 띄워주면 되겠네 ㅇㅇ 아이디가 중복된다. 라고
      print("Error occurred: $error");
      await storage.write(key: 'msg', value: "Duplicated");
      registerCheckvalue = false;
    }
    return registerCheckvalue;
  }

  //storage는 AllApi의 클래스에 전역 공간에 선언된 FlutterSecureStorage 임.
  // 그래서 storage를 사용할거면, class 안에다가 함수를 맹글어야 함.
  Future<bool> registerCheck() async{
    bool check = false;
    String? value = await storage.read(key: 'msg');
    print("Register check error:$value");

    if(value == null){
        check = true;
        print(check);
    }
    print(check);

    return check;
  }

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
    print(profileimg);

    var data;
    var checkAllegies;
    var checkIllnesses;
    var isnullIMG = false;
    var isnullallegies = false;
    var isnullillnesses = false;


    if(allergies.isEmpty){
      print("allegies null");
      // checkAllegies = "\n";
      isnullallegies = true;
    }else{
      checkAllegies  = allergies.join(",");
    }

    if(chronicIllnesses.isEmpty){
      print("Illnesses null");
      // checkIllnesses = "\0";
      isnullillnesses = true;
    }else{
      checkIllnesses = chronicIllnesses.join(",");
    }

    if(profileimg == null) {
      print("profile img is null");
      isnullIMG = true;
    }

      data = {
        'real_name': 'testName',
        'gender': sex,
        'age': age,
        'height': height,
        'weight': weight,
        'goals_calories': calorieIntake,
        'goals_carb': carbIntake,
        'goals_protein': proteinIntake,
        'goals_fat': fatIntake,
        // 'disease': checkIllnesses,
        // 'allergy': checkAllegies,
        // 'avatar': profileimg,
      };
      if(isnullallegies==false){
        data["disease"]='${chronicIllnesses.join(",")}';
      }
      if(isnullallegies==false){
        data["allergy"]='${allergies.join(",")}';
      }
      if(isnullIMG == false){
        data["avatar"] = profileimg;
      }




    var dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      print('accesstoken: $useaccessToken');
      Response response = await dio.put(url, data: data, options: Options(headers: {'Authorization': 'Bearer $useaccessToken','Content-Type': 'application/json; charset=UTF-8',},),);
      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Upload userdata(no name) seccess!");
        checkUploadToServerToast1();
        //메세지로 저장 잘 됐다. 라고 띄워줄거임
      }
    } on DioError catch (e){//이게 catch 대신에 사용하는 DIo의 조금 더 구체적인 트러블 슈팅인듯
      if(e.response != null){
        //서버에서 응답 받았지만, 오류 상태 코드를 받은 경우
        print('Status code: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Headers: ${e.response?.headers}');
      }else{
        //요청이 서버에 도달하지 못한 경우
        print('Error sending request!');
        print(e.message);
      }
    }

    // 서버로 유저 프로필 정보를 업로드하는 코드 작성
    // 예를 들어, HTTP 요청을 사용하여 서버로 정보를 전송할 수 있습니다.
    // 이 메서드는 비동기로 작성되어야 합니다.
    // 이미지 파일의 경우 파일 경로를 서버에 업로드하거나 이미지 데이터를 바이트로 변환하여 전송할 수 있습니다.
  }
  void checkUploadToServerToast1(){
    Fluttertoast.showToast(
        msg: "Upload userdata seccess!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }




}













