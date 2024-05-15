import 'package:flutter/material.dart';
import 'foodList.dart';  // 필요한 내용이 포함된 전제된 foodList.dart 파일
import 'food.dart';
import 'APIfile.dart';
import 'intakenGraph.dart';


class FoodSearch extends StatefulWidget {
  const FoodSearch({super.key});

  @override
  State<FoodSearch> createState() => _FoodSearchState();
}

class _FoodSearchState extends State<FoodSearch> {
  TextEditingController searchController = TextEditingController();
  List<String> allFoods = allFood;
  List<String> filteredFoods = [];
  Map<String, bool> checked = {};  // 체크 상태를 관리하기 위한 Map

  @override
  void initState() {
    super.initState();
    filteredFoods = allFoods.length >= 10 ? allFoods.sublist(0, 10) : allFoods;
    // 모든 음식에 대해 체크 상태 초기화
    allFoods.forEach((food) {
      checked[food] = false;
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = allFoods.where((item) {
        return item.contains(query);
      }).toList();
      if (dummyListData.length > 20) {
        dummyListData = dummyListData.sublist(0, 20);
      }
      setState(() {
        filteredFoods = dummyListData;
      });
    } else {
      setState(() {
        filteredFoods = allFoods.length >= 20 ? allFoods.sublist(0, 20) : allFoods;
      });
    }
  }

  void showFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${food.name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7, // 다이얼로그의 가로 크기 설정
            height: MediaQuery.of(context).size.height * 0.5, // 다이얼로그의 세로 크기 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '1. 칼로리: ${food.calories} kcal',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.grain, color: Colors.brown, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '2. 탄수화물: ${food.carbs} g',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '3. 단백질: ${food.protein} g',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.fastfood, color: Colors.yellow.shade900, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '4. 지방: ${food.fats} g',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.rounded_corner, color: Colors.blue, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '5. 나트륨: ${food.sodium} mg',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.opacity, color: Colors.purple, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '6. 콜레스테롤: ${food.cholesterol} mg',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.cake, color: Colors.pink, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '7. 당류: ${food.sugars} g',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Text(
                  "확인 버튼을 누르면, 영양정보가 업로드됩니다.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              onPressed: () async{
                // 여기에 영양정보 업로드 로직을 추가할 수 있습니다.

                print(food.calories);
                bool isSuccessManuallyAPI = await allApi().postNutritionInfoFoodSearch(
                    food.name,
                    food.calories.toString(),
                    food.carbs.toString(),
                    food.protein.toString(),
                    food.fats.toString(),
                    food.sodium.toString(),
                    food.cholesterol.toString(),
                    food.sugars.toString(),
                );

                if(isSuccessManuallyAPI){
                  nutrition = Nutrition(
                    calories: nutrition.calories + food.calories,
                    carbs: nutrition.carbs + food.carbs,
                    protein: nutrition.protein + food.protein,
                    fats: nutrition.fats + food.fats,
                    sodium: nutrition.sodium + food.sodium,
                    cholesterol: nutrition.cholesterol + food.cholesterol,
                    sugars: nutrition.sugars + food.sugars,
                  );
                  if(context.mounted){
                    //비동기 코드에서 BuildContext를 바로 쓰지 말라는 의미 같음. 그래서 mounted로 체크해주고 실행하려는거 같음.
                    Navigator.pop(context);
                  }
                }
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 240),
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
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                labelText: "검색",
                hintText: "음식을 검색하세요",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),  // 내부 스크롤 동작 방지
            itemCount: filteredFoods.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredFoods[index]),
                onTap: () async{
                  await allApi().getFoodsNutrition(filteredFoods[index]);
                  showFoodDialog(context);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),  // 각 아이템을 구분하기 위한 구분선
          ),
        ],
      ),
    );
  }
}
