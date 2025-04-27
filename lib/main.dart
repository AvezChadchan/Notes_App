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
                    return Expanded(
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        shadowColor: Colors.orangeAccent,
                        color: Colors.orange,
                        elevation: 7,
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
          _showModalBottomSheet();
        },
        child: Icon(Icons.add, size: 37, color: Colors.black),
      ),
    );
  }

  void _showModalBottomSheet() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: 450,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Text(
                  "Add Note",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
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
                  maxLines: 4,
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
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
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
                        child: Text("Add Note"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
