import 'package:capstone/APIfile.dart';
import 'package:flutter/material.dart';

import 'Calander.dart';


class Nutrition {
  late double calories;
  late double carbs;
  late double protein;
  late double fats;
  late double sodium;
  late double cholesterol;
  late double sugars;

  static Map<String, double?> maxValues = {
    'Calories': double.parse(userProfile.calorieIntake),
    'Carbs': double.parse(userProfile.carbIntake),
    'Protein': double.parse(userProfile.proteinIntake),
    'Fats': double.parse(userProfile.fatIntake),
    'Sodium': double.parse(userProfile.natriumIntake),
    'Cholesterol': 200, // 그냥 이거는 상수로 박아 넣기로 했음(일일 권장 섭취 콜레스테롤로) 200mg이 권장 섭취량
    'Sugars': 30, // 이것도 상수로 박아 넣기로 했음(일일 권장 섭취 당류. 남, 여가 다르긴하나 평균으로 30g으로 설정.)
  };

  Map<String, dynamic> toMap() {
    return {
      'Calories': {'value': calories, 'span': 2},
      'Carbs': {'value': carbs, 'span': 1},
      'Protein': {'value': protein, 'span': 1},
      'Fats': {'value': fats, 'span': 1},
      'Sodium': {'value': sodium, 'span': 1},
      'Cholesterol': {'value': cholesterol, 'span': 1},
      'Sugars': {'value': sugars, 'span': 1},
    };
  }

  Nutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.sodium,
    required this.cholesterol,
    required this.sugars,
  });

}

class HealthInfoGraph extends StatefulWidget {
  @override
  _HealthInfoGraphState createState() => _HealthInfoGraphState();
}

class _HealthInfoGraphState extends State<HealthInfoGraph> {
  bool _isBarChart = true;
  // Nutrition nutrition = Nutrition(
  //     1800.0,
  //     250.0,
  //     120.0,
  //     80.0,
  //     1500.0,
  //     200.0,
  //     80.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 240),
            child: Text(
              'Today''s Nutrition. ',
              style: TextStyle(
                fontSize: 30, // 텍스트의 크기를 더 크게 변경합니다.
                fontWeight: FontWeight.bold, // 글씨체를 굵게 합니다.
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: <Widget>[
                Icon(
                  Icons.report, // 느낌표 아이콘
                  color: Color.fromRGBO(90,154,68,1.0),
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 사이에 간격 추가
                Expanded( // 텍스트가 화면 너비를 벗어나지 않도록 Expanded 위젯을 사용합니다.
                  child: Text(
                    'Please Upload your Nutrition',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(_isBarChart ? Icons.bar_chart : Icons.list),
                  onPressed: () {
                    setState(() {
                      _isBarChart = !_isBarChart;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isBarChart ? _buildBarChart() : buildNutritionDashboard(
                nutrition),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 500, // Fixed height to control the area of the bars
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.blueAccent),
              // borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _createBars(nutrition),
              ),
            ),
          ),
        ),
        SizedBox(height: 16), // Spacing between the box and the text below it
        Expanded(
          child: GestureDetector(
            onTap: () {
              // 터치 시 다른 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen()), // YourNextScreen을 원하는 화면으로 변경하세요.
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백을 설정합니다.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정합니다.
                child: Container(
                  color: Colors.grey[200], // 구역의 배경색을 설정합니다.
                  padding: EdgeInsets.all(16), // 내부 패딩을 설정합니다.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 방향으로 꽉 채우도록 설정합니다.
                    children: [
                      Text(
                        '월 별 건강정보 기록지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center, // 텍스트를 중앙 정렬합니다.
                      ),
                      // 추가 콘텐츠를 여기에 추가할 수 있습니다.
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }




  List<Widget> _createBars(Nutrition nutrition) {
    Map<String, double?> nutrientValues = {
      'Calories': nutrition.calories,
      'Carbs': nutrition.carbs,
      'Protein': nutrition.protein,
      'Fats': nutrition.fats,
      'Sodium': nutrition.sodium,
      'Cholesterol': nutrition.cholesterol,
      'Sugars': nutrition.sugars,
    };

    List<Widget> bars = [];
    nutrientValues.forEach((label, value) {
      double max = Nutrition.maxValues[label]!;
      double percentage;
      if (max == 0) { // max가 0일 경우 처리
        percentage = 0.0; // 0으로 설정하여 NaN 상황 방지
      } else {
        percentage = value! / max * 100; // 실제 백분율 계산
      }
      bool isExceeded = percentage > 100; // 백분율이 100%를 초과하는지 확인

      bars.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$label ", // 레이블
                      style: TextStyle(fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    TextSpan(
                      text: "${value!.toStringAsFixed(1)}", // 값
                      style: TextStyle(fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%", // 실제 계산된 백분율
                style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isExceeded ? Colors.red : Colors.blueGrey), // 백분율이 100%를 초과하면 빨간색, 아니면 파란색
              ),
            ],
          ),
          SizedBox(height: 4), // 레이블과 막대 사이 공간
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10) // 배경의 둥근 모서리
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage.clamp(0, 100) / 100, // 막대의 최대 너비 100%로 제한
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: isExceeded ? [Colors.red, Colors.redAccent] : [Colors.blue, Colors.green], // 초과 시 빨간색 그라데이션, 아니면 파랑-녹색
                    ),
                    borderRadius: BorderRadius.circular(10), // 채워진 부분의 둥근 모서리
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // 막대 사이 공간
        ],
      ));
    });
    return bars;
  }

  Widget buildNutritionDashboard(Nutrition nutrition) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNutritionRow(['Carbs', 'Protein'], [nutrition.carbs!, nutrition.protein!], [1, 1],
              [Color.fromRGBO(252, 250, 231, 1.0), Color.fromRGBO(236, 249, 237, 1.0)], [Color.fromRGBO(219, 187, 104, 1.0), Color.fromRGBO(66, 201, 80, 1.0)]),
          _buildNutritionRow(['Fats', 'Cholesterol'], [nutrition.fats!, nutrition.cholesterol!], [1, 1],
              [Color.fromRGBO(250, 236, 240, 1.0), Color.fromRGBO(240, 236, 249, 1.0)], [Color.fromRGBO(210, 65, 110, 1.0), Color.fromRGBO(112, 66, 201, 1.0)]),
          _buildNutritionRow(['Sodium', 'Sugars'], [nutrition.sodium!, nutrition.sugars!], [1, 1],
              [Color.fromRGBO(230, 247, 246, 1.0), Color.fromRGBO(252, 243, 231, 1.0)], [Color.fromRGBO(13, 177, 173, 1.0), Color.fromRGBO(240, 146, 72, 1.0)]),
          _buildNutritionRow(['Calories'], [nutrition.calories!], [2],
              [Color.fromRGBO(232, 241, 250, 1.0)], [Color.fromRGBO(25, 123, 210, 1.0)]), // span이 2일 경우
        ],
      ),
    );
  }

  Widget _buildNutritionRow(List<String> titles, List<double> values, List<int> spans, List<Color> colors, List<Color> textColors) {
    assert(titles.length == values.length && titles.length == spans.length && titles.length == colors.length);

    return Row(
      children: List.generate(titles.length, (index) {
        return Expanded(
          flex: spans[index],
          child: _buildNutritionItem(titles[index], values[index], colors[index], textColors[index]),
        );
      }),
    );
  }

  Widget _buildNutritionItem(String title, double value, Color color, Color textColor) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: color,
      height: 150, // 세로 길이를 조정하여 높이를 높임
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: textColor),
              ),
              SizedBox(height: 8.0),
              Text(
                value.toString(),
                style: TextStyle(fontSize: 19.0),
              ),
            ],
          ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Text(
              '${value.toString()} / ${Nutrition.maxValues['${title}']}',
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

}
