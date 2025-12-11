import 'package:flutter/material.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _selectedImage;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.product.image;
  }

  void _changeSelectedImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSmallImagesColumn(),
                _buildLargeImage(),
              ],
            ),
            _buildProductDetails(),
            _buildPriceAndQuantity(cartViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallImagesColumn() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _buildSmallImage(widget.product.image),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeImage() {
    return Expanded(
      child: Container(
        height: 400,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Image.network(
          _selectedImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "The iPhone 14 is crafted from lightweight and durable space-grade titanium, featuring a textured matte glass back. It boasts a ceramic shield front capable of withstanding more than typical smartphone glass. Additionally, it is water and dust resistant.",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 180, 224, 189),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color.fromARGB(255, 22, 80, 36),
                  size: 25,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "Specification du produit",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndQuantity(CartViewModel cartViewModel) {
    double discount = 0.2; // 20% discount
    double discountedPrice = widget.product.price * (1 - discount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.product.price.toStringAsFixed(2)} TND',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough, // Strike-through
                    ),
                  ),
                  Text(
                    '${discountedPrice.toStringAsFixed(2)} TND',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              _buildQuantityChanger(),
            ],
          ),
          const SizedBox(height: 40),
          _buildAddToCartButton(cartViewModel),
        ],
      ),
    );
  }

  Widget _buildQuantityChanger() {
    return Container(
      width: 180,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (quantity > 1) quantity -= 1;
              });
            },
            child: const Icon(
              Icons.remove,
              color: Colors.black,
            ),
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                quantity += 1;
              });
            },
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(CartViewModel cartViewModel) {
    return Container(
      width: 180,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 75, 13),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialButton(
        onPressed: () {
          cartViewModel
              .addItem(null, quantity, offer: null, product: widget.product)
              .then((success) {
            if (success) {
              showCustomToast(context, "${widget.product.name} added to cart");
            } else {
              showCustomToast(
                context,
                "You cannot add items from different restaurants to the cart",
                isError: true,
              );
            }
          });
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Panier",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallImage(String imagePath) {
    bool isSelected = _selectedImage == imagePath;

    return GestureDetector(
      onTap: () {
        _changeSelectedImage(imagePath);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 244, 245, 248),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 178, 231, 194)
                : const Color.fromARGB(255, 244, 245, 248),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
