import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'signin.dart';
import 'signup.dart';
import 'calculator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Masta App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const MyHomePage(),
            scaffoldMessengerKey: ConnectivityService.instance.scaffoldMessengerKey,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    ConnectivityService.instance.initialize();
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home', style: optionStyle),
    SignInForm(),
    SignUpForm(),
    Calculator(),
    ContactsPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to the innovation"),
        backgroundColor: Colors.blueGrey,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: "SignIn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: "SignUp",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calculator",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: "Contacts",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTap,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Moustapha Abakar Mahamat'),
              accountEmail: const Text('moustapha7200@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.person, size: 50) : null,
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              onDetailsPressed: _showImageSourceDialog,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                _onItemTap(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('SignIn'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('SignUp'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calculator'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calculator()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                _showThemeDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme') ?? 'system';
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.light) {
      prefs.setString('theme', 'light');
    } else if (themeMode == ThemeMode.dark) {
      prefs.setString('theme', 'dark');
    } else {
      prefs.setString('theme', 'system');
    }
  }
}

class ConnectivityService {
  ConnectivityService._privateConstructor();

  static final ConnectivityService _instance = ConnectivityService._privateConstructor();

  static ConnectivityService get instance => _instance;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void initialize() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isConnected = result != ConnectivityResult.none;
      _showConnectivitySnackBar(isConnected);
    });

    // Check the initial connectivity status
    _checkInitialConnectivity();
  }

  void _checkInitialConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    bool isConnected = result != ConnectivityResult.none;
    _showConnectivitySnackBar(isConnected);
  }

  void _showConnectivitySnackBar(bool isConnected) {
    String message = isConnected ? 'Connected to the Internet' : 'No Internet Connection';
    Color bgColor = isConnected ? Colors.green : Colors.red;

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: FutureBuilder<Iterable<Contact>>(
        future: ContactsService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }
          return ListView(
            children: snapshot.data!.map((contact) {
              return ListTile(
                title: Text(contact.displayName ?? 'No name'),
                subtitle: Text(contact.phones?.isNotEmpty == true ? contact.phones!.first.value! : 'No phone'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
