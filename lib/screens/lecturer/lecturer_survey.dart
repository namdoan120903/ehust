import 'package:flutter/material.dart';
import 'package:project/model/Class.dart';
import 'package:project/provider/SurveyProvider.dart';
import 'package:project/screens/lecturer/create_survey.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

class LecturerSurvey extends StatefulWidget {
  final Class classA;
  LecturerSurvey({required this.classA});

  @override
  State<LecturerSurvey> createState() => _LecturerSurveyState();
}

class _LecturerSurveyState extends State<LecturerSurvey> {

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.getAllSurvey(context, widget.classA.classId!);
    print(surveyProvider.surveys.toString());
  }


  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
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
              'Danh sách bài tập',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateSurvey(classId: widget.classA.classId,)));
              },
              tooltip: 'Thêm bài tập mới',
              color: Colors.red,
            ),
          ],
        ),Expanded(child:
            ListView.builder(
              itemCount: surveyProvider.surveys.length,
              itemBuilder: (context, index) {
                final assignment = surveyProvider.surveys[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    onTap: (){

                    },
                    title: Text('${assignment.title!} - ${assignment.classId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4), // Khoảng cách giữa các dòng
                        Text(
                          'Hạn nộp bài: ${assignment.deadline}', // Văn bản bổ sung
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

                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            print(assignment.id);
                            surveyProvider.deleteSurvey(context, assignment.id!, index);
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
