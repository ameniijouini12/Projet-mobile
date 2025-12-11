import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/models/offer.model.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    // Accessing the OfferViewModel instance using Provider
    final offerViewModel = Provider.of<OfferViewModel>(context);

    // Fetch offers for the current establishment ID when screen initializes
    final List<Offer> offers = offerViewModel.offers;

    return SmartScaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width,
            height: 280.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/hiaauthbgg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(height: 60.0),

                    const SizedBox(
                      width: 150,
                    ),
                    // Add more widgets here if necessary
                  ],
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
                            'Aucune offre disponible',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 80.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BoxDetailsScreen(
                                                      box: offers[index]),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                              ],
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
  }
}
