import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yellox_driver_app/api/network_helper.dart';
import 'package:yellox_driver_app/components/custom_drawer.dart';
import 'package:yellox_driver_app/components/map_pin_pill.dart';
import 'package:yellox_driver_app/helpers/style.dart';
import 'package:yellox_driver_app/models/line_string.dart';
import 'package:yellox_driver_app/models/pin_pill_info.dart';
import 'package:yellox_driver_app/providers/db_providers.dart';
import 'package:yellox_driver_app/screens/job_request/job_request_list.dart';

import '../providers/user_profile_provider.dart';
import '../providers/user_provider.dart';
import '../services/shared_preference.dart';
import 'job_request/job_request_details.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(14.5995, 120.9842);
const LatLng DEST_LOCATION = LatLng(13.9070, 120.9675);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;
  String connStatus = "Offline";

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
// for my drawn routes on the map
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;

// for my custom marker pins
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData? currentLocation;
// a reference to the destination location
  LocationData? destinationLocation;
// wrapper around the location API
  Location location = Location();
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: const LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation? sourcePinInfo;
  PinInformation? destinationPinInfo;
  LatLng? currentPosition;
  final PanelController _pc = PanelController();
  var data;
  // Fab
  final double _initFabHeight = 150.0;
  double _fabHeight = 0;

  double _panelHeightOpen = 400;
  double _panelHeightClosed = 80;
  var isLoading = false;

  @override
  void initState() {
    super.initState();

    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
    _fabHeight = _initFabHeight;
    polylinePoints = PolylinePoints();
    Future.delayed(Duration(seconds: 1), () {
      _showOfflinePanel();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      setState(() {
        currentLocation = cLoc;
        currentPosition =
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        showPinsOnMap();
      });
      updatePinOnMap();
      setPolylines();
    });

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  void showPinsOnMap() {
    if (currentLocation != null && destinationLocation != null) {
      // get a LatLng for the source location
      // from the LocationData currentLocation object
      var pinPosition =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      // get a LatLng out of the LocationData object
      var destPosition = LatLng(
          destinationLocation!.latitude!, destinationLocation!.longitude!);

      sourcePinInfo = PinInformation(
          locationName: "Start Location",
          location: currentPosition!,
          pinPath: "assets/driving_pin.png",
          avatarPath: "assets/friend1.jpg",
          labelColor: Colors.blueAccent);

      destinationPinInfo = PinInformation(
          locationName: "End Location",
          location: DEST_LOCATION,
          pinPath: "assets/destination_map_marker.png",
          avatarPath: "assets/friend2.jpg",
          labelColor: Colors.purple);

      // add the initial source location pin
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition,
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo!;
              pinPillPosition = 0;
            });
          },
          icon: sourceIcon!));
      // destination pin
      _markers.add(Marker(
          markerId: const MarkerId('destPin'),
          position: destPosition,
          onTap: () {
            setState(() {
              currentlySelectedPin = destinationPinInfo!;
              pinPillPosition = 0;
            });
          },
          icon: destinationIcon!));
      // set the route lines on the map from source to destination
      // for more info follow this tutorial
    }
  }

  //Openrouteservice API with only 2000 quota a day
  void setPolylines() async {
    // Using OpenRouteService
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format
    NetworkHelper network = NetworkHelper(
      startLat: currentLocation!.latitude!,
      startLng: currentLocation!.longitude!,
      endLat: destinationLocation!.latitude!,
      endLng: destinationLocation!.longitude!,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      if (data.isNotEmpty) {
        LineString ls =
            LineString(data['features'][0]['geometry']['coordinates']);
        polylineCoordinates.clear();
        for (int i = 0; i < ls.lineString.length; i++) {
          polylineCoordinates
              .add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
        }
        // When Using Direction API
        // List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        //     googleAPIKey,
        //     currentLocation.latitude,
        //     currentLocation.longitude,
        //     destinationLocation.latitude,
        //     destinationLocation.longitude);
        //
        // if (result.isNotEmpty) {
        //   result.forEach((PointLatLng point) {
        //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        //   });

        setState(() {
          _polylines.add(Polyline(
              width: 7, // set the width of the polylines
              polylineId: const PolylineId("poly"),
              color: const Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates));
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

      sourcePinInfo!.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo!;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon!));
    });
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  void _showOfflinePanel() async {
    var fb = Flushbar(
      backgroundColor: primaryYellow,
      icon: const Icon(
        Icons.dark_mode,
        // color: primaryYellow,
      ),
      titleColor: black,
      title: "You are Offline!",
      messageColor: grey,
      message: "Go online to start accepting jobs.",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.fromLTRB(0, kToolbarHeight, 0, 0),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      // onTap: (flushbar) => flushbar.dismiss(),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    );
    if (isSwitched) {
      _pc.hide();
      fb.dismiss();
    } else {
      fb..show(context);
      _pc.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Scaffold(
      backgroundColor: grey,
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
                      _showOfflinePanel();
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
      body: SlidingUpPanel(
          controller: _pc,
          minHeight: _panelHeightClosed,
          // maxHeight: _panelHeightOpen,
          panelBuilder: (ScrollController sc) {
            return _offlinePanel(sc);
          },
          borderRadius: radius,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600.0) {
                return _tabletHomepageView();
              } else {
                return _phoneHomepageView();
              }
            },
          ),
          onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              })),
      // bottomNavigationBar: Visibility(
      //   visible: isSwitched,
      //   child: _onlinePanel(),
      // ),
    );
  }

  Widget _phoneHomepageView() {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: currentLocation != null
            ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
            : SOURCE_LOCATION);
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        _googleMap(initialCameraPosition),
        _mapPinPill(),
        Positioned(
          right: 20,
          bottom: _fabHeight,
          child: FloatingActionButton(
              backgroundColor: white,
              onPressed: () {
                _currentLocation();
              },
              child: const Icon(
                Icons.gps_fixed,
                color: black,
                size: 32,
              )),
        ),
        Visibility(visible: isSwitched, child: _onlinePanel())
      ],
    );
  }

  Widget _tabletHomepageView() {
    return Container();
  }

  Widget _googleMap(initialCameraPosition) {
    return GoogleMap(
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        onTap: (LatLng loc) {
          pinPillPosition = -100;
        },
        onMapCreated: (GoogleMapController controller) {
          //grey and white google map
          controller.setMapStyle(Utils.mapStyles);
          _controller.complete(controller);
          // my map has completed being created;
          // i'm ready to show the pins on the map
        });
  }

  Widget _mapPinPill() {
    return MapPinPillComponent(
        pinPillPosition: pinPillPosition,
        currentlySelectedPin: currentlySelectedPin);
  }

  Widget _offlinePanel(ScrollController sc) {
    return FutureBuilder(
        future: DBProvider.db.getAllUserProfile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            print(snapshot.data.length);
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) => ListView(
                      controller: sc,
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
                      children: [
                        ListTile(
                            leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: primaryYellow,
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                )),
                            title: Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  "Name: ${snapshot.data[index].name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text("Basic Level",
                                    style: TextStyle(color: grey))
                              ],
                            ),
                            trailing: Wrap(
                              alignment: WrapAlignment.end,
                              direction: Axis.vertical,
                              children: const [
                                Text(
                                  "₱1000.00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text("Earned", style: TextStyle(color: grey))
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.fromLTRB(18, 32, 18, 0),
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                              color: secondaryYellow,
                              borderRadius: BorderRadius.circular(14)),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.access_time_outlined,
                                    size: 32,
                                    color: grey,
                                  ),
                                  Text(
                                    "10.5",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Hours online",
                                    style: TextStyle(fontSize: 12, color: grey),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.speed_outlined,
                                    size: 32,
                                    color: grey,
                                  ),
                                  Text(
                                    "30KM",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Total Distance",
                                    style: TextStyle(fontSize: 12, color: grey),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.view_list_outlined,
                                    size: 32,
                                    color: grey,
                                  ),
                                  Text(
                                    "20",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Total Jobs",
                                    style: TextStyle(fontSize: 12, color: grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ));
          }
        });
  }

  Widget _onlinePanel() {
    return Container(
      height: 320,
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 8,
            margin: const EdgeInsets.only(left: 35, right: 35),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(
                          flex: 3,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text(
                            "Ignore",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: grey),
                          ),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.blue,
                              fixedSize: const Size(100, 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(
                          width: 10,
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
                              fixedSize: const Size(100, 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white)),
          ),
          Align(
            child: TextButton(
              child: const Text("See all request"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobRequestListPage(),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
