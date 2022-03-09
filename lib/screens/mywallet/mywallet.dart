import 'dart:ui';
import 'package:yellox_driver_app/components/custom_drawer.dart';
import 'package:flutter/material.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({ Key? key }) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 214, 28, 1),//Color(0xfffbca31),
      appBar: AppBar(
        title: Text('My Wallet', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(icon: Icon(Icons.menu_sharp, color: Colors.black,),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications, 
              color: Colors.lightBlue,
            ),
            tooltip: 'Back Icon',
            onPressed: () {},
          ),
        ]
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              height: 200,
              margin: const EdgeInsets.fromLTRB(20,50,20,20),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text( 'Total Earnings', 
                      style: 
                        TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ), 
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('₱1500.00', 
                      style: 
                        TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ), 
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 140,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.money,
                              size: 24.0,
                            ),
                            label: Text('Cashout'),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 140,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 24.0,
                          ),
                          label: Text('Add Money'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical:0, horizontal:21),
              child: Text(
                'Payment History', 
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38,
                  letterSpacing: 0.6,
                )
              ),
            ),
            Column(
              children: [
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/128/3011/3011270.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/128/3011/3011270.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding( // Image Icon
                      padding: const EdgeInsets.fromLTRB(20,20,15,20),
                      child: Image(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/128/3011/3011270.png'), 
                        width: 50, 
                        height: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,100,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text('Mary Conrad', 
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('#13134', 
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget> [
                        Text('₱100.00', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}