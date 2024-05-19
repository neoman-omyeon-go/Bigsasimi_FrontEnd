import 'package:capstone/APIfile.dart';
import 'package:flutter/material.dart';
import 'Calander.dart';
import 'models/historydata.dart';

class dailyMealHistory extends StatefulWidget {
  final DateTime selectDate;
  dailyMealHistory({super.key, required this.selectDate});

  @override
  State<dailyMealHistory> createState() => _dailyMealHistoryState();
}

class _dailyMealHistoryState extends State<dailyMealHistory> {
  List<dynamic> historyData = [];
  bool isLoading = true;

  Future<void> initHistoryData() async {
    historyData = await allApi().getHistory(widget.selectDate);
    print('history: $historyData');
  }

  @override
  void initState() {
    super.initState();
    initHistoryData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Meal History'),
      ),
      body: ListView.builder(
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                'http://223.130.154.147:8080/${item['image_path']}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories: ${item['calories']}'),
                  Text('Carbs: ${item['carb']}g'),
                  Text('Protein: ${item['protein']}g'),
                  Text('Fat: ${item['fat']}g'),
                  Text('Natrium: ${item['natrium']}mg'),
                  Text('Saccharide: ${item['saccharide']}g'),
                  Text('Cholesterol: ${item['cholesterol']}mg'),
                  Text('Create Time: ${item['create_time'].substring(0,19)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
