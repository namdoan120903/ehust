import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../model/Class.dart';
import '../../provider/AbsenceProvider.dart';
import '../myAppBar.dart';

class LecturerAbsence extends StatefulWidget {
  final Class classA;
  LecturerAbsence({required this.classA});

  @override
  State<LecturerAbsence> createState() => _LecturerAbsenceState();
}

class _LecturerAbsenceState extends State<LecturerAbsence> {
  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    absenceProvider.getAllAbsenceLecturer(context, widget.classA.classId!);
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
              child: Text(
                '${widget.classA.classId} - ${widget.classA.className} - ${widget.classA.classType} ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
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
                          'Sinh viên: ${absence.studentAccount!.firstName} ${absence.studentAccount!.lastName}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Email: ${absence.studentAccount!.email}', // Văn bản bổ sung
                          style: TextStyle(color: Colors.grey),
                        ),
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
                        ElevatedButton(
                          onPressed: () {
                            // Hiển thị pop-up để chấm điểm
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String selectedStatus = absence.status!;

                                return AlertDialog(
                                  title: Text('Trạng thái của đơn '),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        value: selectedStatus,
                                        items: [
                                          DropdownMenuItem(value: "PENDING", child: Text("PENDING")),
                                          DropdownMenuItem(value: "ACCEPTED", child: Text("ACCEPTED")),
                                          DropdownMenuItem(value: "REJECTED", child: Text("REJECTED")),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value!;
                                            print(selectedStatus);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Trạng thái',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Hủy'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        absenceProvider.reviewAbsence(context, absence.id.toString(), selectedStatus, widget.classA.classId!);
                                      },
                                      child: Text('Cập nhật'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Cập nhật'),
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
