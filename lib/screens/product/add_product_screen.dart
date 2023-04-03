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
import 'package:gecoory_web_panel/services/products/products_firestore.dart';
import 'package:gecoory_web_panel/widgets/buttons_widget.dart';
import 'package:gecoory_web_panel/widgets/header_widget.dart';
import 'package:gecoory_web_panel/widgets/side_menu_widget.dart';
import 'package:gecoory_web_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  static String routeName = "/addproduct";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _fromKey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _priceController;
  late String _catValue;
  int _groupValue = 1;
  bool isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
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
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _catValue = "Vegetables";
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _uploadfrom({required context}) async {
    final isValid = _fromKey.currentState!.validate();
    String? imageUrl;
    if (isValid) {
      if (_pickedImage == null) {
        CommonFunctions.errorToast(error: 'Please pick up an image');
        return;
      }
      final id = const Uuid().v4();
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child('$id.jpg');
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl = await ref.getDownloadURL();
      } catch (e) {
        CommonFunctions.errorToast(error: "$e");
      }
      ProductFireStore.addProduct(
        ProductModel(
          id: id,
          title: _titleController.text,
          price: double.parse(_priceController.text),
          salePrice: 0.0,
          imageUrl: imageUrl!,
          productCategory: _catValue,
          isOnSale: false,
          isPiece: isPiece,
        ),
      );
      _clearFrom();
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      CommonFunctions.errorToast(error: "Product Uploaded Sccussfully");
    } else {
      CommonFunctions.errorToast(error: "Plase enter all detailes correctly");
    }
  }

  void _clearFrom() {
    isPiece = false;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
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
                                                isPiece = false;
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
                                              textSize:
                                                  dimensions.getScreenW(20)),
                                          Radio(
                                            value: 2,
                                            groupValue: _groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _groupValue = 2;
                                                isPiece = true;
                                              });
                                            },
                                            activeColor: Colors.red,
                                          )
                                        ],
                                      )
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
                                            color: color,
                                            dimensions: dimensions)
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                dimensions.getScreenW(12)),
                                            child: kIsWeb
                                                ? Image.memory(
                                                    webImage,
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
                                          setState(() {
                                            _pickedImage = null;
                                            webImage = Uint8List(8);
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          color: Colors.red,
                                          textSize: dimensions.getScreenW(18),
                                        ),
                                      ),
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
                                    _clearFrom();
                                  },
                                  text: 'Clear form',
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  text: 'Upload',
                                  icon: IconlyBold.upload,
                                  backgroundColor: Colors.blue,
                                  press: () {
                                    _uploadfrom(context: context);
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
          webImage = file;
          _pickedImage = File('a');
        });
      } else {
        CommonFunctions.errorToast(error: 'No Image Picked');
      }
    } else {
      CommonFunctions.errorToast(error: 'Error Picking Image');
    }
  }

  Widget dotborder({required Color color, required AppDimensions dimensions}) {
    return Padding(
      padding: EdgeInsets.all(dimensions.getScreenW(8)),
      child: DottedBorder(
        dashPattern: const [6, 7],
        borderType: BorderType.RRect,
        color: color,
        radius: Radius.circular(dimensions.getScreenW(20)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                color: color,
                size: dimensions.getScreenW(50),
              ),
              SizedBox(
                height: dimensions.getScreenW(20),
              ),
              TextButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                      textSize: dimensions.getScreenW(18)))
            ],
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
