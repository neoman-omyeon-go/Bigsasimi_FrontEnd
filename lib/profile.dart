import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  bool isEditMode = false;
  String userName = '';

  // Controllers for text fields
  final TextEditingController _sexController = TextEditingController(text: '');
  final TextEditingController _ageController = TextEditingController(text: '');
  final TextEditingController _heightController = TextEditingController(text: '');
  final TextEditingController _weightController = TextEditingController(text: '');
  final TextEditingController _chronicController = TextEditingController(text: '');
  final TextEditingController _allergiesController = TextEditingController(text: '');
  final TextEditingController _intakeController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditMode = !isEditMode;
                    });
                  },
                ),
                TextButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  onPressed: () {
                    print('Logout pressed');
                  },
                ),
              ],
            ),
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage('assets/default_profile_pic.png'),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                initialValue: userName,
                textAlign: TextAlign.center,
                enabled: isEditMode,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildTextField(_sexController, 'Sex', isEditMode),
                _buildTextField(_ageController, 'Age', isEditMode),
                _buildTextField(_heightController, 'Height', isEditMode),
                _buildTextField(_weightController, 'Weight', isEditMode),
              ],
            ),
            SizedBox(height: 50),
            _editableField(_chronicController, 'Chronic Illnesses', Colors.blue.shade100, isEditMode),
            SizedBox(height: 30),
            _editableField(_allergiesController, 'Allergies', Colors.pink.shade100, isEditMode),
            SizedBox(height: 30),
            _editableField(_intakeController, 'Desired Daily Intake', Colors.orange.shade100, isEditMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool isEditable) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          enabled: isEditable,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            disabledBorder: OutlineInputBorder( // 비활성화 상태에서 보이는 테두리 설정
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _editableField(TextEditingController controller, String label, Color backgroundColor, bool isEditable) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder( // 비활성화 상태에서 보이는 테두리 설정
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        maxLines: 3,
        minLines: 1,
      ),
    );
  }
}
