import 'package:flutter/material.dart';
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

    List<Survey> completedSurveys =
    surveyProvider.studentSurvey.where((assignment) => assignment.is_submitted!).toList();
    List<Survey> incompleteSurveys =
    surveyProvider.studentSurvey.where((assignment) => !assignment.is_submitted!).toList();
    List<Survey> gradedSurveys =
    completedSurveys.where((assignment) => assignment.grade != null).toList();

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
              Tab(text: "Đã chấm điểm"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab "Chưa làm"
                SurveyList(
                  items: incompleteSurveys,
                  showGrade: false,
                  submit: false,
                ),
                // Tab "Đã làm"
                SurveyList(
                  items: completedSurveys,
                  showGrade: false,
                  submit: true,
                ),
                // Tab "Đã chấm điểm"
                SurveyList(
                  items: gradedSurveys,
                  showGrade: true,
                  submit: true,
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
  final bool showGrade;
  final bool submit;

  SurveyList({required this.items, this.showGrade = false, required this.submit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final assignment = items[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            title: Text('${assignment.title!} - ${assignment.classId} - ${assignment.deadline}'),
            subtitle: showGrade
                ? Text('Điểm: ${assignment.grade}, ${assignment.description!}')
                : Text(assignment.description!),
            onTap: () {
              if(submit == false){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentSubmitSurvey(survey: assignment),
                ),
              );}
            },
          ),
        );
      },
    );
  }
}
