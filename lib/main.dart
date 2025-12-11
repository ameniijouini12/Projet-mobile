import 'package:device_preview/device_preview.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hiatunisie/models/cart/cart.model.dart';
import 'package:hiatunisie/models/cart/cart_item.model.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/models/market.model.g.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hiatunisie/models/product.model.g.dart';
import 'package:hiatunisie/models/user.model.dart';
import 'package:hiatunisie/services/notification_service.dart';
import 'package:hiatunisie/services/websocket_service.dart';
import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/utils/navigation_service.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/viewmodels/food_viewmodel.dart';
import 'package:hiatunisie/viewmodels/home/navigation_provider.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/viewmodels/offer.viewmodel.dart';
import 'package:hiatunisie/viewmodels/product_viewmodel.dart';
import 'package:hiatunisie/viewmodels/reservation_viewmodel.dart';
import 'package:hiatunisie/viewmodels/review.viewmodel.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/foodPreference/food_pref_provider.dart';
import 'package:hiatunisie/views/home/home.dart';
import 'package:hiatunisie/views/splash/on_board_screen.dart';
import 'package:hiatunisie/views/splash/splash_screen.dart';
import 'package:hiatunisie/views/splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'views/details/box_details_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // full screen immersive
    overlays: [],
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await FastCachedImageConfig.init();
  
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(OfferAdapter());
  Hive.registerAdapter(EstablishmentAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MarketAdapter()) ; 
  Hive.registerAdapter(ProductAdapter()) ; 

  await Hive.openBox<Food>('foodBox');
  await Hive.openBox<Establishment>('establishmentsBox');
  await Hive.openBox<Offer>('offerBox');
  await Hive.openBox<Cart>('cartBox');
  await Hive.openBox<CartItem>('cartItemBox');
  await Hive.openBox<Market>('marketsBox') ; 
  await Hive.openBox<Product>('productBox') ; 
  await Hive.openBox<User>('userBox');
  
 

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
       

await NotificationService().requestNotificationPermission();

     
  final webSocketService = WebSocketService();
  webSocketService.connect(); // Connect to WebSocket when the app starts
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConnectivityManager(),
          child: const Home(),
        ),
        ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (_) => QuantityProvider()),

        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(Provider.of<UserViewModel>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodPreferenceProvider(
              Provider.of<UserViewModel>(context, listen: false)),
        ),
        ChangeNotifierProvider(create: (context) => EstablishmentViewModel( Provider.of<UserViewModel>(context, listen: false), Provider.of<FoodPreferenceProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => FoodViewModel(Provider.of<UserViewModel>(context, listen: false))),
        ChangeNotifierProvider(
          create: (context) => MarketViewModel(
            Provider.of<UserViewModel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (context) => OfferViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, FoodPreferenceProvider>(
          create: (context) => FoodPreferenceProvider(context.read<UserViewModel>()),
          update: (context, userViewModel, foodPreferenceProvider) => foodPreferenceProvider!..updateUserViewModel(userViewModel),
        ),
        ChangeNotifierProxyProvider<FoodPreferenceProvider, EstablishmentViewModel>(
          create: (context) => EstablishmentViewModel(Provider.of<UserViewModel>(context, listen: false), Provider.of<FoodPreferenceProvider>(context, listen: false)),
          update: (context, foodPreferenceProvider, establishmentViewModel) {
            establishmentViewModel!.listenToPreferences(foodPreferenceProvider);
            return establishmentViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartViewModel(
            offerViewModel: Provider.of<OfferViewModel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (context) => ReservationViewModel()),
        ChangeNotifierProvider(create:  (context) => ReviewViewModel("")),
        ChangeNotifierProvider(
          create: (_) => NavigationModel(),)
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer<CartViewModel>(
            builder: (context, cartViewModel, _) {
              return Stack(
                children: [
          
                  GetMaterialApp(
                    // ignore: deprecated_member_use
                    useInheritedMediaQuery: true,
                    builder: DevicePreview.appBuilder,
                    locale: DevicePreview.locale(context),
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      pageTransitionsTheme: const PageTransitionsTheme(builders: {
                        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      }),
                    ),
                    title: 'YummyGo',
                    initialRoute: '/',
                    navigatorKey: NavigationService.navigatorKey,
                    routes: {
                      '/': (context) => const SplashScreen(),
                      '/onboard': (context) => OnBoard(),
                      '/home': (context) => const Home(),
                    },
                  ),

                ],
              );
            },
          ),
        );
      },

    );
  }
}
