import 'package:flutter/material.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/viewmodels/food_viewmodel.dart';
import 'package:hiatunisie/views/foods/food_search_delegate.dart';
import 'package:hiatunisie/widgets/homescreen/food_card.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';

class FoodSeeAllScreenEstablishment extends StatefulWidget {
  const FoodSeeAllScreenEstablishment({super.key, required this.product});

    final Market product;


  @override
  _FoodSeeAllScreenEstablishmentState createState() => _FoodSeeAllScreenEstablishmentState();
}

class _FoodSeeAllScreenEstablishmentState extends State<FoodSeeAllScreenEstablishment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
        final establishmentviewmodel = Provider.of<EstablishmentViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
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
              child: Column(
                children: [
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
                        widget.product.name,
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                      const SizedBox(width: 130,),
                      IconButton(
                        icon: const Icon(Icons.search,color: Colors.white,),
                        onPressed: () async {
                          final selected = await showSearch(
                            context: context,
                            delegate: FoodSearchDelegate(Provider.of<EstablishmentViewModel>(context, listen: false),), // Replace with your custom SearchDelegate
                          );
                          // Handle search results if needed
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: context.width(),
                    height: context.height()+100,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            children: List.generate(
                              establishmentviewmodel.foodbyestablishment!.length,
                              (index) => Center(
                                child: FoodCard(
                                  food: establishmentviewmodel.foodbyestablishment![index],
                                ).onTap(() {
                                  // Handle tap
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
