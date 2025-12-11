import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/food_viewmodel.dart';
import 'package:hiatunisie/views/details/food_details_screen.dart';
import 'package:hiatunisie/views/foods/food_search_delegate_establishment.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/homescreen/food_card.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Add this import for shimmer effect
import '../../constant.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {

  @override
  Widget build(BuildContext context) {
    final foodViewModel = Provider.of<FoodViewModel>(context);

    return SmartScaffold(
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
            children: [
              const SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ).onTap(() {
                      Navigator.pop(context);
                    }),
                  ),
                  Text(
                    'Popular Deals',
                    style: kTextStyle.copyWith(
                        color: Colors.white, fontSize: 18.0),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search,color: Colors.white,),
                    onPressed: () async {
                      final selected = await showSearch(
                        context: context,
                        delegate: FoodSearchDelegateEstablishment(Provider.of<FoodViewModel>(context, listen: false),), // Replace with your custom SearchDelegate
                      );
                      // Handle search results if needed
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: Container(
                  width: context.width(),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!foodViewModel.isLoading &&
                            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                          foodViewModel.fetchFoods();
                          return true;
                        }
                        return false;
                      },
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: foodViewModel.foods.length + (foodViewModel.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == foodViewModel.foods.length) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: FoodCard(
                              food: foodViewModel.foods[index],
                            ).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodDetailsScreen(food: foodViewModel.foods[index]),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
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