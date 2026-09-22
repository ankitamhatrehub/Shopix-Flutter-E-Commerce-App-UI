import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int number = 0;
  String name = "";
  final fruits = ['Apple', 'Banana', 'Mango', 'Orange', "ANkita"];
  String flutterText = "Hello";
  bool isToggle = false;
  List<String> fruitList= ['Apple', 'Banana'];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Search')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Hello Flutter"),
            Text(flutterText),
            Text("Number is $number"),
        
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: fruits.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(fruits[index]));
                },
              ),
            ),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(height: 200,
              child: ListView.builder(
                itemCount: fruitList.length,
                itemBuilder: (context,index){
              return ListTile(title: Text(fruitList[index]),trailing: IconButton(onPressed: (){
                setState(() {
                  fruitList.removeAt(index);
                });
              }, icon: Icon(Icons.remove)),);
                }),
            ),
            Text("My name is $name"),
            if (isToggle) Text("Welcome to FLutter"),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                  setState(() {
                    fruitList.add("Mango");
                  });
                }, child: Text("Add")),
            //       ElevatedButton(onPressed: (){
            //   setState(() {
            //     fruitList.remove("Mango");
            //   });
            // }, child: Text("Remove")),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isToggle = !isToggle;
                });
              },
              child: Text(isToggle ? "Hide Toggle" : "Show Toggle"),
            ),
        
            ElevatedButton(
              onPressed: () {
                setState(() {
                  flutterText = "Hello Flutter";
                });
              },
              child: Text("Change Text"),
            ),
            ElevatedButton(
              onPressed: () {
                print("Button clicked !..");
              },
              child: Text("Click Me"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  number++;
                });
              },
              child: Text("+"),
            ),
          ],
        ),
      ),
    );
  }
}
