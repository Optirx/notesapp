import 'package:notesapp/db/constants.dart';

class Note{
  int? noteId;
  String noteText='';
  String noteBody='';
  String noteDate='';
  String noteColor = '';
  String? updatedDate ='';
  String? updateState = '' ;

  Note({this.noteId, required this.noteText, required this.noteBody,required this.noteDate,required this.noteColor,this.updateState,this.updatedDate});

  Map<String,dynamic> toMap()=>{
    colId : noteId,
    colTitle: noteText,
    colBody:noteBody,
    colDate:noteDate,
    colNoteColor:noteColor,
    colUpdatedDate:updatedDate,
    colUpdatedState:updateState,
  };


  Note.fromMap(Map<String,dynamic> map){
    noteId = map[colId];
    noteText = map[colTitle];
    noteBody = map[colBody];
    noteDate = map[colDate];
    noteColor= map[colNoteColor];
    updatedDate = map[colUpdatedDate];
    updateState = map[colUpdatedState];


  }
}