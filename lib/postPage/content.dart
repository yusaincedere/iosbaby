import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/model/answer.dart';
import 'package:plant_app/model/postmodel.dart';
import 'package:plant_app/model/question.dart';
import 'package:plant_app/postPage/questioninfo.dart';

class Content extends StatefulWidget {
  final PostModel post;
  final bool visibiltyVariable;

  Content({
    Key key,
    this.visibiltyVariable,
    @required this.post,
}):super(key:key);


  @override
  _ContentState createState() => _ContentState(post:post, visibiltyVariable: visibiltyVariable);
}

class _ContentState extends State<Content> {
  final bool visibiltyVariable;

  _ContentState({
    this.visibiltyVariable,
    this.post
  });

  PostModel post;
  bool textFieldVisibility = false;
  List<bool> answerTextFieldVisibility = [];
  List<bool> questionTextFieldVisibility = [];
  TextEditingController textEditingControllerBaslik = TextEditingController();
  TextEditingController textEditingControllerIcerik = TextEditingController();
  List<TextEditingController> textEditingControllerSoru = List<TextEditingController>();
  TextEditingController textEditingControllerYeniSoru = TextEditingController();
  List<TextEditingController>  textEditingControllerCevap = List<TextEditingController>();
  List<QuestionModel> questionList = [];
  List<AnswerModel> answerList = [];
  User user = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
    setState(() {
    });
    getQuestions(post);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    post = widget.post;
    textEditingControllerIcerik.text = post.icerik;
    textEditingControllerBaslik.text = post.baslik;

    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context,true);
                  }, icon: Icon(Icons.arrow_back, color: kPrimaryColor), iconSize: 30.0),
                ),

                Row(
                  children: [
                    Visibility(
                      visible: visibiltyVariable,
                      child: Container(
                        width: 60,
                        child: FlatButton(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.0)),
                          child: Icon(Icons.edit, color: kPrimaryColor, size: 30.0),
                          onPressed: () {
                            setState(() {
                              if(textFieldVisibility == false){
                                textFieldVisibility = true;
                              }else if(textFieldVisibility == true){
                                textFieldVisibility = false;
                              }
                            });
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: visibiltyVariable,
                      child: Container(
                        width: 60,
                        child: FlatButton(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.0)),
                          child: Icon(Icons.check, color: kPrimaryColor, size: 30.0),
                          onPressed: () async {
                            post.baslik = textEditingControllerBaslik.text;
                            post.icerik = textEditingControllerIcerik.text;
                            await FirebaseService().updateSubTitle(post);

                            setState(() {
                              if(textFieldVisibility == true){
                                textFieldVisibility = false;
                              }
                            });

                          },
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                      child: Container(
                        width: double.infinity,
                        child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: textFieldVisibility,
                            ),
                          enabled: textFieldVisibility,
                          controller: textEditingControllerBaslik,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: kTextColorB, fontFamily: "ScrambledTofu")
                        )
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: textFieldVisibility,
                            ),
                          enabled: textFieldVisibility,
                          controller: textEditingControllerIcerik,
                            style: TextStyle(fontSize: 15, color: kTextColorB, fontFamily: "ScrambledTofu")
                        )
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: visibiltyVariable,
                          child: Container(
                            width: 80,
                            height: 50,
                            child: FlatButton(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.0)),
                              child: Icon(Icons.add, color: kPrimaryColor),
                              onPressed: () async {
                                showAlertDialogAdd(context,);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                        itemCount: questionList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 0.0),
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: (){
                                            if(visibiltyVariable){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => QuestionInfo(question: questionList[index]),
                                                ),
                                              );

                                            }else{
                                              if(answerTextFieldVisibility[index] == false){
                                                answerTextFieldVisibility[index] = true;
                                              }else{
                                                answerTextFieldVisibility[index] = false;
                                              }
                                              setState(() {

                                              });
                                            }
                                          },
                                          title: Transform.translate(offset: Offset(0,0),
                                            child: TextField(
                                              maxLines: null,
                                                enabled: questionTextFieldVisibility[index],
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Colors.white,
                                                  filled: questionTextFieldVisibility[index],
                                                ),
                                                controller: textEditingControllerSoru[index],
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontFamily: 'ScrambledTofu',
                                                  color: kTextColorB
                                              ),
                                              ),
                                            ),
                                          leading: Container(height: double.infinity, child: Icon(Icons.circle_rounded, color: kTextColorB, size: 13)),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Visibility(
                                                visible: visibiltyVariable,
                                                child: IconButton(onPressed: () async {
                                                  if(questionTextFieldVisibility[index]){
                                                    questionTextFieldVisibility[index] = false;
                                                    if(textEditingControllerSoru[index].text != questionList[index].questionString){
                                                      questionList[index].questionString = textEditingControllerSoru[index].text;
                                                      await FirebaseService().updateQuestion(questionList[index]);
                                                    }
                                                  }
                                                  else{
                                                    questionTextFieldVisibility[index] = true;
                                                  }
                                                  setState(() {

                                                  });
                                                }, icon: Icon(Icons.edit, color: kTextColorB, size: 20), padding: EdgeInsets.zero,  constraints: BoxConstraints()),
                                              ),

                                              Visibility(
                                                visible: visibiltyVariable,
                                                child: IconButton(onPressed: () async {
                                                  await FirebaseService().deleteQuestion(questionList[index]);
                                                  print(index);
                                                  questionList.removeAt(index);
                                                  questionList.forEach((element) {print(element.questionString);});
                                                  textEditingControllerSoru.removeAt(index);
                                                  setState(() {
                                                  });
                                                }, icon: Icon(Icons.delete, color: kTextColorB, size: 20)),
                                              ),

                                              Container(height: double.infinity, child: Icon(Icons.arrow_right, color: kTextColorB, size: 30)),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: answerTextFieldVisibility[index],
                                          child: TextField(
                                              maxLines: null,
                                              keyboardType: TextInputType.text,
                                              maxLength: 150,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.send),
                                                  onPressed:()async{
                                                    answerTextFieldVisibility[index] = false;
                                                    AnswerModel answer = AnswerModel(
                                                      userId: user.uid,
                                                      subTitleId: questionList[index].subTitleId,
                                                      mainTitleId: questionList[index].mainTitleId,
                                                      questionId: questionList[index].questionId,
                                                      date: DateTime.now().toString(),
                                                      userInfo: user.email,
                                                      answerString: textEditingControllerCevap[index].text
                                                    );
                                                    await FirebaseService(uid: user.uid).addAnswer(answer);
                                                    setState(() {
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg: "Soruya verdiğiniz cevap kaydedildi",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 2,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0
                                                    );
                                                  } ,
                                                ),
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled: answerTextFieldVisibility[index],
                                              ),
                                              enabled: answerTextFieldVisibility[index],
                                              controller: textEditingControllerCevap[index],
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: kTextColorB, fontFamily: "ScrambledTofu")
                                          ),
                                        )
                                      ],

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getQuestions(PostModel postModel) async {
    questionList = await FirebaseService(uid: user.uid).getQuestions(postModel);
    questionTextFieldVisibility.clear();
    answerTextFieldVisibility.clear();
    textEditingControllerSoru.clear();
    textEditingControllerCevap.clear();
    answerList.clear();
    for(int i = 0; i < questionList.length ; i++) {
      questionTextFieldVisibility.add(false);
      answerTextFieldVisibility.add(false);
      textEditingControllerSoru.add(TextEditingController());
      textEditingControllerCevap.add(TextEditingController());
      AnswerModel answer = await FirebaseService(uid: user.uid).getAnswer(questionList[i], user.email);
      textEditingControllerCevap[i].text = answer.answerString;
      textEditingControllerSoru[i].text = questionList[i].questionString;
      answerList.add(answer);
    }
    setState(() {
    });
  }
  showAlertDialogAdd(BuildContext context) {
    textEditingControllerYeniSoru.text = "";
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal", style: TextStyle(color: Colors.lightGreen)),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Devam Et", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        await FirebaseService().addQuestion(widget.post, textEditingControllerYeniSoru.text);
        getQuestions(widget.post);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: Text("Soruyu Giriniz", style: TextStyle(color: kTextColorB)),
      content: TextField(
        controller: textEditingControllerYeniSoru,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 20.0, fontFamily: 'ScrambledTofu'
          ),
          fillColor: Colors.white60,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
