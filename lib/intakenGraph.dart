import 'package:flutter/material.dart';

class Nutrition {
  double calories;
  double carbs;
  double protein;
  double fats;
  double sodium;
  double cholesterol;
  double sugars;

  static const Map<String, double> maxValues = {
    'Calories': 2000,
    'Carbs': 300,
    'Protein': 150,
    'Fats': 100,
    'Sodium': 2400,
    'Cholesterol': 300,
    'Sugars': 100,
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

  Nutrition(this.calories, this.carbs, this.protein, this.fats, this.sodium, this.cholesterol, this.sugars);
}

class HealthInfoGraph extends StatefulWidget {
  @override
  _HealthInfoGraphState createState() => _HealthInfoGraphState();
}

class _HealthInfoGraphState extends State<HealthInfoGraph> {
  bool _isBarChart = true;
  Nutrition nutrition = Nutrition(
      1800.0,
      250.0,
      120.0,
      80.0,
      1500.0,
      200.0,
      80.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
        Text("Detailed nutritional values displayed here",
            style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  List<Widget> _createBars(Nutrition nutrition) {
    Map<String, double> nutrientValues = {
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
      double percentage = value / max * 100;
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
                      text: "$value", // 값
                      style: TextStyle(fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%", // 백분율
                style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ],
          ),
          SizedBox(height: 4), // Space between label and bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                        10) // Rounded corners for the background
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blue, Colors.green], // 시작색과 끝색 지정
                    ),
                    borderRadius: BorderRadius.circular(
                        10), // Rounded corners for the filled part
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Space between bars
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
          _buildNutritionRow(['Carbs', 'Protein'], [nutrition.carbs, nutrition.protein], [1, 1],
              [Color.fromRGBO(252, 250, 231, 1.0), Color.fromRGBO(236, 249, 237, 1.0)], [Color.fromRGBO(219, 187, 104, 1.0), Color.fromRGBO(66, 201, 80, 1.0)]),
          _buildNutritionRow(['Fats', 'Cholesterol'], [nutrition.fats, nutrition.cholesterol], [1, 1],
              [Color.fromRGBO(250, 236, 240, 1.0), Color.fromRGBO(240, 236, 249, 1.0)], [Color.fromRGBO(210, 65, 110, 1.0), Color.fromRGBO(112, 66, 201, 1.0)]),
          _buildNutritionRow(['Sodium', 'Sugars'], [nutrition.sodium, nutrition.sugars], [1, 1],
              [Color.fromRGBO(230, 247, 246, 1.0), Color.fromRGBO(252, 243, 231, 1.0)], [Color.fromRGBO(13, 177, 173, 1.0), Color.fromRGBO(240, 146, 72, 1.0)]),
          _buildNutritionRow(['Calories'], [nutrition.calories], [2],
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
