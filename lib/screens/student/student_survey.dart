import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/student/student_submission.dart';
import 'package:project/screens/student/student_submit_survey.dart';
import 'package:provider/provider.dart';

import '../../model/Survey.dart';
import '../../provider/SurveyProvider.dart';
import '../myAppBar.dart';

class StudentSurvey extends StatefulWidget {
  @override
  State<StudentSurvey> createState() => _StudentSurveyState();
}

class _StudentSurveyState extends State<StudentSurvey> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Survey> completedSurveys = [];
  List<Survey> pendingSurveys = [];List<Survey> expiredSurveys = [];

  @override
  void initState() {
    super.initState();
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.get_survey_student(context);
    _tabController = TabController(length: 3, vsync: this);
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);

    // Danh sách bài đã làm và còn hạn
     completedSurveys = surveyProvider.studentSurvey
        .where((assignment) =>
    assignment.is_submitted! &&
        DateTime.parse(assignment.deadline!).isAfter(DateTime.now()))
        .toList();

// Danh sách bài chưa làm và còn hạn
     pendingSurveys = surveyProvider.studentSurvey
        .where((assignment) =>
    !assignment.is_submitted! &&
        DateTime.parse(assignment.deadline!).isAfter(DateTime.now()))
        .toList();

// Danh sách bài đã hết hạn (bao gồm cả đã làm lẫn chưa làm)
     expiredSurveys = surveyProvider.studentSurvey
        .where((assignment) =>
        DateTime.parse(assignment.deadline!).isBefore(DateTime.now()))
        .toList();

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: Text(
              'Danh sách lớp học',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          SizedBox(height: 10,),
          // TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Chưa làm"),
              Tab(text: "Đã làm"),
              Tab(text: "Hết hạn"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab "Chưa làm"
                SurveyList(
                  items: pendingSurveys,
                  submit: false,
                  view: false,
                ),
                // Tab "Đã làm"
                SurveyList(
                  items: completedSurveys,
                  submit: true,
                  view: true,
                ),
                SurveyList(
                  items: expiredSurveys,
                  submit: false,
                  view: false,
                  expired: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SurveyList extends StatelessWidget {
  final List<Survey> items;
  final bool submit;
  final bool view;
  final bool expired;

  SurveyList({required this.items, required this.submit, required this.view, this.expired = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final assignment = items[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            title:
                Text('${assignment.title!} - ${assignment.classId} '),
            subtitle:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignment.description!),
                Text('Thời hạn nộp bài: ${DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(assignment.deadline!))}'),
              ],
            ),
            onTap: () {
              if(submit == false && expired == false){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentSubmitSurvey(survey: assignment),
                ),
              );
              }
              if(view ==true )Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentSubmission(id: assignment.id.toString(),)));
            },
          ),
        );
      },
    );
  }
}
