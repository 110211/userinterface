import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String introduction;

  User({required this.name, required this.introduction});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User currentUser = User(name: 'Lâm Doãn ', introduction: 'Trang cá nhân của lâm .');
  List<User> userList = [
    User(name: 'John Doe', introduction: 'Hello, I am John Doe.'),
    User(name: 'Jane Smith', introduction: 'Hi, I am Jane Smith.'),
  ];
  bool isDarkMode = false;

  void _editIntroduction() {
    TextEditingController _controller = TextEditingController();
    _controller.text = currentUser.introduction;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Introduction'),
          content: TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your introduction here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentUser.introduction = _controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showUserDialog(User? user) {
    TextEditingController nameController = TextEditingController(text: user?.name ?? '');
    TextEditingController introController = TextEditingController(text: user?.introduction ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: introController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Introduction'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (user == null) {
                    userList.add(User(name: nameController.text, introduction: introController.text));
                  } else {
                    user.name = nameController.text;
                    user.introduction = introController.text;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(user == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(User user) {
    setState(() {
      userList.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              color: isDarkMode ? Colors.grey[800] : null, // Màu nền khi chế độ tối
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/images/avata.jpg'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    currentUser.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    currentUser.introduction,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _editIntroduction,
                    child: Text('Edit Introduction'),
                  ),
                ],
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  User user = userList[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.introduction),
                    tileColor: isDarkMode ? Colors.grey[900] : null, // Màu nền khi chế độ tối
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showUserDialog(user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
