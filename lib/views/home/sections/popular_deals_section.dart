import "package:hiatunisie/models/food.model.dart";
import "package:hiatunisie/utils/connectivity_manager.dart";
import "package:hiatunisie/views/home/exports/export_homescreen.dart";

class PopularDealsSection extends StatelessWidget {
  const PopularDealsSection({super.key});

  List<Food> _getTopRatedFoods(List<Food> foods) {
    final sortedFoods = List<Food>.from(foods);
    sortedFoods.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sortedFoods.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Text(
                'Nos bons plans',
                style: kTextStyle.copyWith(
                  color: Colors.blueGrey,
                  fontSize: 18.0,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodScreen(),
                    ),
                  );
                },
                child: Text(
                  'Voir tout',
                  style: kTextStyle.copyWith(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer2<FoodViewModel, ConnectivityManager>(
            builder: (context, foodViewModel, connectivityManager, child) {
              if (foodViewModel.isLoading  || connectivityManager.isCheckingConnection) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (_, __) => Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                );
              }  else if (foodViewModel.foods.isEmpty) {
                return Center(
                  child: SizedBox(
                    height: 80,
                    child: Text(
                      'Pas de données',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),
                );
              } else {
                // Get only top 10 rated foods
                final topRatedFoods = _getTopRatedFoods(foodViewModel.foods);
                
                return HorizontalList(
                  spacing: 10,
                  itemCount: topRatedFoods.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FoodDetailsScreen(food: topRatedFoods[i]),
                          ),
                        );
                      },
                      child: FoodCard(food: topRatedFoods[i]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}