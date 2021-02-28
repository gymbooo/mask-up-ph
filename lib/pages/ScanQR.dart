import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

String qrData = '';
var data;
bool hasData = false;

class _ScanQRState extends State<ScanQR> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.mainAppBarColor,
          title: Text('Scan QR',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Text('$qrData',
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                              color: const Color(0xFFEEEEEE)))),
                  IconButton(
                      icon: Icon(
                        Icons.launch_outlined,
                        color: const Color(0xFFEEEEEE),
                      ),
                      onPressed: hasData
                          ? () async {
                              if (await canLaunch(qrData)) {
                                await launch(qrData);
                              } else {
                                throw 'Not a valid URL';
                              }
                            }
                          : null)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      var option = ScanOptions(autoEnableFlash: false);
                      data = await BarcodeScanner.scan(options: option);
                      setState(() {
                        qrData = data.rawContent.toString();
                        hasData = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * .75, 45),
                        primary: Colors.white,
                        onPrimary: Colors.green,
                        onSurface: Colors.purple,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: Text('Tap here to start scanning',
                        style: GoogleFonts.montserrat(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
