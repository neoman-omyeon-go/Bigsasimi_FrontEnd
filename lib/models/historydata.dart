class historyNutrition{
  late String id;
  late String create_time;
  late String image_path;
  late String name;
  late String calories;
  late String carb;
  late String protein;
  late String fat;
  late String natrium;
  late String saccharride;
  late String cholesterol;
  late int userprofile;

  historyNutrition({
    required this.id,
    required this.create_time,
    required this.image_path,
    required this.name,
    required this.calories,
    required this.carb,
    required this.protein,
    required this.fat,
    required this.natrium,
    required this.saccharride,
    required this.cholesterol,
    required this.userprofile,
  });

  historyNutrition.fromMap(Map<String, dynamic>? map){
    id = map?['id']?? '';
    create_time = map?['create_time']??'';
    image_path = map?['image_path']??'';
    name = map?['map']??'';
    calories = map?['calories']??'';
    carb = map?['carb']??'';
    protein = map?['protein']??'';
    fat = map?['fat']??'';
    natrium = map?['natrium']??'';
    saccharride = map?['saccharride']??'';
    cholesterol = map?['cholesterol']??'';
    userprofile = map?['userprofile']??'';
  }
}