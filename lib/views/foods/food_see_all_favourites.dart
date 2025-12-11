import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodScreenFavourites extends StatefulWidget {
  const FoodScreenFavourites({super.key});

  @override
  _FoodScreenFavouritesState createState() => _FoodScreenFavouritesState();
}

class _FoodScreenFavouritesState extends State<FoodScreenFavourites> {
   
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()..getFavouriteFood(userViewModel.userData!.id)),
      ],
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
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/left-arrow.png',
                            width: 18.w, height: 18.w),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'Votre liste de favoris',
                        style: AppStyles.interboldHeadline5
                            .medium()
                            .withColor(Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: context.width(),
                    height: context.height() - 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Consumer<UserViewModel>(
                      builder: (context, userviewmodel, child) {
                        if (userviewmodel.isLoading) {
                          return CustomScrollView(
                            slivers: [
                              SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return const Center(child: ShimmerFoodCard());
                                  },
                                  childCount: 10, // Number of shimmer items to display
                                ),
                              ),
                            ],
                          );
                        } else if (userviewmodel.favouritefood!.isEmpty) {
                          return const Center(child: Text('Votre liste de favoris est vide' , style: TextStyle(color: Colors.blueGrey),));
                        }  else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: CustomScrollView(
                              slivers: [
                                SliverGrid(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.9,
                                   mainAxisSpacing: 10.0,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Center(
                                        child: FoodCard(
                                          food: userviewmodel.favouritefood![index],
                                        ).onTap(() {
                                          // Handle tap
                                        }),
                                      );
                                    },
                                    childCount: userviewmodel.favouritefood!.length,
                                  ),
                                ),
                                const SliverToBoxAdapter(
                                  child:  SizedBox(height: 20.0),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerFoodCard extends StatelessWidget {
  const ShimmerFoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white, // Shadow color
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 160.0,
                            height: 110.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 50.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 20.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 30.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 16.0,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 13.0,
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.grey,
                size: 22.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}