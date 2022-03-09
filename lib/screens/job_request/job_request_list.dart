import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellox_driver_app/components/custom_drawer.dart';
import 'package:yellox_driver_app/helpers/style.dart';
import 'package:yellox_driver_app/screens/job_request/job_request_details.dart';

class JobRequestListPage extends StatefulWidget {
  const JobRequestListPage({Key? key}) : super(key: key);

  @override
  State<JobRequestListPage> createState() => _JobRequestListPageState();
}

class _JobRequestListPageState extends State<JobRequestListPage> {
  bool isSwitched = true;
  String connStatus = "Online";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryYellow,
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
            return _tabletJobRequestView();
          } else {
            return _phoneJobRequestView();
          }
        },
      ),
    );
  }

  Widget _phoneJobRequestView() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Wrap(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.start,
                        children: [
                          const Text(
                            "John Doe",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "₱1000.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text("2.2 KM", style: TextStyle(color: grey))
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryYellow,
                        child: const Icon(
                          Icons.person,
                          color: black,
                        ),
                      ),
                    ),
                    const ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Pickup",
                        style: TextStyle(color: grey),
                      ),
                      subtitle: Text(
                        "3305 Blue Spruc Lane",
                        style: TextStyle(color: black, fontSize: 10, height: 2),
                      ),
                    ),
                    const ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Drop-off",
                        style: TextStyle(color: grey),
                      ),
                      subtitle: Text(
                        "247 Center Avenue",
                        style: TextStyle(color: black, fontSize: 10, height: 2),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const JobRequestDetailsPage(),
                            ));
                      },
                      child: const Text("Accept"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          fixedSize: const Size(300, 25),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              ),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white)),
            ));
  }

  Widget _tabletJobRequestView() {
    return Container();
  }
}
