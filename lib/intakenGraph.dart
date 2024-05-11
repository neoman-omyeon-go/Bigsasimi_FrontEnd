import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthInfoGraph extends StatefulWidget {
  @override
  _HealthInfoGraphState createState() => _HealthInfoGraphState();
}

class _HealthInfoGraphState extends State<HealthInfoGraph> {
  bool _isBarChart = true;  // 현재 표시 방식을 저장하는 상태

  // 예시 데이터
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(
      x: 0,
      barRods: [BarChartRodData(y: 70, colors: [Colors.lightBlue])],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [BarChartRodData(y: 85, colors: [Colors.orange])],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [BarChartRodData(y: 90, colors: [Colors.red])],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [BarChartRodData(y: 55, colors: [Colors.green])],
      showingTooltipIndicators: [0],
    ),
  ];

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
      body: _isBarChart ? _buildBarChart() : _buildList(),
    );
  }

  Widget _buildBarChart() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return '당뇨';
                  case 1:
                    return '비만';
                  case 2:
                    return '혈압';
                  case 3:
                    return '간';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                return value == 0 ? '0' : '${value.toInt()}';
              },
              interval: 500, // 각 라벨 사이의 간격을 500으로 설정
              reservedSize: 40, // Y축 라벨을 위한 공간 예약
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 500, // 수평 그리드 라인 간격을 500으로 설정
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipPadding: const EdgeInsets.all(0),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.y.round().toString(),
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildList() {
    List<String> categories = ['당뇨수치', '비만 수치', '혈압 수치', '간 수치'];
    List<int> values = [70, 85, 90, 55];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categories[index]),
          trailing: Text(values[index].toString()),
        );
      },
    );
  }
}
