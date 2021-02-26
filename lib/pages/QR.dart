import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_up_ph/pages/CreateQR.dart';
import 'package:mask_up_ph/pages/ScanQR.dart';
import 'package:mask_up_ph/widgets/consts.dart';

class QR extends StatefulWidget {
  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainAppBarColor,
          title: Text('Mask Up PH',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/qr.png',
                height: 280,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ScanQR()));
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
                    child: Text('Scan QR Code',
                        style: GoogleFonts.montserrat(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CreateQR()));
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
                    child: Text('Generate QR Code',
                        style: GoogleFonts.montserrat(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ))),
              ),
            ],
          )),
        )),
      ),
    );
  }
}
