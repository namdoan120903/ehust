import 'package:flutter/material.dart';
import 'package:project/components/class_card.dart';
import 'package:project/screens/myAppBar.dart';

class AttendanceClassList extends StatelessWidget {
  final List<String> classIds;
  final String userRole;

  const AttendanceClassList({
    Key? key,
    required this.classIds,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: userRole == 'STUDENT' ? "EHUST-STUDENT" : "EHUST-LECTURER",
      ),
      body: classIds.isEmpty
          ? const Center(
              child: Text('Không có lớp học nào.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: classIds.length,
              itemBuilder: (context, index) {
                final classId = classIds[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClassCard(
                    classId: classId,
                    userRole: userRole,
                  ),
                );
              },
            ),
    );
  }
}
