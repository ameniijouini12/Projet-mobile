import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

import '../../views/home/sections/food_card_viewmodel.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => FoodCardViewModel(
        food: food,
        userViewModel: userViewModel,
      ),
      child: Consumer<FoodCardViewModel>(
        builder: (context, viewModel, _) {
          return Stack(
            children: [
              SizedBox(
                width: 160.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 190.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                width: 160.0,
                                height: 120.0,
                                imageUrl: food.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.grey, Colors.white],
                                  ),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset('images/placeholder.png', width: 100, height: 100),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                food.name,
                                style: TextStyle(
                                  color: kTitleColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${food.getFormattedPrice()} DT",
                              style: TextStyle(
                                color: kTitleColor,
                                fontSize: 13.0,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  food.averageRating.toString(),
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                                const SizedBox(width: 1.0),
                                Image.asset(
                                  food.averageRating > 3
                                      ? 'images/icon_rate2.png'
                                      : 'images/icon_rate1.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ❤️ Favorite Button
              Positioned(
                top: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: viewModel.toggleFavourite,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 13.0,
                    child: Icon(
                      Icons.favorite_rounded,
                      color: viewModel.isFavourite ? Colors.red : Colors.grey,
                      size: 22.0,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

