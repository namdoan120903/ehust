import 'package:flutter/material.dart';
import 'package:project/Constant.dart';
import 'package:project/model/Survey.dart';
import 'package:project/provider/NotificationProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../provider/SurveyProvider.dart';

class SurveyClassList extends StatefulWidget {
  final Survey? survey;
  SurveyClassList({required this.survey});

  @override
  State<SurveyClassList> createState() => _SurveyClassListState();
}

class _SurveyClassListState extends State<SurveyClassList> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Lấy instance của SurveyProvider mà không lắng nghe các thay đổi
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.get_survey_response(context, widget.survey!.id.toString());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    // Lọc danh sách "Chưa chấm" và "Đã chấm" chỉ một lần
    final notGradedSubmissions = surveyProvider.submissions.where((submission) => submission.grade == null).toList();
    final gradedSubmissions = surveyProvider.submissions.where((submission) => submission.grade != null).toList();

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.survey!.classId} - ${widget.survey!.title}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                '${widget.survey!.deadline}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                '${widget.survey!.description}',
                style: TextStyle(fontSize: 20),
              ),
              // Link Google Drive ở đây
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleDriveViewer(driveUrl: widget.survey!.fileUrl!),
                    ),
                  );
                },
                child: Text(
                  'Mở tài liệu hướng dẫn',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Chưa chấm"),
              Tab(text: "Đã chấm"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab "Chưa chấm"
                notGradedSubmissions.isEmpty
                    ? Center(child: Text('Không có submission nào chưa chấm'))
                    : ListView.builder(
                  itemCount: notGradedSubmissions.length,
                  itemBuilder: (context, index) {
                    final submission = notGradedSubmissions[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text('${submission.studentAccount!.firstName} ${submission.studentAccount!.lastName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${submission.studentAccount!.email}'),
                            Text('Thời gian nộp: ${submission.submissionTime}'),
                            Text('Grade: ${submission.grade ?? 'Chưa có'}'),
                            Text('Nội dung: ${submission.textResponse}'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoogleDriveViewer(driveUrl: submission.fileUrl!),
                                  ),
                                );
                              },
                              child: Text('Mở file sinh viên đã nộp', style: TextStyle(color: Colors.blue)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Hiển thị pop-up để chấm điểm
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController gradeController = TextEditingController();

                                    return AlertDialog(
                                      title: Text('Nhập điểm cho ${submission.studentAccount!.firstName} ${submission.studentAccount!.lastName}'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: gradeController,
                                            decoration: InputDecoration(
                                              labelText: 'Nhập điểm',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
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
                                            final grade = double.parse(gradeController.text);
                                            if(grade > 10 || grade < 0){
                                              Constant.showSuccessSnackbar(context, "Điểm từ 0 đến 10", Colors.red);
                                            } else {
                                              surveyProvider.grade_survey(context, widget.survey!.id.toString(), gradeController.text, submission.id.toString());
                                              notificationProvider.sendNotification(message: "Bạn đã được chấm điểm ${grade} cho bài kiểm tra ${widget.survey?.title}", toUser: submission.studentAccount!.accountId.toString(), type: "ASSIGNMENT_GRADE");
                                            }
                                          },
                                          child: Text('Chấm điểm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Chấm điểm'),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),

                // Tab "Đã chấm"
                gradedSubmissions.isEmpty
                    ? Center(child: Text('Không có bài tập nào đã chấm'))
                    : ListView.builder(
                  itemCount: gradedSubmissions.length,
                  itemBuilder: (context, index) {
                    final submission = gradedSubmissions[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text('${submission.studentAccount!.firstName} ${submission.studentAccount!.lastName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${submission.studentAccount!.email}'),
                            Text('Thời gian nộp: ${submission.submissionTime}'),
                            Text('Grade: ${submission.grade ?? 'Chưa có'}'),
                            Text('Nội dung: ${submission.textResponse}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
