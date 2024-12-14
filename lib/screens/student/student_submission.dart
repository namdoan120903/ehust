import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../provider/SurveyProvider.dart';
import '../myAppBar.dart';

class StudentSubmission extends StatefulWidget {

  final String id;
  const StudentSubmission({required this.id});

  @override
  State<StudentSubmission> createState() => _StudentSubmissionState();
}

class _StudentSubmissionState extends State<StudentSubmission> {

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    _initData();
  }

  Future<void> _initData() async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.get_submission(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body:surveyProvider.isLoading?Center(child: CircularProgressIndicator()): Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chấm điểm bài tập',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Điểm : ${surveyProvider.selectSubmission?.grade == null ?"Chưa được chấm điểm":surveyProvider.selectSubmission!.grade}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Mô tả: ${surveyProvider.selectSubmission?.textResponse}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  'Thời gian nộp: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.parse(surveyProvider.selectSubmission!.submissionTime!))}',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleDriveViewer(
                            driveUrl: surveyProvider.selectSubmission!.fileUrl!
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Mở bài đã nộp',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
