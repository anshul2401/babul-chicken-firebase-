import 'package:babul_chicken_firebase/providers/product.dart';
import 'package:babul_chicken_firebase/providers/products.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditProd extends StatefulWidget {
  const AddEditProd({Key key}) : super(key: key);

  @override
  _AddEditProdState createState() => _AddEditProdState();
}

class _AddEditProdState extends State<AddEditProd> {
  final _form = GlobalKey<FormState>();
  String productName;
  int price;
  String category;
  String plateAmount;
  String imgUrl;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: getBoldText('Add Product', 18, Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Form(
                  key: _form,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            // hintText: 'Product Name',
                            labelText: 'Product Name',
                          ),
                          autocorrect: false,
                          onSaved: (newValue) {
                            productName = newValue;
                          },
                          initialValue: productName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            // hintText: 'Product Name',
                            labelText: 'Price',
                          ),
                          autocorrect: false,
                          onSaved: (newValue) {
                            price = int.parse(newValue);
                          },
                          initialValue: price.toString(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            // hintText: 'Product Name',
                            labelText: 'Image url',
                          ),
                          autocorrect: false,
                          onSaved: (newValue) {
                            imgUrl = newValue;
                          },
                          initialValue: imgUrl,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      value: category,
                      //elevation: 5,
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'Starter',
                        'Main Course (Veg)',
                        'Main Course (Egg)',
                        'Main Course (Non Veg)',
                        'Salad',
                        'Roti and Bread',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: const Text(
                        "Category",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          category = value;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      value: plateAmount,
                      //elevation: 5,
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'Full Plate',
                        'Half Plate',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: const Text(
                        "Plate Amount",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          plateAmount = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  child: getNormalText(
                    'Save ',
                    15,
                    Colors.white,
                  ),
                  shape: const StadiumBorder(),
                  color: MyColor.primarycolor,
                  onPressed: () {
                    _saveForm();
                  },
                )
              ],
            ),
    );
  }

  _saveForm() {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return null;
    }

    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    var prodProvider = Provider.of<Products>(context, listen: false);
    prodProvider
        .addProduct(ProductItem(
            id: DateTime.now().toString(),
            name: productName,
            plateAmount: plateAmount,
            imgUrl: imgUrl,
            category: category,
            price: price))
        .catchError((error) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Somethineg went wrong'),
      ));
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product Added'),
      ));
    });
  }
}
