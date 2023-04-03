import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gecoory_web_panel/constants/common_function.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/model/product_model.dart';
import 'package:gecoory_web_panel/screens/main/home_screen.dart';
import 'package:gecoory_web_panel/services/products/products_firestore.dart';
import 'package:gecoory_web_panel/widgets/buttons_widget.dart';
import 'package:gecoory_web_panel/widgets/header_widget.dart';
import 'package:gecoory_web_panel/widgets/side_menu_widget.dart';
import 'package:gecoory_web_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/editproduct";
  final String productId;
  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _fromKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();

  late String _catValue;
  int _groupValue = 1;
  bool _isPiece = false;
  bool _isOnSale = false;
  File? _pickedImage;
  ProductModel? _prodcut;
  Uint8List _webImage = Uint8List(8);
  String? _imageUrl;
  final List<String> nameList = [
    "Vegetables",
    "Fruits",
    "Grains",
    "Herbs",
    "Nuts",
    "Spices"
  ];

  @override
  void initState() {
    _catValue = "Vegetables";
    getProductDetails();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  void deleteProduct({required context}) async {
    await ProductFireStore.deleteProduct(widget.productId);
    CommonFunctions.errorToast(
      error: "Product Deleted Sccussfully",
    );
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void getProductDetails() async {
    _prodcut = await ProductFireStore.getProductById(widget.productId);
    setState(() {
      _titleController.text = _prodcut!.title;
      _priceController.text = _prodcut!.price.toString();
      _salePriceController.text = _prodcut!.salePrice.toString();
      _catValue = _prodcut!.productCategory;
      _isPiece = _prodcut!.isPiece;
      _isOnSale = _prodcut!.isOnSale;
      _imageUrl = _prodcut!.imageUrl;
      _groupValue = _isPiece ? 2 : 1;
    });
  }

  void _uploadfrom() async {
    final isValid = _fromKey.currentState!.validate();
    if (isValid) {
      // if (_pickedImage == null) {
      //   CommonFunctions.errorToast(error: 'Please pick up an image');
      //   return;
      // }
      if (_pickedImage != null) {
        try {
          final ref = FirebaseStorage.instance
              .ref()
              .child('productImages')
              .child('${widget.productId}.jpg');
          if (kIsWeb) {
            await ref.putData(_webImage);
          } else {
            await ref.putFile(_pickedImage!);
          }
          _imageUrl = await ref.getDownloadURL();
        } catch (e) {
          CommonFunctions.errorToast(error: "$e");
        }
      }
      ProductFireStore.editProduct(
        ProductModel(
          id: widget.productId,
          title: _titleController.text,
          price: double.parse(_priceController.text),
          salePrice: double.parse(_salePriceController.text),
          imageUrl: _imageUrl == null ? _imageUrl! : _prodcut!.imageUrl,
          productCategory: _catValue,
          isOnSale: _isOnSale,
          isPiece: _isPiece,
        ),
      );
      _clearFrom();
      CommonFunctions.errorToast(error: "Product Uploaded Sccussfully");
    } else {
      CommonFunctions.errorToast(error: "Plase enter all detailes correctly");
    }
  }

  void _clearFrom() {
    _isPiece = false;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    setState(() {
      _pickedImage = null;
      _webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;
    final AppDimensions dimensions = AppDimensions(context);

    InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );

    return Scaffold(
      key: context.read<MenuControllerClass>().getAddProductscaffoldKey,
      drawer: const SideMenuWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenuWidget(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimensions.getScreenW(16)),
              child: Column(
                children: [
                  SizedBox(
                    height: dimensions.getScreenH(15),
                  ),
                  HeaderWidget(
                    press: () {
                      context
                          .read<MenuControllerClass>()
                          .controlAddProductsMenu();
                    },
                    text: 'Add Product',
                    showSearchField: false,
                  ),
                  Container(
                    width: size.width > 650 ? 650 : size.width,
                    padding: EdgeInsets.all(dimensions.getScreenW(16)),
                    margin: EdgeInsets.all(dimensions.getScreenW(16)),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(dimensions.getScreenW(20))),
                    child: Form(
                      key: _fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            text: "Product Title *",
                            color: color,
                            textSize: dimensions.getScreenW(20),
                            isTitle: true,
                          ),
                          SizedBox(
                            height: dimensions.getScreenH(10),
                          ),
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Title';
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                          ),
                          SizedBox(
                            height: dimensions.getScreenH(20),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: "Product Price *",
                                        color: color,
                                        textSize: dimensions.getScreenW(20),
                                        isTitle: true,
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenH(10),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          controller: _priceController,
                                          key: const ValueKey('Price \$'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]'),
                                            ),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenH(20),
                                      ),
                                      TextWidget(
                                        text: "Product Category *",
                                        color: color,
                                        textSize: dimensions.getScreenW(20),
                                        isTitle: true,
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenH(10),
                                      ),
                                      // drop down
                                      Container(
                                        color: scaffoldColor,
                                        child: _categoryDropDown(),
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenH(20),
                                      ),
                                      TextWidget(
                                        text: "Measue Unit *",
                                        color: color,
                                        textSize: dimensions.getScreenW(20),
                                        isTitle: true,
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenH(10),
                                      ),
                                      Row(
                                        children: [
                                          TextWidget(
                                              text: 'KG',
                                              color: color,
                                              textSize:
                                                  dimensions.getScreenW(20)),
                                          Radio(
                                            value: 1,
                                            groupValue: _groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _groupValue = 1;
                                                _isPiece = false;
                                              });
                                            },
                                            activeColor: Colors.red,
                                          ),
                                          SizedBox(
                                            width: dimensions.getScreenH(10),
                                          ),
                                          TextWidget(
                                            text: 'Piece',
                                            color: color,
                                            textSize: dimensions.getScreenW(20),
                                          ),
                                          Radio(
                                            value: 2,
                                            groupValue: _groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _groupValue = 2;
                                                _isPiece = true;
                                              });
                                            },
                                            activeColor: Colors.red,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenW(15),
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: color,
                                            value: _isOnSale,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _isOnSale = newValue!;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: dimensions.getScreenW(5),
                                          ),
                                          TextWidget(
                                            text: 'On Sale',
                                            color: color,
                                            isTitle: true,
                                            textSize: dimensions.getScreenW(20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: dimensions.getScreenW(5),
                                      ),
                                      AnimatedSwitcher(
                                        duration: const Duration(seconds: 1),
                                        child: !_isOnSale
                                            ? Container()
                                            : SizedBox(
                                                width:
                                                    dimensions.getScreenW(100),
                                                child: TextFormField(
                                                  controller:
                                                      _salePriceController,
                                                  key: const ValueKey(
                                                      'Price \$'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Price is missed';
                                                    }
                                                    return null;
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(r'[0-9.]'),
                                                    ),
                                                  ],
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: scaffoldColor,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: color,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: color,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(dimensions.getScreenW(20)),
                                  child: Container(
                                    height: size.width > 650
                                        ? 270
                                        : size.width * 0.40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(
                                        dimensions.getScreenW(20),
                                      ),
                                    ),
                                    child: _pickedImage == null
                                        ? dotborder(
                                            url: _prodcut == null
                                                ? "Image"
                                                : _prodcut!.imageUrl,
                                            color: color,
                                            dimensions: dimensions)
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                dimensions.getScreenW(12)),
                                            child: kIsWeb
                                                ? Image.memory(
                                                    _webImage,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.file(
                                                    _pickedImage!,
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _pickImage();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          color: Colors.blue,
                                          textSize: dimensions.getScreenW(18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  press: () {
                                    CommonFunctions.warningDialog(
                                      title: "Are you sure?",
                                      subtitle:
                                          "Delete ${_prodcut!.title} product",
                                      fct: () {
                                        deleteProduct(context: context);
                                      },
                                      context: context,
                                    );
                                  },
                                  text: 'Delete',
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  text: 'Update',
                                  icon: IconlyBold.upload,
                                  backgroundColor: Colors.blue,
                                  press: () {
                                    _uploadfrom();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        CommonFunctions.errorToast(error: 'No Image Picked');
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var file = await image.readAsBytes();
        setState(() {
          _webImage = file;
          _pickedImage = File('a');
        });
      } else {
        CommonFunctions.errorToast(error: 'No Image Picked');
      }
    } else {
      CommonFunctions.errorToast(error: 'Error Picking Image');
    }
  }

  Widget dotborder(
      {required Color color,
      required AppDimensions dimensions,
      required String url}) {
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: EdgeInsets.all(dimensions.getScreenW(8)),
      child: DottedBorder(
        dashPattern: const [6, 7],
        borderType: BorderType.RRect,
        color: color,
        radius: Radius.circular(dimensions.getScreenW(20)),
        child: Center(
          child: Image(
            fit: BoxFit.fill,
            height: size.width * 0.18,
            width: size.width * 0.18,
            image: NetworkImage(
              url,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            value: _catValue,
            onChanged: (value) {
              setState(() {
                _catValue = value!;
              });
            },
            hint: const Text('Select a category'),
            items: nameList.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 15),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
