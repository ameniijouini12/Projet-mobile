import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiatunisie/views/foods/food_see_all_favourites.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/map/map_positions.dart';
import 'package:hiatunisie/views/profile/edit_profile.dart';
import 'package:hiatunisie/views/profile/order_tracking/order_history.dart';
import 'package:hiatunisie/widgets/profilescreen/info_bottom_sheet.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final String getGreeting = () {
      final int hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Bonjour';
      }
      if (hour < 17) {
        return 'Bonjour';
      }
      return 'Bonsoir';
    }();


    return SmartScaffold(
    
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: MediaQuery.of(context).size.width,
              height: 400.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/hiaauthbgg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
            SingleChildScrollView(
              child: Column(
                children: [
                   SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    width: context.width(),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Consumer<UserViewModel>(
                          builder:(context, userViewModel, child) {
                          final user = userViewModel.userData;
                          return Column(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  height: 80.0,
                                  width: 80.0,
                                  child: CachedNetworkImage(
                                    imageUrl:  user?.profileImage ?? 'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png',
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                                    const SizedBox(
                                      height: 10.0,
                              ),
                              Text(
                                '$getGreeting, ${user?.firstName ?? ''}',
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0,
                                ),
                              ),
                              Text(
                                user?.phone  ?? '',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ],
                          );
                        },
                          ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            const EditProfile().launch(context);
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Mon profil',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            const FoodScreenFavourites().launch(context);
                                            
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.favorite_border_outlined,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Mes favoris',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            const OrderHistoryScreen().launch(context);
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Suivi de commande',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            // Show dialog when ListTile is tapped
                                            showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(30),
                                                    topLeft: Radius.circular(30),
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                isScrollControlled: true,
                                                barrierColor: const Color.fromRGBO(21, 43, 64, 0.75),
                                                context: context,
                                                builder: (context) {
                                                  return infoBottomSheet();
                                                }
                                            );
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return CustomDialog(
                                            //       title:
                                            //           'Voulez-vous vraiment vous déconnecter?',
                                            //       content: '',
                                            //       onCancel: () {
                                            //         Navigator.of(context).pop(
                                            //             false); // Dismiss dialog
                                            //       },
                                            //       onConfirm: () async {
                                            //         final userViewModel =
                                            //             Provider.of<
                                            //                     UserViewModel>(
                                            //                 context,
                                            //                 listen: false);
                                            //
                                            //         Navigator.of(context)
                                            //             .pushAndRemoveUntil(
                                            //           MaterialPageRoute(
                                            //               builder: (context) =>
                                            //                   const SignIn()),
                                            //           (Route<dynamic> route) =>
                                            //               false, // Remove all routes
                                            //         );
                                            //          await userViewModel
                                            //             .logout();
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.logout,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Déconnexion',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: kGreyTextColor),
                                        ),
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),const Gap(20),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}
