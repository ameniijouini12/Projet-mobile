import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

import '../BookTableCard.dart';

class NearlySection extends StatelessWidget {
  const NearlySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Text(
                'Les plus proches',
                style: kTextStyle.copyWith(
                  color: Colors.blueGrey,
                  fontSize: 18.0,
                ),
              ),
              const Spacer(),
              Text(
                'Voir tout',
                style: kTextStyle.copyWith(color: Colors.blueGrey),
              ).onTap(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer2<EstablishmentViewModel, ConnectivityManager>(
            builder: (context, establishmentViewModel, connectivityManager, child) {
              if (establishmentViewModel.isLoading || establishmentViewModel.isSorting || connectivityManager.isCheckingConnection) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (_, __) => Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                );
              }  else if (establishmentViewModel.establishments.isEmpty) {
                return const Center(
                  child: Text(
                    'Pas de restaurant trouvé',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return HorizontalList(
                spacing: 10,
                itemCount: establishmentViewModel.establishments.length,
                itemBuilder: (_, i) {
                  return BookTableCard(
                    establishment: establishmentViewModel.establishments[i],
                    index: i,
                  ).onTap(
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EstablishmentDetailsScreen(
                            establishment: establishmentViewModel.establishments[i],
                          ),
                        ),
                      );
                    },
                    highlightColor: context.cardColor,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}