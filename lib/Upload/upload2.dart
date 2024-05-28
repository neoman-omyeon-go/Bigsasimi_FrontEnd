import 'package:capstone/APIfile.dart';
import 'package:flutter/material.dart';
import '../intakenGraph/intakenGraph.dart';
import '../profile/profile.dart';

class upload2 extends StatefulWidget {
  const upload2({super.key});

  @override
  State<upload2> createState() => _upload2stfState();
}

class _upload2stfState extends State<upload2> {
  final _formKey = GlobalKey<FormState>();

  // 폼 필드를 위한 컨트롤러들
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  @override
  void dispose() {
    // 컨트롤러들을 dispose하여 리소스 누수 방지
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _sodiumController.dispose();
    _cholesterolController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, right: 240),
                  child: Text(
                    'Record your DIET.',
                    style: TextStyle(
                      fontSize: 30, // 텍스트의 크기를 더 크게 변경합니다.
                      fontWeight: FontWeight.bold, // 글씨체를 굵게 합니다.
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Calories(Kcal)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: 'Carbohydrates(g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _proteinsController,
                decoration: InputDecoration(labelText: 'Proteins(g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _fatsController,
                decoration: InputDecoration(labelText: 'Fats(g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _sodiumController,
                decoration: InputDecoration(labelText: 'Sodium(mg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _cholesterolController,
                decoration: InputDecoration(labelText: 'Cholesterol(mg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // 추가된 공간
              TextFormField(
                controller: _sugarController,
                decoration: InputDecoration(labelText: 'Sugars(g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 40), // Submit 버튼 전에 추가된 공간
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print('Data saved');
                    String calories = _caloriesController.text;
                    String carbs = _carbsController.text;
                    String proteins = _proteinsController.text;
                    String fats = _fatsController.text;
                    String natriums = _sodiumController.text;
                    String cholesterols = _cholesterolController.text;
                    String sugars = _sugarController.text;

                    bool isSuccessManuallyAPI = await allApi().postNutritionInfoManually(calories, carbs, proteins, fats, natriums, cholesterols, sugars);

                    nutrition = Nutrition(
                        calories: nutrition.calories + double.parse(calories),
                        carbs: nutrition.carbs + double.parse(carbs),
                        protein: nutrition.protein + double.parse(proteins),
                        fats: nutrition.fats + double.parse(fats),
                        sodium: nutrition.sodium + double.parse(natriums),
                        cholesterol: nutrition.cholesterol + double.parse(cholesterols),
                        sugars: nutrition.sugars + double.parse(sugars),
                    );
                    
                    // allApi().getFoodsNutrition("햄김치찌개"); //test용 ㅇㅇ

                    if(isSuccessManuallyAPI){
                      if(context.mounted){
                        //비동기 코드에서 BuildContext를 바로 쓰지 말라는 의미 같음. 그래서 mounted로 체크해주고 실행하려는거 같음.
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('Send To Server!'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 버튼의 사각형 모양
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 내부 여백
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(237, 118, 81, 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



