import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

String str = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken(
    vapidKey:
        "BKa969cFrvPddrNJR2ILF9cHQdkXm6CLJYHNBq16BAGI0I-F-unYy2FOWNL7_WACrbaHUgS3g1gwOdPZGfIMt9o",
  );
  print("@ : " + token!);

  await FirebaseMessaging.instance.subscribeToTopic('topicTest1');

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    RemoteNotification? notification = message.notification;
    // message.notification?.android?.channelId;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          // notification.hashCode,
          1,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                priority: Priority.max,
                styleInformation: MessagingStyleInformation(
                  Person(important: true, name: "123123", key: "@@@@"),
                  conversationTitle: "conversation",
                  messages: [
                    Message("m1", DateTime.now(),
                        Person(important: true, name: "123123", key: "@@@@")),
                    Message("m2", DateTime.now(),
                        Person(important: true, name: "345345", key: "@@@@"))
                  ],
                )),
          ));
    }
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //   print('Message andoird: ${message.notification?.android}');
  //   print('Message andoird: ${message.notification?.android?.imageUrl}');
  //   print('Message apple: ${message.notification?.apple}');
  //   print('Message apple: ${message.notification?.apple?.imageUrl}');
  //   print('Message title: ${message.notification?.title}');
  //   print('Message body: ${message.notification?.body}');
  //
  //   str = message.notification!.title!;
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$str',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // _showCustomNotification() async {
  //   OverlayState overlayState = Overlay.of(context)!;
  //   OverlayEntry overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: 30,
  //       left: 0,
  //       right: 0,
  //       child: Container(
  //         child: Card(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               'Hello world',
  //               style: TextStyle(
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   overlayState.insert(overlayEntry);
  //   await Future.delayed(Duration(seconds: 2));
  //   overlayEntry.remove();
  // }
}

class ForegroundPush extends StatelessWidget {
  const ForegroundPush({
    Key? key,
    this.title = "",
    required this.contents,
    this.imageUrl = "",
  }) : super(key: key);

  final String title;
  final String contents;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(title),
          Text(contents),
        ],
      ),
    );
  }
}
