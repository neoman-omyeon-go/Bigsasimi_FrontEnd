import 'package:flutter/material.dart';
import 'dart:async';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  Future<Map<String, String>>? _dataFuture;

  final List<int> _years = List.generate(5, (index) => DateTime.now().year - index);
  final List<int> _months = List.generate(12, (index) => index + 1);

  Future<Map<String, String>> fetchDataForDate(DateTime date) async {
    // 여기에 실제 API 호출 코드를 작성하십시오.
    await Future.delayed(Duration(seconds: 2)); // API 호출 시뮬레이션을 위해 지연을 추가합니다.
    return {
      'exerciseData': '애플헬스 운동 데이터 불러오기',
      'dietData': '0 kcal\n탄 0%  단 0%  지 0%',
    };
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchDataForDate(_selectedDate);
  }

  void _onDateSelected(int day) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
      _dataFuture = fetchDataForDate(_selectedDate);
    });
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
      _dataFuture = fetchDataForDate(_selectedDate);
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
      _dataFuture = fetchDataForDate(_selectedDate);
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
                      children: [
                        _buildCard(
                          '운동도 함께 관리하세요',
                          Icons.local_fire_department,
                          data['exerciseData']!,
                          '10초만에 간편 운동',
                          _selectedDate,
                        ),
                        SizedBox(height: 16),
                        _buildCard(
                          '식단',
                          Icons.restaurant,
                          data['dietData']!,
                          '',
                          _selectedDate,
                        ),
                      ],
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
            if (title == '운동도 함께 관리하세요')
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF6F35A5), // 버튼 색상
                  ),
                  child: Text(
                    '10초만에 간편 운동',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
