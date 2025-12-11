import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/offer.viewmodel.dart';
import 'package:hiatunisie/views/details/box_details_screen.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/widgets/homescreen/box_card.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant.dart';

class OffersEstablishmentScreen extends StatefulWidget {
  final String id;

  const OffersEstablishmentScreen({super.key, required this.id});

  @override
  _OffersEstablishmentScreenState createState() =>
      _OffersEstablishmentScreenState();
}

class _OffersEstablishmentScreenState extends State<OffersEstablishmentScreen> {
  @override
  Widget build(BuildContext context) {
    // Accessing the OfferViewModel instance using Provider
    final offerViewModel = Provider.of<OfferViewModel>(context);

    // Fetch offers for the current establishment ID when screen initializes
    final List<Offer> offers = offerViewModel.getOffersByEstablishment(widget.id);

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
                        'Available Offers',
                        style: kTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 130,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: context.width(),
                    height: context.height() - 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: offers.isEmpty
                        ? const Center(
                            child: Text(
                              'No offers available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Column(
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
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 5.0,
                                  children: List.generate(
                                    offers.length,
                                    (index) => Center(
                                      child: SurpriseBoxCard(
                                        offer: offers[index],
                                         isGrid: true,
                                      ).onTap(() {
                                        // Handle offer selection 
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BoxDetailsScreen(box: offers[index]),
                                          ),
                                        );
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
