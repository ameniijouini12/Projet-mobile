import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/views/details/establishment.details.dart';
import 'package:hiatunisie/views/home/establishment_detail_grid.dart';
import 'package:hiatunisie/views/home/establishment_search_delegate.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  Widget build(BuildContext context) {
      final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

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
                        'Nearly Establishments',
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                       const SizedBox(width: 100,),
            IconButton(
              icon: const Icon(Icons.search,color: Colors.white,),
              onPressed: () async {
                final selected = await showSearch(
                  context: context,
                  delegate: EstablishmentSearchDelegate(Provider.of<EstablishmentViewModel>(context, listen: false),), // Replace with your custom SearchDelegate
                );
                // Handle search results if needed
              },
            ),
        
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    width: context.width()+30,
                    height: context.height(),
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
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.85,
                          crossAxisCount: 2,
                          children: List.generate(
                            establishmentViewModel.establishments.length,
                            (index) => Center(
                              child: BookTableCardGrid(
                                restaurantData: establishmentViewModel.establishments[index],
                                index: index,
                                 isGrid: true,
                              ).onTap(() {
                                EstablishmentDetailsScreen(establishment: establishmentViewModel.establishments[index])
                                    .launch(context);
                              }),
                            ),
                          ),
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
