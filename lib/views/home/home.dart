import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/card/cart_screen.dart';
import 'package:hiatunisie/views/offers/fetch_offers.dart';
import 'package:hiatunisie/views/profile/profile_screen.dart';
import 'package:hiatunisie/widgets/smart_scaffold.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import 'home_screen.dart';
class Home extends StatefulWidget {
  final int initialIndex;
  const Home({super.key, this.initialIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );
  final ValueNotifier<int> _selectedItemPosition = ValueNotifier<int>(0);
  late PageController _pageController;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CartScreen(),
    OffersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedItemPosition.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    HomeController.instance.pageController = _pageController;
    HomeController.instance.selectedTab = _selectedItemPosition;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,result){
        if (_selectedItemPosition.value != 0) {
          _selectedItemPosition.value = 0;
          _pageController.jumpToPage(0);
          return;
        }
        SystemNavigator.pop();      },
      child: Consumer2<CartViewModel, UserViewModel>(
        builder: (context, cartViewModel, userViewModel, child) {
      
          return ValueListenableBuilder<int>(
            valueListenable: _selectedItemPosition,
            builder: (context, selectedIndex, child) {
              return Stack(
                children: [
                  SmartScaffold(
                    body: Consumer<ConnectivityManager>(
                      builder: (context, connectivityManager, child) {
                        return Column(
                          children: [
                            (!connectivityManager.isConnected || !connectivityManager.hasInternetConnection || !connectivityManager.hasServerConnection)
                                ? Container(
                              width: double.infinity,
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.all(25.0),
                                child:  Text(
                                  "Vous êtes hors ligne",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    _selectedItemPosition.value = index;
                                  },
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: _widgetOptions,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    bottomNavigationBar: Container(
                      height: 78.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: _borderRadius,
                      ),
                      child: SnakeNavigationBar.color(
                        backgroundColor: Colors.white,
                        behaviour: SnakeBarBehaviour.floating,
                        snakeShape: SnakeShape.rectangle.copyWith(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        snakeViewColor: kMainColor,
                        unselectedItemColor: kMainColor,
                        currentIndex: selectedIndex,
                        onTap: (index) {
                          _selectedItemPosition.value = index;
                          _pageController.jumpToPage(index);
                        },
                        items: [
                          const BottomNavigationBarItem(
                            icon: Icon(
                              FontAwesomeIcons.houseChimney,
                              size: 20.0,
                            ),
                            label: 'Accueil',
                          ),
      
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: [
                                Icon(
                                  FontAwesomeIcons.cartShopping,
                                  size: 20.0,
                                ),
                                if (cartViewModel.cartLength > 0)
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 11,
                                        minHeight: 11,
                                      ),
                                      child: Text(
                                        '${cartViewModel.cartLength}',
                                        style: TextStyle(
                                          color: selectedIndex == 2 ? kMainColor : Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            label: 'Panier',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(
                              FontAwesomeIcons.box,
                              size: 20.0,
                            ),
                            label: 'Offres',
                          ),
                          BottomNavigationBarItem(
                            icon: Consumer<UserViewModel>(
                              builder: (context, userViewModel, child) {
                                if (userViewModel.userData == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: kMainColor,
                                    ),
                                  );
                                }
                                return userViewModel.userData!.profileImage != null
                                    ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    userViewModel.userData!.profileImage!,
                                  ),
                                  radius: 12, // Taille de l'image dans le BottomNavigationBar
                                )
                                    : const Icon(
                                  FontAwesomeIcons.user,
                                  size: 20.0,
                                );
                              },
                            ),
                            label: 'Profil',
                          ),
                        ],
                        selectedLabelStyle: const TextStyle(fontSize: 12),
                        unselectedLabelStyle: const TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
      
                  // Floating cart button
                  if (cartViewModel.cartLength > 0 && selectedIndex != 1)
                    Positioned(
                      bottom: 88.0, // Position above the bottom navigation bar
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _selectedItemPosition.value = 1;
                            _pageController.jumpToPage(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kMainColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.cartShopping, size: 18.0),
                              const SizedBox(width: 10),
                              Text(
                                'Continuer vers panier ${cartViewModel.getTotalPrice()}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
