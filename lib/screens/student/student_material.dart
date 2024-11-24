import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../model/Class.dart';
import '../../provider/MaterialProvider.dart';
import '../myAppBar.dart';

class StudentMaterial extends StatefulWidget {
  final Class classA;
  StudentMaterial({required this.classA});

  @override
  State<StudentMaterial> createState() => _StudentMaterialState();
}

class _StudentMaterialState extends State<StudentMaterial> {

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final materialProvider = Provider.of<MaterialProvider>(context, listen: false);
    materialProvider.getAllMaterial(context, widget.classA.classId!);
    print(materialProvider.materials.toString());
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
