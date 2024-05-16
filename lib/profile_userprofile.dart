import 'dart:io';

class UserProfile {
  File? image;
  String avatar;
  // String sex;
  // String age;
  // String height;
  // String weight;
  List<String> chronicIllnesses;
  List<String> allergies;
  String calorieIntake;
  String carbIntake;
  String proteinIntake;
  String fatIntake;
  String natriumIntake;

  UserProfile({
    // required this.sex,
    // required this.age,
    // required this.height,
    // required this.weight,
    required this.avatar,
    required this.chronicIllnesses,
    required this.allergies,
    required this.calorieIntake,
    required this.carbIntake,
    required this.proteinIntake,
    required this.fatIntake,
    required this.natriumIntake,
  });
}