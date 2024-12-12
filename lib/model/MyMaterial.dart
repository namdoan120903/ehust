class MyMaterial {
  String? id;
  String? classId;
  String? materialName;
  String? description;
  String? materialLink;
  String? materialType;

  MyMaterial(
      {this.id,
        this.classId,
        this.materialName,
        this.description,
        this.materialLink="",
        this.materialType});

  MyMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    materialName = json['material_name'];
    description = json['description'];
    materialLink = json['material_link'];
    materialType = json['material_type'];
  }
}