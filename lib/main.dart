import 'package:flutter/material.dart';
import 'package:ZenNote/data/local/db_helper.dart';

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
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
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
                          leading: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
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
                          trailing: SizedBox(
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        titleController.text =
                                            notes[index][DBHelper.COLUMN_TITLE];
                                        contentController.text =
                                            notes[index][DBHelper
                                                .COLUMN_CONTENT];
                                        return _showModalBottomSheet(
                                          isUpdate: true,
                                          id: notes[index][DBHelper.COLUMN_ID],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    int noteID =
                                        notes[index][DBHelper.COLUMN_ID];
                                    bool check = await dbRef!.deleteNote(
                                      id: noteID,
                                    );
                                    if (check) {
                                      getNotes();
                                      notes.removeAt(index);
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Color(0xFFE53935),
                                    size: 25,
                                  ),
                                ),
                              ],
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              titleController.clear();
              contentController.clear();
              return _showModalBottomSheet(isUpdate: false);
            },
          );
        },
        child: Icon(Icons.add, size: 37, color: Colors.black),
      ),
    );
  }

  Widget _showModalBottomSheet({bool isUpdate = false, int id = 0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isUpdate ? "Update Note" : "Add Note",
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
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
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
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          foregroundColor: Colors.orange,
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(color: Colors.white, fontSize: 18),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          foregroundColor: Colors.orange,
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () async {
                          var title = titleController.text;
                          var content = contentController.text;
                          if (title.isNotEmpty && content.isNotEmpty) {
                            bool check =
                                isUpdate
                                    ? await dbRef!.updateNote(
                                      id: id,
                                      mtitle: title,
                                      mcontent: content,
                                    )
                                    : await dbRef!.addNote(
                                      mtitle: title,
                                      mcontent: content,
                                    );
                            if (check) {
                              getNotes();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Center(
                                  child: Text(
                                    "Please fill all the fields!!!",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: Text(isUpdate ? "Update" : "Add"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
