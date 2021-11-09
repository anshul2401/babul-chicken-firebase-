import 'package:babul_chicken_firebase/admin/home_page.dart';
import 'package:babul_chicken_firebase/admin/add_prod.dart';
import 'package:babul_chicken_firebase/pages/account_page.dart';
import 'package:babul_chicken_firebase/pages/edit_product_screen.dart';
import 'package:babul_chicken_firebase/pages/home_page.dart';
import 'package:babul_chicken_firebase/pages/login_page.dart';
import 'package:babul_chicken_firebase/pages/order_history.dart';
import 'package:babul_chicken_firebase/pages/search_bar.dart';
import 'package:babul_chicken_firebase/pages/user_details.dart';
import 'package:babul_chicken_firebase/providers/cart.dart';
import 'package:babul_chicken_firebase/providers/order.dart';
import 'package:babul_chicken_firebase/providers/products.dart';
import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderItem(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: MyColor.primarycolor,
          ),
          home: SplashScreen(
            backgroundColor: Colors.white,
            image: Image.asset('assets/images/icon.png'),
            photoSize: 150,
            seconds: 3,
            navigateAfterSeconds: _auth.currentUser == null
                ? const BottomNavBar()
                : isAdmin(_auth.currentUser.phoneNumber)
                    ? const AdminHomePage()
                    : const BottomNavBar(),
            // navigateAfterSeconds: ListSearch(),
          )),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _index = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Widget> _widgetList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getDetails();
    });
    _auth.currentUser == null
        ? _widgetList = [
            const MyHomePage(),
            const LoginScreen('History'),
            const LoginScreen('Account'),
          ]
        : _widgetList = [
            // App(),
            MyHomePage(),
            Orders(),
            AccountPage(),
          ];
    initPlatformState();
    super.initState();
  }

  getDetails() async {
    var userProvider = Provider.of<UserModel>(context, listen: false);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.currentUser == null
        ? null
        : await userProvider.setUserId(_auth.currentUser.uid);
    _auth.currentUser == null
        ? null
        : await userProvider.setNumber(_auth.currentUser.phoneNumber);
    _auth.currentUser == null ? null : await userProvider.fetchUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
              ),
              label: 'Orders'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: 'Account',
          ),
        ],
        selectedItemColor: MyColor.primarycolor,
        currentIndex: _index,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      Config.oneSignalAppId,
    );
  }
}
