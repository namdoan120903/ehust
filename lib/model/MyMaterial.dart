class MyMaterial {
  int? id;
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
        this.materialLink,
        this.materialType});

  MyMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    materialName = json['material_name'];
    description = json['description'];
    materialLink = json['material_link'];
    materialType = json['material_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['material_name'] = this.materialName;
    data['description'] = this.description;
    data['material_link'] = this.materialLink;
    data['material_type'] = this.materialType;
    return data;
  }
}