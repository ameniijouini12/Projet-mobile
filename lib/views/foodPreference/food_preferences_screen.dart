import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/views/foodPreference/food_pref_provider.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/views/home/home.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:hiatunisie/widgets/smart_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';

class FoodPreferencePage extends StatefulWidget {
  const FoodPreferencePage({super.key});

  @override
  _FoodPreferencePageState createState() => _FoodPreferencePageState();
}

class _FoodPreferencePageState extends State<FoodPreferencePage> {
  final List<Map<String, String>> preferences = [
    {"name": "Fast Food", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cFleHkr83XTp-0AALLRqiAOs7nZxme-OVQ&s"},
    {"name": "Vegan", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL9OQtcrVw008g09nazD3hsedG7PT8cYRlNg&s"},
    {"name": "Sugar", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUdYBMUuJ-a-yWuCNnYf6X43CyBVlYrsctQ&s"},
    {"name": "Nut-Free", "image": "https://www.tastingtable.com/img/gallery/25-most-popular-snacks-in-america-ranked-worst-to-best/intro-1645492743.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePreferences();
    });
  }

  void _initializePreferences() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final foodPreferenceProvider =
        Provider.of<FoodPreferenceProvider>(context, listen: false);

    foodPreferenceProvider.initializePreferences(userViewModel.foodPreference);
  }

  @override
  Widget build(BuildContext context) {
    final foodPreferenceProvider = Provider.of<FoodPreferenceProvider>(context);

    return  SmartScaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(40.0),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Sélectionnez vos préférences',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: preferences.length,
                            itemBuilder: (context, index) {
                              String prefName = preferences[index]['name']!;
                              String prefImage = preferences[index]['image']!;
                              bool isSelected = foodPreferenceProvider
                                  .selectedPreferences[prefName]!;

                              return GestureDetector(
                                onTap: () {
                                  foodPreferenceProvider
                                      .togglePreference(prefName);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: isSelected
                                          ? kMainColor.withOpacity(0.3)
                                          : Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10.0)),
                                          child: CachedNetworkImage(
                                            imageUrl: prefImage,
                                            height: 100.0,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  prefName,
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Checkbox(
                                                activeColor: kMainColor,
                                                value: isSelected,
                                                onChanged: (bool? value) {
                                                  foodPreferenceProvider
                                                      .togglePreference(
                                                          prefName);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                          ButtonGlobal(
                                    buttonTextColor: Colors.white,
                                    buttontext: foodPreferenceProvider.isLoading ? 'Chargement...' : 'Enregistrer',
                                    buttonDecoration: kButtonDecoration.copyWith(color: foodPreferenceProvider.isLoading ? gray : kMainColor),
                                    onPressed: () {
                                      final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
                                      final marketViewModel = Provider.of<MarketViewModel>(context, listen: false);

                                      foodPreferenceProvider.savePreferences().then((_) async {
                                        establishmentViewModel.updateRecommendedEstablishments();
                                        if (!foodPreferenceProvider.isLoading) {
                                          showCustomToast(context, 'Préférences enregistrées avec succès');
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) => const Home()),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                                          await marketViewModel.refreshMarkets() ; 

                                      });
                                    },
                                  ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Vos préférences nous permettront de vous recommander des établissements qui vous correspondent. Vous pourrez les modifier à tout moment dans les paramètres de votre compte.',


                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}
