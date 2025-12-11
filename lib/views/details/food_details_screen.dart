import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/reviews/review_screen.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';

import '../../viewmodels/food/food_details_viewmodel.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.food});

  final Food food;

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;


  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => FoodDetailsViewModel(
        food: widget.food,
        userViewModel: userViewModel,
        cartViewModel: cartViewModel,
      ),
      child: Consumer<FoodDetailsViewModel>(
        builder: (context, viewModel, _) {
          return SmartScaffold(
            backgroundColor: Colors.white,
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
                SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ).onTap(() {
                                    Navigator.pop(context);
                                  }),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await viewModel.toggleFavourite();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red.withOpacity(0.1),
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: viewModel.isFavourite
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                              ],
                            ),
                          ), const SizedBox(height: 140.0),


                          Container(
                            width: context.width(),
                            height: context.height() - 170.0,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                const SizedBox(height: 70.0),
                                Text(
                                  widget.food.name,
                                  style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                // ✅ QUANTITY HANDLER
                                SizedBox(
                                  width: 100.0,
                                  height: 50.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kMainColor,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: viewModel.decreaseQuantity,
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            viewModel.quantity.toString(),
                                            style: kTextStyle.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: viewModel.increaseQuantity,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(20),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EstablishmentDetailsScreen(
                                            establishment:
                                                widget.food.establishment,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      widget.food.establishment.name,
                                      style: kTextStyle.copyWith(
                                        color: Colors.blueGrey,
                                        fontSize: 17.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),


                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Row(
                                    children: [
                                      const Gap(10),
                                      Text(
                                        '${widget.food.getFormattedPrice()} DT',
                                        style: kTextStyle.copyWith(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const Spacer(),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: widget.food.averageRating >= 5
                                                  ? Image.asset(
                                                'images/icon_rate2.png',
                                                width: 20.0,
                                                height: 20.0,
                                              )
                                                  : Image.asset(
                                                'images/icon_rate1.png',
                                                width: 20.0,
                                                height: 20.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.food.averageRating
                                                  .toString(),
                                              style: kTextStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(30),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewScreen(food: widget.food),
                                            ),
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child:    Image.asset(
                                                  'images/review_icon.png',
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${widget.food.reviews!.length} Reviews',
                                                style: kTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    widget.food.description,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ingredients',
                                        style: kTextStyle.copyWith(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const Spacer(),

                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children:
                                        widget.food.ingredients.map((ingredient) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Chip(
                                          label: Text(
                                            ingredient,
                                            style: kTextStyle.copyWith(
                                                color: Colors.blueGrey),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                // ✅ ADD TO CART BUTTON
                                ButtonGlobal(
                                  buttonTextColor: Colors.white,
                                  buttontext: 'Ajouter au Panier',
                                  buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor,
                                  ),
                                  onPressed: () async {
                                    final success =
                                        await viewModel.addToCart(context);
                                    if (success) {
                                      showCustomToast(context,
                                          "${widget.food.name} ajouté au panier");
                                      Navigator.pop(context);
                                    } else {
                                      showCustomToast(
                                        context,
                                        "You cannot add items from different restaurants to the cart",
                                        isError: true,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: CircleAvatar(
                          backgroundColor: kMainColor,
                          radius: MediaQuery.of(context).size.width / 4,
                          child: ClipOval(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                              child: CachedNetworkImage(
                                imageUrl: widget.food.image,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                    'images/placeholder.png',
                                    fit: BoxFit.cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
