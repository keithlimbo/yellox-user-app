import 'package:flutter/material.dart';
import 'package:yellox_driver_app/helpers/style.dart';

class PickupPage extends StatefulWidget {
  const PickupPage({Key? key}) : super(key: key);

  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: black,
                  ),
                  onPressed: () => Navigator.pop(context)),
        ),
        title: const Text(
          "Pickup",
          style: TextStyle(color: black),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    color: black,
                  )))
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600.0) {
            return _tabletPickupView();
          } else {
            return _phonePickupView();
          }
        },
      ),
      bottomNavigationBar: DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 0.4,
        // expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              controller: scrollController,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: primaryYellow,
                    child: const Icon(
                      Icons.person,
                      color: black,
                    ),
                  ),
                  title: const Text(
                    "Pick up at",
                    style: TextStyle(color: grey),
                  ),
                  subtitle: const Text(
                    "3305 Blue Spruce Lane",
                    style: TextStyle(fontSize: 18, color: black),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Table(
                    children: const [
                      TableRow(children: [
                        Center(
                          child: Text(
                            "EST",
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Distance",
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Fee",
                            style: TextStyle(color: grey),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Center(
                            child: Text(
                          "5 min",
                          style: TextStyle(fontSize: 18, height: 1.5),
                        )),
                        Center(
                            child: Text(
                          "2.2 km",
                          style: TextStyle(fontSize: 18, height: 1.5),
                        )),
                        Center(
                            child: Text(
                          "₱500.00",
                          style: TextStyle(fontSize: 18, height: 1.5),
                        ))
                      ])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "Drop-Off",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                const DirectionLists()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _phonePickupView() {
    return Container();
  }

  Widget _tabletPickupView() {
    return Container();
  }
}

class DirectionLists extends StatelessWidget {
  // final ScrollController controller;
  const DirectionLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: controller, // assign controller here
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, index) => Column(
        children: const [
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Point A to B"),
            subtitle: Text("10 miles"),
          ),
        ],
      ),
    );
  }
}
