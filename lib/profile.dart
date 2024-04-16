import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  bool isEditMode = false;

  // Create a text editing controller for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chronicIllnessController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _dailyIntakeController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _sexController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chronicIllnessController.dispose();
    _allergiesController.dispose();
    _dailyIntakeController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Save data logic
                toggleEditMode();
              },
            ),
          if (!isEditMode)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => toggleEditMode(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildEditableProfileItem(_nameController, 'User Name', 'User Name', Icons.person),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildEditableProfileItem(_sexController, 'Sex', 'Male', null, flex: 2),
                _buildEditableProfileItem(_ageController, 'Age', '25', null, flex: 2),
                _buildEditableProfileItem(_heightController, 'Height', '180cm', null, flex: 2),
                _buildEditableProfileItem(_weightController, 'Weight', '75kg', null, flex: 2),
              ],
            ),
            _buildEditableProfileItem(_chronicIllnessController, 'Chronic Illnesses', '', Icons.healing, isTextArea: true),
            _buildEditableProfileItem(_allergiesController, 'Allergies', '', Icons.warning, isTextArea: true),
            _buildEditableProfileItem(_dailyIntakeController, 'Desired daily intake', '', Icons.fastfood, isTextArea: true),
            if (isEditMode)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => toggleEditMode(),
                  child: Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableProfileItem(
      TextEditingController controller,
      String label,
      String placeholder,
      IconData? icon, {
        bool isTextArea = false,
        int flex = 1,
      }) {
    return Flexible(
      flex: flex,
      child: ListTile(
        title: isEditMode
            ? (isTextArea
            ? TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          minLines: 1,
          maxLines: 5,
        )
            : TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ))
            : Row(
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) SizedBox(width: 8),
            Text(placeholder, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}