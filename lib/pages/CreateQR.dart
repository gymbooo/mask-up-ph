import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_up_ph/widgets/consts.dart';

class CreateQR extends StatefulWidget {
  @override
  _CreateQRState createState() => _CreateQRState();
}

class _CreateQRState extends State<CreateQR> {
  final controller = TextEditingController();

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
          title: Text('Generate QR',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: const Color(0xFFEEEEEE),
                  data: controller.text ?? 'Hello, world!',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 5, top: 10),
                      child: TextField(
                        controller: controller,
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFEEEEEE)),
                        decoration: InputDecoration(
                            hintText: 'Enter your data',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: const Color(0xFF32A373))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: const Color(0xFFEEEEEE)))),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.only(right: 15, top: 10),
                      child: FloatingActionButton(
                          backgroundColor: const Color(0xFF32A373),
                          child: Icon(Icons.qr_code),
                          onPressed: () => setState(() {})),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
