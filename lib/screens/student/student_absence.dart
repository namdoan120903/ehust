import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/provider/AbsenceProvider.dart';
import 'package:project/screens/student/student_absence_create.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../model/Class.dart';
import '../myAppBar.dart';

class StudentAbsence extends StatefulWidget {
  final Class classA;
  StudentAbsence({required this.classA});

  @override
  State<StudentAbsence> createState() => _StudentAbsenceState();
}

class _StudentAbsenceState extends State<StudentAbsence> {
  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    absenceProvider.getAllAbsenceStudent(context, widget.classA.classId!);
  }

  @override
  Widget build(BuildContext context) {
    final absenceProvider = Provider.of<AbsenceProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '${widget.classA.classId} - ${widget.classA.className} - ${widget.classA.classType} ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text("Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.classA.startDate!))}"),
                  Text("Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.classA.endDate!))}"),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Danh sách Đơn xin nghỉ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentAbsenceCreate(classId: widget.classA.classId,)));
                  },
                  tooltip: 'Thêm bài tập mới',
                  color: Colors.red,
                ),
              ],
            ),absenceProvider.isLoading?Center(child: CircularProgressIndicator()):Expanded(child:
            ListView.builder(
              itemCount: absenceProvider.absences.length,
              itemBuilder: (context, index) {
                final absence = absenceProvider.absences[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    onTap: (){
                      print(absence.fileUrl);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleDriveViewer(
                              driveUrl: absence.fileUrl!
                          ),
                        ),
                      );
                    },
                    title: Text('${absence.title!}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Mô tả: ${absence.reason}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Trạng thái: ${absence.status}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Thời gian: ${absence.absenceDate}', // Văn bản bổ sung
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
