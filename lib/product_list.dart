
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  DBHelper dbHelper=DBHelper();

  List<String> productName=['Mango','Orange','Grapes','Banana','Cherry','Peach','Mixed Fruit Basket'];
  List<String> productUnit=['KG','Dozen','KG','Dozen','KG','KG','KG'];
  List<int> productPrice=[10,20,30,40,50,60,70];
  List<String> productImage=[
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/id/1291262112/photo/banana.jpg?s=1024x1024&w=is&k=20&c=bncXB5lxxXAUESs2o7ere02ravpiacIVLNmvh7yaFoM=',
    'https://media.istockphoto.com/id/181099124/photo/a-pile-of-cherries-with-leaves-attached.jpg?s=1024x1024&w=is&k=20&c=F08t7VYEhGPrTTwschSXifH8mo7MpzuZ8LUswzyc4sE=' ,
    'https://media.istockphoto.com/id/1151868959/photo/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white.jpg?s=1024x1024&w=is&k=20&c=zLb--kmGvSTUkjgSwVXForXx1C3WRSjGN77rXm_y6XM=',
    'https://media.istockphoto.com/id/481194973/photo/fruit-pile-isolated-on-white.jpg?s=1024x1024&w=is&k=20&c=9-fvhFO2sLPQ2mxMM1GN5wviUPj-XciFYw_X7zPeoHQ=' ,
  ];

  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions:  [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context,value,child){
                    return Text(value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),);
                  },
                ),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index){
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(productImage[index].toString())),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             Text(productName[index].toString(),style: const TextStyle(
                               fontWeight: FontWeight.w500,
                               fontSize: 16,
                             ),),
                             const SizedBox(height: 5,),
                             Text(productUnit[index].toString()+" " +r"$"+productPrice[index].toString(),
                               style: const TextStyle(
                               fontWeight: FontWeight.w500,
                               fontSize: 16,
                             ),),
                             const SizedBox(height: 5,),
                             Align(
                               alignment: Alignment.centerRight,
                               child: InkWell(
                                 onTap: () {
                                   dbHelper.insert(
                                     Cart(id: index,
                                         productId: index.toString(),
                                         productName: productName[index].toString(),
                                         initialPrice: productPrice[index],
                                         productPrice: productPrice[index],
                                         quantity: 1,
                                         unitTag: productUnit[index].toString(),
                                         image: productImage[index].toString())
                                   ).then((value) {
                                     if (kDebugMode) {
                                       print('Product is added to cart');
                                     }
                                     cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                     cart.addCounter();
                                   }).onError((error,stackTrace){
                                     if (kDebugMode) {
                                       print(error.toString());
                                     }
                                   });
                                 },
                                 child: Container(
                                   height: 35,
                                   width: 100,
                                   decoration:  BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.circular(5),
                                   ),
                                   child: const Center(child: Text('Add to cart',style: TextStyle(color: Colors.white),)),
                                 ),
                               ),
                             ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
