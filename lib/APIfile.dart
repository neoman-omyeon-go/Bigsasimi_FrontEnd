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
import 'profile_userprofile.dart';
import 'profile_userinfoWidget.dart';
import 'profile.dart';
import 'intakenGraph.dart';
import 'upload3.dart';
import 'food.dart';
import 'dailyNutritionInfo.dart';

late Food food;
late Nutrition nutrition;
late UserInfo userInfo;
late UserProfile userProfile;
late DailyNutrition dailyNutrition;

class allApi{
   var storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    // var url = 'http://127.0.0.1:8080/api/login/';
    var url = 'http://223.130.154.147:8080/api/login/';
    var checkdata;

    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
    };


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
    // var url = 'http://127.0.0.1:8000/api/signup/';
    var url = 'http://223.130.154.147:8080/api/signup/';
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
      List<String> allergies, String calorieIntake, String carbIntake, String proteinIntake, String fatIntake, String natriumIntake) async {
    // allergies.join(",");
    // var url = 'http://127.0.0.1:8000/api/profile/';
      var url = 'http://223.130.154.147:8080/api/profile/';
    print(sex);
    print(age);
    print(height);
    print(weight);
    print(allergies.join(","));
    print(chronicIllnesses.join(","));
    print(calorieIntake);
    print(natriumIntake);
    print(carbIntake);
    print(profileimg);

    var data;
    var checkAllegies;
    var checkIllnesses;
    var isnullIMG = false;
    var isnullallegies = false;
    var isnullillnesses = false;


    if(allergies.length == 1){
      print("allegies null actually one(,)");
      // checkAllegies = "\n";
      isnullallegies = true;
    }else{
      checkAllegies  = allergies.join(",");
    }

    if(chronicIllnesses.length==1){
      print("Illnesses null actually one(,)");
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
        'goals_natrium': natriumIntake,
        // 'disease': checkIllnesses,
        // 'allergy': checkAllegies,
        // 'avatar': profileimg,
      };
      if(isnullillnesses==false){
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


  Future<void> updateToserver2(String realnameController) async{
    // var url = 'http://127.0.0.1:8000/api/profile/';
    var url = 'http://223.130.154.147:8080/api/profile/';
    print(realnameController);
    var dio = Dio();

    var dddd = {
      'key': "real_name",
      'value': realnameController,
    };

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.post(url, data: {'key': "real_name", 'value': realnameController},
        options: Options(headers:
        {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
        ),
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Upload name seccess!");
        // checkUploadToServerToast1();
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
  }

  Future<String> updateToServer3(dynamic imgfile) async{
    // var url = 'http://127.0.0.1:8000/api/profile_avatar_uplaoad/'
    var url = 'http://223.130.154.147:8080/api/profile_avatar_uplaoad/';
    print(" recieve Parameter $imgfile");

    var dio = Dio();
    late String imgURI;

    var formData = FormData.fromMap({'image': await MultipartFile.fromFile(imgfile),});
    // Map<String, File?> data = {
    //   'image': imgfile,
    // };

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.post(url, data: formData, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken', 'Content-Type': 'multipart/form-data; ''charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
        ),
      );

      print("Try Try Try");
      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우

        print("Upload profileimg Success!: ${response.data['data']['avatar']}");
        imgURI = response.data['data']['avatar'];

        //메세지로 저장 잘 됐다. 라고 띄워줄거임

      }
    } on DioError catch (e){//이게 catch 대신에 사용하는 DIo의 조금 더 구체적인 트러블 슈팅인듯
      if(e.response != null){
        //서버에서 응답 받았지만, 오류 상태 코드를 받은 경우
        print('Status code: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Headers: ${e.response?.headers}');

        imgURI = "Static IMG URI Has a Error Occured ${e.response?.statusCode}";
      }else{
        //요청이 서버에 도달하지 못한 경우
        print('Error sending request!');
        print(e.message);
        imgURI = "Static IMG URI Has a Error Occured(No Request) ${e.message}";
      }
    }

    return imgURI;
  }


  Future<void> getUserState() async{
    // var url = 'http://127.0.0.1:8000/test/authonly/';
    var url = 'http://223.130.154.147:8080/test/authonly/';

    Dio dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.get(url, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
        ),
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("get UserState seccess!");
        // checkUploadToServerToast1();
        await storage.write(key: 'username', value:response.data['username']);
        print(response.data['username']);

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
    getUserProfile();
  }


  Future<void> getUserProfile( ) async {
    var username = await storage.read(key: 'username');
    // await Future.delayed(Duration(seconds: 3));

    print("username: ${username}");
    // var url = 'http://127.0.0.1:8000/api/profile/?username=${username}';
    var url = 'http://223.130.154.147:8080/api/profile/?username=${username}';


    Dio dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.get(url, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("get UserProfile seccess!");
        // checkUploadToServerToast1();
        // print(response.data["data"]);

        var profileData = response.data["data"];

        print("ProfileData$profileData");

        await storage.write(key: 'id', value: profileData["id"].toString());
        print("ProfileData ID: ${await storage.read(key: 'id')}");
        String? id = profileData["id"].toString()??'';
        String avartar = profileData["avatar"]??'avatarPath';
        String userName = profileData["real_name"]??'userName';
        String sex = profileData["gender"]??'Other';
        String? age = profileData["age"].toString()??'25';
        String? height = profileData["height"].toString()??'175';
        String? weight = profileData["weight"].toString()??'70';
        String disease = profileData["disease"].toString()??'';
        String allergy = profileData["allergy"].toString()??'';
        String? goals_calories = profileData["goals_calories"].toString()??'0';
        String? goals_carb = profileData["goals_carb"].toString()??'0';
        String? goals_protein = profileData["goals_protein"].toString()??'0';
        String? goals_fat = profileData["goals_fat"].toString()??'0';
        String? goals_natrium = profileData["goals_natrium"].toString()??'0';

        // disease = disease.substring(disease.length,disease.length).substring(0,0);
        // allergy = allergy.substring(disease.length,disease.length).substring(0,0);
        // disease = disease.substring(0,0);
        // disease = disease.substring(2,disease.length-1);
        // allergy = allergy.substring(2, allergy.length-1);
        // disease.split(',');
        // print("disease${disease}");

        print("avatar Json Parsing $avartar");

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
          avatar: avartar,
          chronicIllnesses: disease.replaceAll('[', '').replaceAll(']', '').split(','),
          allergies: allergy.replaceAll('[', '').replaceAll(']', '').split(','),
          calorieIntake: goals_calories,
          carbIntake: goals_carb,
          proteinIntake: goals_protein,
          fatIntake: goals_fat,
          natriumIntake:goals_natrium,
        );

        // giveUserinfo();
        // giveUserprofile();
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

  }


  // UserProfile giveUserprofile(){
  //   return userProfile1;
  // }
  //
  // UserInfo giveUserinfo(){
  //   return userInfo1;
  // }

  Future<bool> postNutritionInfoManually(String calories, String carb, String protein, String fat, String natrium, String cholesterol, String sugar) async{
    // var url = 'http://127.0.0.1:8000/api/get_ingestioninformation/';
    var url = 'http://223.130.154.147:8080/api/get_ingestioninformation/';

    bool _isSuccess = false;

    Dio dio = Dio();

    var data;

    data = {
      'calories': calories,
      'carb': carb,
      'protein': protein,
      'fat': fat,
      'natrium': natrium,
      'cholesterol': cholesterol,
      'saccharide': sugar,
      //sugar는 지호가 API 업데이트 해주면 주석 풀기만 하면 됨.
    };

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.post(url, data: data, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Post Manually send Nutrition Info is seccess!");
        print(response.data);

        //메세지로 저장 잘 됐다. 라고 띄워줄거임
        checkPostNutritionManuallyToServerToast();
        _isSuccess = true;

      }
    } on DioError catch (e){//이게 catch 대신에 사용하는 DIo의 조금 더 구체적인 트러블 슈팅인듯
      if(e.response != null){
        //서버에서 응답 받았지만, 오류 상태 코드를 받은 경우
        print('Status code: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Headers: ${e.response?.headers}');
        _isSuccess = false;
      }else{
        //요청이 서버에 도달하지 못한 경우
        print('Error sending request!');
        print(e.message);
        _isSuccess = false;
      }
    }

    return _isSuccess;
  }

  void checkPostNutritionManuallyToServerToast(){
    Fluttertoast.showToast(
        msg: "Upload Nutrition Info is seccess!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }

  Future<void> getUserNutrition() async {
    var userId = await storage.read(key: 'id');
    // var url = 'http://127.0.0.1:8000/api/get_dailyinformation/?id=${userId}';
    var url = 'http://223.130.154.147:8080/api/get_dailyinformation/?id=${userId}';
    print("userID: $userId");

    Dio dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.get(url, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("get UserNutrioton Success");
        // checkUploadToServerToast1();
        // print(response.data["data"]);

        var NutritionData = response.data["data"];
        print("nutrition Data: $NutritionData");

        String total_calories = NutritionData["total_calories"].toString();
        String total_carb = NutritionData["total_carb"].toString();
        String total_protein = NutritionData["total_protein"].toString();
        String total_fat = NutritionData["total_fat"].toString();
        String total_natrium = NutritionData["total_natrium"].toString();
        String total_cholesterol = NutritionData["total_cholesterol"].toString();
        String total_saccharide = NutritionData["total_saccharide"].toString();

        nutrition = Nutrition(
            calories: double.parse(total_calories),
            carbs: double.parse(total_carb),
            protein: double.parse(total_protein),
            fats: double.parse(total_fat),
            sodium: double.parse(total_natrium),
            cholesterol: double.parse(total_cholesterol),
            sugars: double.parse(total_saccharide),
        );

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
  }

  Future<void> getFoodsNutrition(String foodName) async {
    // var url = 'http://127.0.0.1:8000/api/get_search_list/?item=${foodName}';
    var url = 'http://223.130.154.147:8080/api/get_search_list/?item=${foodName}';


    Dio dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.get(url, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("get UserNutrioton Success");
        // checkUploadToServerToast1();
        // print(response.data["data"]);

        var FoodNutritionData = response.data["data"]["items"][0];
        print("FoodNutritionData: $FoodNutritionData");

        String foodName = FoodNutritionData["식품명"].toString();
        String foodCalory = FoodNutritionData["에너지"].toString();
        String foodProtein = FoodNutritionData["단백질"].toString();
        String foodFat = FoodNutritionData["지방"].toString();
        String foodCarb = FoodNutritionData["탄수화물"].toString();
        String foodNatrium = FoodNutritionData["나트륨"].toString();
        String foodCholesterol = FoodNutritionData["콜레스테롤"].toString();
        String foodSugars = FoodNutritionData["총당류"].toString();
        // String foodSugars = '0';

        print("foodName: ${foodName}");
        print("foodCalory: ${foodCalory}");
        print("foodProtein: ${foodProtein}");
        print("foodFat: ${foodFat}");
        print("foodCarb: ${foodCarb}");
        print("foodNatrium: ${foodNatrium}");
        print("foodCholesterol: ${foodCholesterol}");
        print("foodSugars: ${foodSugars}");

          food = Food(
            name: foodName,
            calories: double.parse(foodCalory),
            carbs: double.parse(foodCarb),
            protein: double.parse(foodProtein),
            fats: double.parse(foodFat),
            sodium: double.parse(foodNatrium),
            cholesterol: double.parse(foodCholesterol),
            sugars: double.parse(foodSugars),
            // sugars: 0,
          );

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
  }

  Future<bool> postNutritionInfoFoodSearch(String foodName, String calories, String carb, String protein, String fat, String natrium, String cholesterol, String sugar) async{
    // var url = 'http://127.0.0.1:8000/api/get_ingestioninformation/';
    var url = 'http://223.130.154.147:8080/api/get_ingestioninformation/';

    bool _isSuccess = false;

    Dio dio = Dio();

    var data;

    data = {
      'name': foodName,
      'calories': calories,
      'carb': carb,
      'protein': protein,
      'fat': fat,
      'natrium': natrium,
      'cholesterol': cholesterol,
      'saccharide': sugar,
      //sugar는 지호가 API 업데이트 해주면 주석 풀기만 하면 됨.
    };

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.post(url, data: data, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Post FoodSearch send is seccess!");
        print(response.data);

        //메세지로 저장 잘 됐다. 라고 띄워줄거임
        checkPostNutritionManuallyToServerToast();
        _isSuccess = true;

      }
    } on DioError catch (e){//이게 catch 대신에 사용하는 DIo의 조금 더 구체적인 트러블 슈팅인듯
      if(e.response != null){
        //서버에서 응답 받았지만, 오류 상태 코드를 받은 경우
        print('Status code: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Headers: ${e.response?.headers}');
        _isSuccess = false;
      }else{
        //요청이 서버에 도달하지 못한 경우
        print('Error sending request!');
        print(e.message);
        _isSuccess = false;
      }
    }

    return _isSuccess;
  }

  Future<void> getDailyNutrition(DateTime Datedata) async {
    var userId = await storage.read(key: 'id');
    // var url = 'http://127.0.0.1:8080/api/get_dailyinformation/?id=3&date=2024-05-12';
    int month = Datedata.month;
    int day = Datedata.day;

    String monthStr;
    String dayStr;

    if(month < 10){
      monthStr = '0${month}';
    }else{
      monthStr = month.toString();
    }

    if(day < 10){
      dayStr = '0${day}';
    }else{
      dayStr = day.toString();
    }

    var url = 'http://223.130.154.147:8080/api/get_dailyinformation/?id=${userId}&date=${Datedata.year}-${monthStr}-${dayStr}';

    print(url);

    Dio dio = Dio();

    try{
      var useaccessToken = await storage.read(key: 'accessToken');
      Response response = await dio.get(url, options: Options(
        headers: {'Authorization': 'Bearer $useaccessToken',
          'Content-Type': 'application/json; '
              'charset=UTF-8',
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",},
      ),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("get DailyNutrition Get is Success");
        // checkUploadToServerToast1();
        // print(response.data["data"]);

        var DailyNutritionData = response.data["data"];
        print("FoodNutritionData: $DailyNutritionData");

        String total_calories = DailyNutritionData["total_calories"].toString();
        String total_carb = DailyNutritionData["total_carb"].toString();
        String total_protein = DailyNutritionData["total_protein"].toString();
        String total_fat = DailyNutritionData["total_fat"].toString();
        String total_natrium = DailyNutritionData["total_natrium"].toString();
        String total_cholesterol = DailyNutritionData["total_cholesterol"].toString();
        String total_saccharide = DailyNutritionData["total_saccharide"].toString();
        // String foodSugars = '0';

        dailyNutrition = DailyNutrition(
          calories: double.parse(total_calories),
          carbs: double.parse(total_carb),
          protein: double.parse(total_protein),
          fats: double.parse(total_fat),
          sodium: double.parse(total_natrium),
          cholesterol: double.parse(total_cholesterol),
          sugars: double.parse(total_saccharide),
        );
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
  }

}