import 'package:babul_chicken_firebase/admin/home_page.dart';
import 'package:babul_chicken_firebase/main.dart';
import 'package:babul_chicken_firebase/pages/cart.dart';
import 'package:babul_chicken_firebase/pages/contact_us.dart';
import 'package:babul_chicken_firebase/providers/cart.dart';
import 'package:babul_chicken_firebase/providers/cart_item.dart';
import 'package:babul_chicken_firebase/providers/product.dart';
import 'package:babul_chicken_firebase/providers/products.dart';
import 'package:babul_chicken_firebase/utils/carousel.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getBoldText('Hello, Welcome', 20, Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                // GestureDetector(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         getNormalText('Cancel Date Time', 15, Colors.black),
                //         Divider()
                //       ],
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AdminHomePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNormalText('Admin', 15, Colors.black),
                        Divider()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ContactUS()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNormalText('Contact Us', 15, Colors.black),
                        Divider()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNormalText('Log out', 15, Colors.black),
                        Divider()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: getBoldText(
                      Provider.of<Cart>(context).totalCartItem().toString(),
                      10,
                      MyColor.primarycolor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartPage()));
                      },
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                ],
              ),
            )
          ],
          backgroundColor: MyColor.primarycolor,
          centerTitle: true,
          title: getBoldText(
            'Babul Chicken',
            18,
            Colors.white,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CarouselWithIndicatorDemo(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            getExpansionTile('Starter'),
                            SizedBox(
                              height: 15,
                            ),
                            getExpansionTile('Main Course (Veg)'),
                            SizedBox(
                              height: 15,
                            ),
                            getExpansionTile('Main Course (Egg)'),
                            SizedBox(
                              height: 15,
                            ),
                            getExpansionTile('Main Course (Non Veg)'),
                            SizedBox(
                              height: 15,
                            ),
                            getExpansionTile('Salad'),
                            SizedBox(
                              height: 15,
                            ),
                            getExpansionTile('Roti and Bread'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget getExpansionTile(String category) {
    var productsProvider = Provider.of<Products>(context);
    List<ProductItem> product = productsProvider.getProductByCategory(category);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(
          category,
          style: GoogleFonts.varelaRound(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: product.length,
            itemBuilder: (context, index) {
              return getItemTile(product[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget getItemTile(ProductItem productItem) {
    var cartProvider = Provider.of<Cart>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                minRadius: 30,
                backgroundImage: NetworkImage(
                  productItem.imgUrl,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getNormalText(productItem.name, 14, Colors.black),
                  getNormalText(productItem.plateAmount, 13, Colors.grey),
                  getBoldText('₹ ${productItem.price}', 15, Colors.black)
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColor.primarycolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: GestureDetector(
                  onTap: () {
                    cartProvider.addToCart(
                      CartItem(
                        productItem: productItem,
                        id: DateTime.now().toString(),
                        qty: 1,
                      ),
                      true,
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getNormalText(
                  cartProvider.cartItemQty(productItem.id).toString(),
                  14,
                  Colors.black,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: MyColor.primarycolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: GestureDetector(
                  onTap: () {
                    cartProvider.cartItemQty(productItem.id) == 0
                        ? null
                        : cartProvider.cartItemQty(productItem.id) == 1
                            ? cartProvider.removeFromCart(productItem.id)
                            : cartProvider.addToCart(
                                CartItem(
                                  productItem: productItem,
                                  id: DateTime.now().toString(),
                                ),
                                false,
                              );
                  },
                  child: const Icon(Icons.remove),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
