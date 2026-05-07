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
  DateTime? selectedDate;
  
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
      await ApiService.createTask(task, selectedPriority, selectedDate?.toIso8601String());
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService.deleteToken();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
        title: const Text("Task Manager", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Tasks",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: tasks.isEmpty
                        ? const Center(child: Text("No tasks yet. Add one!"))
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Dismissible(
                                key: Key(task["_id"].toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  final id = task["_id"];
                                  await ApiService.deleteTask(id);
                                  await loadTasks();
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    subtitle: task["dueDate"]!= null
                                    ? Text(
                                      "Due: ${DateTime.parse(task["dueDate"]).day}/"
                                      "${DateTime.parse(task["dueDate"]).month}/"
                                      "${DateTime.parse(task["dueDate"]).year}",
                                      style: TextStyle(color: Colors.grey,fontSize: 12),
                                    )
                                    :null,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    trailing: Icon(
                                      Icons.flag,
                                      color: task["priority"] == 'high'
                                          ? Colors.red
                                          : task["priority"] == 'low'
                                              ? Colors.green
                                              : Colors.orange,
                                    ),
                                    leading: InkWell(
                                      onTap: () async {
                                        final id = task["_id"];
                                        await ApiService.toggleTask(id);
                                        await loadTasks();
                                      },
                                      child: Icon(
                                        task["done"] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: task["done"] == true ? Theme.of(context).colorScheme.primary : Colors.grey,
                                        size: 28,
                                      ),
                                    ),
                                    title: Text(
                                      task["title"],
                                      style: TextStyle(
                                        decoration: task["done"] == true ? TextDecoration.lineThrough : null,
                                        color: task["done"] == true ? Colors.grey : null,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Reset priority and input when opening the bottom sheet
          selectedPriority = 'medium';
          selectedDate = null;
          taskcontroller.clear();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Add New Task",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: taskcontroller,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Task Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text("Priority", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ['low', 'medium', 'high'].map((p) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(p.toUpperCase()),
                                  selected: selectedPriority == p,
                                  onSelected: (selected) {
                                    if (selected) {
                                      // Update the modal's state so the chip updates visually
                                      setModalState(() => selectedPriority = p);
                                      // Also update the parent state just in case
                                      setState(() => selectedPriority = p);
                                    }
                                  },
                                ),
                              );
                              
                            }).toList(),
                            
                          ),
                          TextButton(
                            onPressed: () async{
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100)
                                );
                                if(picked != null){
                                  setModalState(()=> selectedDate = picked);
                                }
                            },
                            child: Text(
                              selectedDate == null
                              ? "pick due Date"
                              : "Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              handleLogic();
                            },
                            child: const Text("Create Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}