import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';


class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  void initState() {
    super.initState();
   // final userViewModel = Provider.of<UserViewModel>(context, listen: false);
   // userViewModel.verifFoodFavourite(widget.food.id, userViewModel.userData!.id);
  }
  String _formatText(String text) {
  const int maxChars = 20; // Maximum number of characters allowed
  if (text.length > maxChars) {
    return "${text.substring(0, maxChars)}...";
  }
  return text;
}

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    
    return Stack(
      
      children: [
        SizedBox(
          width: 120.0,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    

                    color: Colors.white, // Shadow color
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                    blurStyle: BlurStyle.solid // changes position of shadow
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
                          child: CachedNetworkImage(
                            width: 120.0,
                            height: 100.0,
                            imageUrl: widget.product.image,
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
                                Image.asset('images/placeholder.png' , width: 80.0, height: 80.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox( height: 5,),
                    Row(
                      children: [
                        Expanded(
                           child : Text(
  _formatText(widget.product.name), // Format text to ensure ellipsis after 20 characters
  style: AppStyles.interboldHeadline1.withSize(12)
       // Adjust font size for grid
      .withColor(AppColors.background),
   // Allow text to span across two lines
  overflow: TextOverflow.visible, // Ensure text can wrap to two lines
),
                        ),
                      ],
                    ),
                    Row(
  children: [
    Text(
      widget.product.isAvailable ? 'In Stock' : 'Out of Stock',
      style: kTextStyle.copyWith(
        color: widget.product.isAvailable ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,fontSize: 7
      ),
    ),
  ],
),

                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    'TND',
                                    style: TextStyle(
                                      color: kGreyTextColor,
                                      fontSize: 5.0,
                                    )
                                    
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.product.price.toString(),
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            cartViewModel
                                .addItem(null, 1,offer: null,product: widget.product)
                                .then((success) {
                              if (success) {
                                showCustomToast(context,
                                    "${''} added to cart");
                              } else {
                                showCustomToast(context,
                                    "You cannot add items from different restaurants to the cart",
                                    isError: true);
                              }
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 9.0,
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: kMainColor,
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
       
         /* Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            final isFavourite = userViewModel.getFavouriteStatus(widget.food.id);
        
            return Positioned(
              top: 10.0,
              right: 10.0,
              child: GestureDetector(
                onTap: () async {
                  if (isFavourite) {
                    await userViewModel.removeFoodsFromFavourites(
                        widget.food.id, userViewModel.userData!.id);
                  } else {
                    await userViewModel.addFoodsToFavourites(
                        widget.food.id, userViewModel.userData!.id);
                  }
                  await userViewModel.verifFoodFavourite(
                      widget.food.id, userViewModel.userData!.id);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 13.0,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFavourite ? Colors.red : Colors.grey,
                    size: 22.0,
                  ),
                ),
              ),
            );
          },
        )*/
      ],
    );
  }
}