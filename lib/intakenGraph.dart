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
        title: Text('사용자 건강 정보'),
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
            padding: const EdgeInsets.all(16.0),
            child: Text("Today's Intake Nutrition", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent)),
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
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: nutritionCard('Carbs', nutrition.carbs, 'g'),
              ),
              Expanded(
                child: nutritionCard('Protein', nutrition.protein, 'g'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: nutritionCard('Fats', nutrition.fats, 'g'),
              ),
              Expanded(
                child: nutritionCard('Sodium', nutrition.sodium, 'mg'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: nutritionCard('Cholesterol', nutrition.cholesterol, 'mg'),
              ),
              Expanded(
                child: nutritionCard('Sugars', nutrition.sugars, 'g'),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          child: Center(
            child: Text(
              'Calories: ${nutrition.calories.toStringAsFixed(0)} kcal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget nutritionCard(String nutrient, double value, String unit) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.lightGreen[100], // 카드의 배경색 지정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(nutrient, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('$value $unit', style: TextStyle(fontSize: 14))
        ],
      ),
    );
  }
}
