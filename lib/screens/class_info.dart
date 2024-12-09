import 'package:flutter/material.dart';
import 'package:project/model/Class.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

class ClassInfo extends StatefulWidget {

  @override
  State<ClassInfo> createState() => _ClassInfoState();
}

class _ClassInfoState extends State<ClassInfo> {


  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    Class? classModel = classProvider.getClassLecturer;
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST"),
      body:classProvider.isLoading?Center(child: CircularProgressIndicator()): ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              // Thông tin lớp học
              Text(
                "Tên lớp: ${classModel?.className}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Mã lớp: ${classModel?.classId}"),
              Text("Loại lớp: ${classModel?.classType}"),
              Text("Giảng viên: ${classModel?.lecturerName}"),
              Text("Số sinh viên: ${classModel?.studentCount}"),
              Text("Ngày bắt đầu: ${classModel?.startDate}"),
              Text("Ngày kết thúc: ${classModel?.endDate}"),
              Text("Trạng thái: ${classModel?.status}"),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              // Danh sách sinh viên
              Text(
                "Danh Sách Sinh Viên",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: classModel?.studentAccounts?.length,
                itemBuilder: (context, index) {
                  final student = classModel?.studentAccounts?[index];
                  return Card(
                    child: ListTile(
                      title: Text("${student?.firstName} ${student?.lastName}"),
                      subtitle: Text("Email: ${student?.email}"),
                      trailing: Text("MSSV: ${student?.studentId}"),
                    ),
                  );
                },
              ),
            ],
          ));
  }
}
