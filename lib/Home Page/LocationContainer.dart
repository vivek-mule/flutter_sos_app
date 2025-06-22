import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationContainer extends StatefulWidget {
  const LocationContainer({super.key});

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {

  Widget? _locationWidget; // This is the location widget which would hold the location information


  // Function to set the current location to location widget
  Future<void> _refreshLocation() async {
    Widget newLocationWidget = await _getCurrentLocation();
    setState(() {
      _locationWidget = newLocationWidget;
    });
  }


  // This function gives current location
  Future<Widget> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;


      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks.first;

      String address =
          '${placemark.name ?? ''} ${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''} , ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';

      if (latitude.isNaN || longitude.isNaN) {
        return Text(
          "No Data Available, check your location settings.",
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
          ),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Latitude : $latitude",
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Text(
              "Longitude : $longitude",
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
              child: Text(
                textAlign: TextAlign.center,
                address,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      }
    } catch (e) {
      return Text(
        "Some Exception Occurred. Please try again.",
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.white,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Approximate Location",
                  style: GoogleFonts.lato(
                    fontSize: 18, // standard heading size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _refreshLocation,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_locationWidget != null) _locationWidget!,
        ],
      ),
    );
  }
}
