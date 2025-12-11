
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/home/search_bar_section.dart';
import 'package:hiatunisie/views/home/sections/nearly_section.dart';
import 'package:hiatunisie/views/home/sections/offers_section.dart';


import 'home_top_section.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<ConnectivityManager>(
        builder: (context, connectivityManager, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                HomeTopSection(),
                SizedBox(height: 10),
                SearchBarSection(),
                Expanded(
                  child: RefreshIndicator(
                    color: kMainColor,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      Provider.of<FoodViewModel>(context, listen: false).refreshFoods();
                      Provider.of<EstablishmentViewModel>(context, listen: false).refreshEstablishments();
                      Provider.of<OfferViewModel>(context, listen: false).refreshOffers();
                      Provider.of<MarketViewModel>(context, listen: false).refreshMarkets();
                    },
                    child:    Consumer<FoodViewModel>(
                        builder: (context, foodViewModel, child) {
                          List<FilterData> selectedFilterData = foodViewModel
                              .selectedFilters
                              .map((filter) => catData.firstWhere((data) =>
                          data.catTitle.toLowerCase() ==
                              filter.toLowerCase()))
                              .toList();
                          bool hasFilters = selectedFilterData.isNotEmpty;
                        return CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  if (hasFilters)
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Column(
                                        children: [
                                          Wrap(
                                            spacing: 14.0,
                                            children:
                                            selectedFilterData.map((filterData) {
                                              return FilterChipElement(
                                                catList: filterData,
                                                onRemove: () {
                                                  foodViewModel.removeFilter(
                                                      filterData.catTitle);
                                                },
                                              );
                                            }).toList(),
                                          ),
                                          Gap(5.h),
                                          const Divider(),
                                          Gap(5.h),
                                        ],
                                      ),
                                    ),
                                  if (hasFilters) const PopularDealsSection(),
                                /*  Consumer<OfferViewModel>(
                                    builder: (context, offerViewModel, child) {
                                      return offerViewModel.offers.isNotEmpty
                                          ? const OffersSection()
                                          : const SizedBox.shrink();
                                    },
                                  ),*/
                                 /* const NearlySection(),
                                  const RecommendedSection(),*/
                                  const Gap(30.0),
                                  if (!hasFilters) const PopularDealsSection(),
                                  const Gap(40.0),

                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    ),
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


