// import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/login_screen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPriority = 'medium';
  TextEditingController taskcontroller = TextEditingController();
     List<Map<String,dynamic>> tasks = [  ];

    bool isLoading = false;

    void handleLogic()async{
      String task = taskcontroller.text;

      if (task.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Enter the Tasks"),)
        );
        return;
      }
      await ApiService.createTask(task, selectedPriority);
      await loadTasks();
      taskcontroller.clear();

      Navigator.pop(
        context
      );
    }
    @override
  void dispose(){
    taskcontroller.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    loadTasks();
  }
  Future<void> loadTasks()async{
    setState(() => isLoading = true);
    try{
    final data = await ApiService.getTasks();
    print(data);
    setState(() {
      tasks = List<Map<String,dynamic>>.from(data);
    });
  }catch(e){
    print("Error: $e");
  }
  setState(() => isLoading = false);
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
              await ApiService.deleteToken();
              Navigator.pushReplacement(
                context,
              MaterialPageRoute(builder: (context)=> LoginScreen()),
              );
            },
          )
        ],
        backgroundColor: Colors.red,
        title: Text("Task Manager", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator())
       :Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Welcome You are login"),
            Expanded(
            child: ListView.builder(
              
              itemCount: tasks.length,
              itemBuilder: (context,index){
                final task = tasks[index];
                return Dismissible(
                  key: Key(index.toString()),
                  onDismissed: (direction) async{
                    final id = tasks[index]["_id"];
                    await ApiService.deleteTask(id);
                    await loadTasks();
                  },
                child: ListTile(
                  trailing: Icon(
                    Icons.flag,
                    color: task["priority"] =='high'
                    ? Colors.red
                    :task["priority"] == 'low'
                    ?Colors.green
                    :Colors.orange,
                  ),
                  leading: Icon(
                    task["done"] == true
                    ? Icons.check_box
                    : Icons.check_box_outline_blank
                  ),
                  title: Text(task["title"]),
                  onTap: () async{
                    final id =tasks[index]["_id"];
                    await ApiService.toggleTask(id);
                    await loadTasks();
                  },
                ),
                );
              },
            )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            showModalBottomSheet(
              context: context,
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(19),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: taskcontroller,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          hintText: "Enter the Task",
                          border: OutlineInputBorder(),

                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['low','medium','high'].map((p){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(p),
                              selected: selectedPriority == p,
                              onSelected: (selected) {
                                setState(()=> selectedPriority = p);
                              } ,
                            ),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        onPressed: (){
                           handleLogic();
                        },
                        child: Text("Add Task"),
                      )
                    ],
                  ),
                  
                );
              }
            );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}