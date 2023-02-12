import 'package:notesapp/db/curd.dart';
import 'package:notesapp/model/Note.dart';
import 'package:notesapp/utils/date_time_manager.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/utils/ext.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.blue;
  String updatedDateTime = '';
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey<FormState> _updateKey = GlobalKey();
  List<Color> noteColors = [
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.red,
    Colors.amber,
    Colors.cyan,
    Colors.orange
  ];
  List<Note> notes = [];
  String updatedStateCheck = "false";


  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _viewNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                children: [
                Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      width: 500,
                      child: TextFormField(
                        controller: _titleController,
                        validator: (value) =>
                        value!.isEmpty ? 'this field is required' : null,
                        decoration: InputDecoration(
                          labelText: 'Title', border: OutlineInputBorder(),),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _bodyController,
                      validator: (value) =>
                      value!.isEmpty ? 'this field is required' : null,
                      minLines: 3,
                      maxLines: 8,
                      decoration: InputDecoration(
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 400, height: 50,
                          child: ListView.builder(itemCount: noteColors.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 25, right: 3, left: 3),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = noteColors[index];
                                      });
                                    },

                                    child: Container(
                                      width: 50, height: 50,
                                      decoration: BoxDecoration(
                                        color: noteColors[index],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(child: selectedColor ==
                                          noteColors[index]
                                          ? Icon(
                                        Icons.check, color: Colors.white,)
                                          : null),
                                    ),
                                  ),
                                );
                              }
                              )
                          ),
                        ),
                      ],
                    ),


                    //hona
                    ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            Note note = Note(
                                noteText: _titleController.value.text,
                                noteBody: _bodyController.value.text,
                                noteDate: DateTimeManager.getCurrentDateTime(),
                                noteColor: selectedColor.toString(),
                                updatedDate: updatedDateTime,
                                updateState: updatedStateCheck
                            );

                            saveNote(context, note);
                          }
                        },
                        child: Text('Add Note')),
                    Divider(thickness: 2,),
                  ],
                )),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: selectedColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        title: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notes[index].noteText),
                                Text(notes[index].noteBody),
                              ]),
                        ),
                        subtitle: Row(
                          children: [
                        notes[index].updateState=='true'?Container(width: 15,
                          height: 15,
                          decoration: BoxDecoration(color: Colors.red,
                              borderRadius: BorderRadius.circular(30)),):
                        Container(width: 15, height: 15,
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(30))),
                        SizedBox(width: 4,),
                        Text(notes[index].noteDate),
                        ],
                      ),
                      leading: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(
                          Icons.notes,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(children: [
                          Container(
                            width: 45,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                onPressed: () {
                                  _showEditSheet(context, notes[index]);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )),
                          ),
                          SizedBox(width: 10,),
                          Container(

                            width: 45,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                onPressed: () {
                                  _deleteNote(notes[index].noteId);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        ]),
                      ),
                    ),
                  ),
            ),
          )
          ],
        )),)
    );
  }

  void saveNote(BuildContext context, Note note) {
    Curd.curd.saveNote(note).then((value) {
      if (value > 0) {
        widget.showSnackBar(context, 'Note added Successfully');
        _viewNotes();
      }
    });
  }

  void _viewNotes() {
    Curd.curd.selectAll().then((value) {
      notes = value;
      setState(() {});
    });
  }

  void _deleteNote(int? noteId) {
    Curd.curd.deleteNote(noteId).then((value) {
      if (value > 0) {
        widget.showSnackBar(context, 'Note deleted successfully');
        _viewNotes();
      }
    });
  }

  void _showEditSheet(BuildContext context, Note note) {
    TextEditingController _updateTitle =
    TextEditingController(text: note.noteText);
    TextEditingController _updateBody =
    TextEditingController(text: note.noteBody);
    showModalBottomSheet(isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
                child: Wrap(children: [
                  const Center(
                    child: Text('Update Note'),
                  ),
                  Form(
                      key: _updateKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _updateTitle,
                            validator: (value) =>
                            value!.isEmpty ? 'this field is required' : null,
                            decoration: const InputDecoration(
                                labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: _updateBody,
                            validator: (value) =>
                            value!.isEmpty ? 'this field is required' : null,
                            minLines: 2,
                            maxLines: 5,
                            decoration: const InputDecoration(
                                labelText: 'Body'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_updateKey.currentState!.validate()) {
                                  note.noteText = _updateTitle.value.text;
                                  note.noteBody = _updateBody.value.text;
                                  note.updatedDate =
                                      DateTimeManager.getCurrentDateTime();
                                  note.updateState = "true";
                                  _updateNote(note);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Update Note'))
                        ],
                      ))
                ]),
              ),
            ),
          ),
    );
  }

  void _updateNote(Note note) {
    Curd.curd.updateNote(note).then((value) {
      if (value > 0) {
        widget.showSnackBar(context, 'Note updated successfully');
        _viewNotes();
      }
    });
  }
}
