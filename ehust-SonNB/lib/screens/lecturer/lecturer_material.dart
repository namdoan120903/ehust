import 'package:flutter/material.dart';
import 'package:project/provider/MaterialProvider.dart';
import 'package:project/screens/lecturer/create_material.dart';
import 'package:project/screens/lecturer/edit_material.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../model/Class.dart';
import '../myAppBar.dart';

class LecturerMaterial extends StatefulWidget {
  final Class classA;
  LecturerMaterial({required this.classA});

  @override
  State<LecturerMaterial> createState() => _LecturerMaterialState();
}

class _LecturerMaterialState extends State<LecturerMaterial> {

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final materialProvider = Provider.of<MaterialProvider>(context, listen: false);
    materialProvider.getAllMaterial(context, widget.classA.classId!);
    print(materialProvider.materials.toString());
  }

  void _showDeleteDialog(BuildContext context,MaterialProvider materialProvider, String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác Nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa mục này không?'),
          actions: [
            // Nút "Không"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Không'),
            ),
            // Nút "Có"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                materialProvider.deleteMaterial(context, id, index);
                print('Mục đã bị xóa');
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                '${widget.classA.classId} - ${widget.classA.className} - ${widget.classA.classType} ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Danh sách Tài liệu',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateMaterial(classId: widget.classA.classId,)));
                  },
                  tooltip: 'Thêm bài tập mới',
                  color: Colors.red,
                ),
              ],
            ),Expanded(child:
            ListView.builder(
              itemCount: materialProvider.materials.length,
              itemBuilder: (context, index) {
                final material = materialProvider.materials[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    onTap: (){
                      print(material.materialLink);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleDriveViewer(
                            driveUrl: material.materialLink!
                          ),
                        ),
                      );
                    },
                    title: Text('${material.materialName!}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Mô tả: ${material.description}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'File: ${material.materialType}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditMaterial(material: material, index: index,)));
                            }
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteDialog(context, materialProvider, material.id!, index);
                            }
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),)
          ],
        ),
      ),
    );
  }
}
