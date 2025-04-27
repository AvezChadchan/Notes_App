import 'package:flutter/material.dart';
import 'package:notes_app/data/local/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes_App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBHelper? dbRef;
  List<Map<String, dynamic>> notes = [];
  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    notes = await dbRef!.getAllNotes();
    print("Fetched Notes: $notes");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes App",
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
          notes.isNotEmpty
              ? Container(
                color: Colors.black,
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      shadowColor: Colors.white,
                      color: Colors.orange,
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          notes[index][DBHelper.COLUMN_TITLE],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        subtitle: Text(
                          notes[index][DBHelper.COLUMN_CONTENT],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            int noteID = notes[index][DBHelper.COLUMN_ID];
                            await dbRef!.deleteNote(id: noteID);
                            setState(() {
                              getNotes();
                              notes.removeAt(index);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Color(0xFFE53935),
                            size: 27,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
              : Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    "No Notes Available!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          _showAddNoteDialog();
        },
        child: Icon(Icons.add, size: 37, color: Colors.black),
      ),
    );
  }

  void _showAddNoteDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 21),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: "Content",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 21),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                var title = titleController.text;
                var content = contentController.text;
                bool check = await dbRef!.addNote(
                  mtitle: title,
                  mcontent: content,
                );
                if (check) {
                  getNotes();
                }
                Navigator.pop(context);
              },
              child: Text(
                "Add",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
