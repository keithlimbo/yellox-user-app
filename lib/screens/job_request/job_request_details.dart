import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellox_driver_app/components/custom_drawer.dart';
import 'package:yellox_driver_app/helpers/style.dart';
import 'package:yellox_driver_app/screens/pickup/pickup.dart';

class JobRequestDetailsPage extends StatefulWidget {
  const JobRequestDetailsPage({Key? key}) : super(key: key);

  @override
  State<JobRequestDetailsPage> createState() => _JobRequestDetailsPageState();
}

class _JobRequestDetailsPageState extends State<JobRequestDetailsPage> {
  bool isSwitched = true;
  String connStatus = "Online";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(
                    Icons.menu_sharp,
                    color: black,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        title: Text(
          connStatus,
          style: const TextStyle(color: black),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                      if (isSwitched == false) {
                        connStatus = "Offline";
                      } else {
                        connStatus = "Online";
                      }
                    });
                  },
                ),
              ))
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.white, //This will change the drawer background to blue.
          //other styles
        ),
        child: const CustomDrawer(),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600.0) {
            return _tabletJobRequestDetailsView();
          } else {
            return _phoneJobRequestDetailsView();
          }
        },
      ),
      bottomNavigationBar: SizedBox(
          height: kToolbarHeight + 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            )),
            child: const Text(
              "GO TO PICKUP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PickupPage(),
                  ));
            },
          )),
    );
  }

  Widget _phoneJobRequestDetailsView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: primaryYellow,
                child: const Icon(
                  Icons.person,
                  color: black,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                children: [
                  const Text(
                    "John Doe",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: secondaryYellow,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      "Cash",
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
              const Spacer(),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: const [
                  Text(
                    "₱1000.00",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("2.2 KM", style: TextStyle(color: grey))
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Pickup",
            style: TextStyle(color: grey),
          ),
          const Text(
            "3305 Blue Spruc Lane",
            style: TextStyle(color: black, fontSize: 10, height: 2),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Drop-off",
            style: TextStyle(color: grey),
          ),
          const Text(
            "247 Center Avenue",
            style: TextStyle(color: black, fontSize: 10, height: 2),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Note",
            style: TextStyle(color: grey),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum tortor nisi, semper sit amet odio ut, feugiat facilisis metus. Cras eu purus et lacus interdum dictum id a nulla. Morbi elementum tortor eros, sit amet semper mi mollis quis. Etiam et elit arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed volutpat accumsan massa, vel consectetur enim pretium eu.",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Delivery Fee:", style: TextStyle(color: grey)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: const [
              Text("Cash", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("₱1000.00", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: const [
              Text("Discount", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("₱0.00", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: const [
              Text("Paid Amount", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("₱1000.00", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Wrap(
                spacing: 30,
                direction: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        primary: green,
                        fixedSize: const Size(80, 90)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.call),
                        Text("Call"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: const Size(80, 90)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.message),
                        Text("Message"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        primary: grey,
                        fixedSize: const Size(80, 90)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.delete),
                        Text("Cancel"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _tabletJobRequestDetailsView() {
    return Container();
  }
}
