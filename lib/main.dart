import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/analyses_screen.dart';
import 'package:watersec_mobileapp_front/View/changepassword_screen.dart';
import 'package:watersec_mobileapp_front/View/dash2.dart';
import 'package:watersec_mobileapp_front/View/dashboardplus_screen.dart';
import 'package:watersec_mobileapp_front/View/forgotpwd_screen.dart';
import 'package:watersec_mobileapp_front/View/login_screen.dart';
import 'package:watersec_mobileapp_front/View/notifications_screen.dart';
import 'package:watersec_mobileapp_front/View/splash_screen.dart';
import 'package:watersec_mobileapp_front/View/profile_screen.dart';
import 'package:watersec_mobileapp_front/View/settings_screen.dart';
import 'package:watersec_mobileapp_front/ViewModel/DashboardViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/analyticsViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/categoriesViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/day_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/devicesViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/editprofileViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/forgotpwdViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/month_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/notificationViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/settingsGETViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/year_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/classes/user_provider.dart';
import 'package:watersec_mobileapp_front/theme/appThemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (FlutterErrorDetails details) {
    print(details.stack);
  };

  await _initializeLocalNotifications();
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DevicesViewModel()),
      ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ChangeNotifierProvider(create: (_) => DayPeriodConsumptionViewModel()),
      ChangeNotifierProvider(create: (_) => MonthPeriodConsumptionViewModel()),
      ChangeNotifierProvider(create: (_) => YearPeriodConsumptionViewModel()),
      ChangeNotifierProvider(create: (_) => AnalyticsViewModel()),
      ChangeNotifierProvider(create: (_) => WaterMetersViewModel()),
      ChangeNotifierProvider(create: (_) => EditProfileViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => UserInfoViewModel()),
      ChangeNotifierProvider(create: (_) => SettingsViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => CategoryViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => NotificationViewModel()),
    ],
    child: const MyApp(),
  ));
}

Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'local_notification_channel',
    'watersec_push_notifications',
    description: 'This channel is used for watersec local notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final FlutterLocalization localization = FlutterLocalization.instance;

class _MyAppState extends State<MyApp> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('fr', AppLocale.FR),
        const MapLocale('de', AppLocale.DE)
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    _initializeFirebaseMessaging();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    print(_currentLocale);
  }

  Future<void> _checkUserSession() async {
    final loginViewModel = context.read<LoginViewModel>();
    final notificationViewModel = context.read<NotificationViewModel>();

    await loginViewModel.checkUserSession();

    // Initialize notifications if user is logged in
    if (loginViewModel.accessToken != null) {
      await notificationViewModel.loadNotifications();
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Listen for the APNs token and print it once available
      messaging.onTokenRefresh.listen((newToken) {
        print('APNs Token refreshed: $newToken');
      });

      // Attempt to get APNs token
      String? apnsToken = await messaging.getAPNSToken();
      print('APNs Token: $apnsToken');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Received a message while in the foreground: ${message.notification?.title}');
        _showForegroundNotification(message);

        // Update unread count in NotificationViewModel
        final notificationViewModel =
            Provider.of<NotificationViewModel>(context, listen: false);
        notificationViewModel.incrementUnreadCount();
      });
    } else {
      print('User declined or has not accepted permission');
    }
// Handle when the app is opened directly from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      _navigateToNotificationScreen();
    });
    // Retrieve and print the FCM token
    try {
      String? fcmToken = await messaging.getToken();
      print('FCM Token: $fcmToken');
    } catch (e) {
      print('Error getting FCM Token: $e');
    }
  }

  void _navigateToNotificationScreen() {
    // Assuming '/notifications' is the route name for your Notifications screen
    Navigator.pushNamed(context, '/notifications');
  }

  void _showForegroundNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'local_notification_channel',
      'watersec_push_notifications',
      channelDescription:
          'This channel is used for watersec local notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
            id: 'light',
            data: MyAppThemes.lightTheme,
            description: 'Light Theme'),
        AppTheme(
            id: 'dark', data: MyAppThemes.darkTheme, description: 'Dark Theme'),
      ],
      child: ThemeConsumer(
        child: Builder(builder: (themeContext) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            title: 'WaterSec',
            theme: ThemeProvider.themeOf(themeContext).data,
            themeMode: ThemeMode.system,
            home: loginViewModel.accessToken != null
                ? const Dashboard2()
                : const SplashScreen(),
            routes: {
              '/login': (context) => const Login(),
              '/forgotpwd': (context) => const ForgotPwd(),
              '/dashboard': (context) => const Dashboard2(),
              '/profile': (context) => const Profile(),
              '/changepwd': (context) => const ChangePwd(),
              '/dashboardplus': (context) => const DashPlus(),
              '/analyses': (context) => const Analyses(),
              '/parametres': (context) => const Settings(),
              '/notifications': (context) => const Notifications(),
            },
          );
        }),
      ),
    );
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
