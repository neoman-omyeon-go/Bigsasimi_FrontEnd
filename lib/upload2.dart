import 'package:flutter/material.dart';

class upload2 extends StatefulWidget {
  const upload2({super.key});

  @override
  State<upload2> createState() => _upload2stfState();
}

class _upload2stfState extends State<upload2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Upload2 page'),
      ),
    );
  }
}


