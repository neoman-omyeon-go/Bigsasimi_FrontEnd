import 'package:capstone/APIfile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dailyNutritionInfo.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  Future<Map<String, String>>? _dataFuture;

  final List<int> _years = List.generate(5, (index) => DateTime.now().year - index);
  final List<int> _months = List.generate(12, (index) => index + 1);

  final List<String> cardTitles = [
    '운동도 함께 관리하세요',
    '식단',
    '수면 관리',
    '마음 건강'
  ];

  Future<Map<String, String>> fetchDataForDate(DateTime date) async {
    await Future.delayed(Duration(seconds: 2)); // API 호출 시뮬레이션을 위해 지연을 추가합니다.
    return {
      '운동도 함께 관리하세요': '애플헬스 운동 데이터 불러오기',
      '식단': '${dailyNutrition.calories} kcal\n탄 ${dailyNutrition.carbs}%  단 ${dailyNutrition.protein}%  지 ${dailyNutrition.fats}%',
      '수면 관리': '수면 데이터 불러오기',
      '마음 건강': '마음 건강 데이터 불러오기',
    };
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchDataForDate(_selectedDate);
    allApi().getDailyNutrition(_selectedDate);
  }

  void _onDateSelected(int day) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
      _dataFuture = fetchDataForDate(_selectedDate);
      allApi().getDailyNutrition(_selectedDate);
    });
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
      _dataFuture = fetchDataForDate(_selectedDate);
      allApi().getDailyNutrition(_selectedDate);
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
      _dataFuture = fetchDataForDate(_selectedDate);
      allApi().getDailyNutrition(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 245, 235, 1.0), // 상단 배경색을 설정합니다.
        elevation: 0,
        title: Text(
          'Nutrition Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Color.fromRGBO(238, 245, 235, 1.0), // 상단 배경색을 설정합니다.
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: _selectedDate.year,
                        items: _years.map((int year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              '$year년',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 수정
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            _onYearSelected(newValue);
                          }
                        },
                      ),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _selectedDate.month,
                        items: _months.map((int month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              '$month월',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 수정
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            _onMonthSelected(newValue);
                          }
                        },
                        itemHeight: 48, // 각 항목의 높이 설정
                        menuMaxHeight: 240, // 드롭다운의 최대 높이 설정 (5개의 항목)
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day,
                            (index) {
                          int day = index + 1;
                          return GestureDetector(
                            onTap: () {
                              _onDateSelected(day);
                            },
                            child: Container(
                              width: 60, // 날짜의 크기를 크게 설정합니다.
                              height: 60, // 날짜의 크기를 크게 설정합니다.
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: _selectedDate.day == day
                                    ? Colors.black
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: _selectedDate.day == day
                                      ? Color(0xFF6F35A5)
                                      : Colors.black,
                                  fontSize: 24, // 날짜 텍스트 크기를 크게 설정합니다.
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<Map<String, String>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류가 발생했습니다.'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('데이터가 없습니다.'));
                } else {
                  var data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: cardTitles.map((title) {
                        IconData icon;
                        String subtitle2 = '';
                        ElevatedButton? button;
                        Widget? extraWidget;

                        // title에 따라 icon과 subtitle2 및 button, extraWidget 설정
                        switch (title) {
                          case '운동도 함께 관리하세요':
                            icon = Icons.local_fire_department;
                            subtitle2 = '10초만에 간편 운동';
                            button = ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF6F35A5), // 버튼 색상
                              ),
                              child: Text(
                                '운동 버튼',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            break;
                          case '식단':
                            icon = Icons.restaurant;
                            subtitle2 = '식단임 ㅇㅇ';
                            extraWidget = _buildBarChart();
                            button = ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF6F35A5), // 버튼 색상
                              ),
                              child: Text(
                                '식단 버튼',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            break;
                          case '수면 관리':
                            icon = Icons.bedtime;
                            subtitle2 = '수면 데이터 보기';
                            button = ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF6F35A5), // 버튼 색상
                              ),
                              child: Text(
                                '수면 버튼',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            break;
                          case '마음 건강':
                            icon = Icons.self_improvement;
                            subtitle2 = '마음 건강 체크';
                            button = ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF6F35A5), // 버튼 색상
                              ),
                              child: Text(
                                '마음 건강 버튼',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            break;
                          default:
                            icon = Icons.info;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildCard(
                            title,
                            icon,
                            data[title]!,
                            subtitle2,
                            _selectedDate,
                            button,
                            extraWidget,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title,
      IconData icon,
      String subtitle1,
      String subtitle2,
      DateTime selectedDate,
      ElevatedButton? button,
      Widget? extraWidget,
      ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정합니다.
      child: Container(
        color: Colors.grey[200], // 구역의 배경색을 설정합니다.
        padding: EdgeInsets.all(16), // 내부 패딩을 설정합니다.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '날짜: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, color: Color(0xFF6F35A5), size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle1),
                    if (subtitle2.isNotEmpty)
                      Text(
                        subtitle2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ],
            ),
            if (extraWidget != null) extraWidget,
            if (button != null)
              SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: button,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final maxY = [
      dailyNutrition.calories.isFinite ? dailyNutrition.calories : 0,
      dailyNutrition.carbs.isFinite ? dailyNutrition.carbs : 0,
      dailyNutrition.protein.isFinite ? dailyNutrition.protein : 0,
      dailyNutrition.fats.isFinite ? dailyNutrition.fats : 0,
      dailyNutrition.sodium.isFinite ? dailyNutrition.sodium : 0,
      dailyNutrition.cholesterol.isFinite ? dailyNutrition.cholesterol : 0,
      dailyNutrition.sugars.isFinite ? dailyNutrition.sugars : 0,
    ].reduce((a, b) => a > b ? a : b).toDouble();  // Here we convert to double

    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: CustomPaint(
        painter: BarChartPainter(dailyNutrition, maxY),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final double maxY;

  BarChartPainter(dailyNutrition, this.maxY);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / 14;
    final barPaint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final data = [
      dailyNutrition.calories.isFinite ? dailyNutrition.calories : 0,
      dailyNutrition.carbs.isFinite ? dailyNutrition.carbs : 0,
      dailyNutrition.protein.isFinite ? dailyNutrition.protein : 0,
      dailyNutrition.fats.isFinite ? dailyNutrition.fats : 0,
      dailyNutrition.sodium.isFinite ? dailyNutrition.sodium : 0,
      dailyNutrition.cholesterol.isFinite ? dailyNutrition.cholesterol : 0,
      dailyNutrition.sugars.isFinite ? dailyNutrition.sugars : 0,
    ];

    for (int i = 0; i < data.length; i++) {
      final barHeight = ((data[i] / maxY).isFinite ? (data[i] / maxY) : 0) * size.height;
      final x = i * 2 * barWidth;
      final y = size.height - barHeight;
      if (!barHeight.isNaN) {
        canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), barPaint);
      }
    }

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final labels = [
      'Calories',
      'Carbs',
      'Protein',
      'Fats',
      'Sodium',
      'Cholesterol',
      'Sugars'
    ];

    for (int i = 0; i < labels.length; i++) {
      final x = i * 2 * barWidth + barWidth / 2;
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DailyNutrition {
  double calories;
  double carbs;
  double protein;
  double fats;
  double sodium;
  double cholesterol;
  double sugars;

  DailyNutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.sodium,
    required this.cholesterol,
    required this.sugars,
  });
}
