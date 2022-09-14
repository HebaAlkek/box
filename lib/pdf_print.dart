import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_details.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PdfInvoiceApi {
  static Future<File> generate(String lang, OrderModel orderModel, String role,
      List<List<OrderDetailsModel>> product, String order,String fee,String dis,String tax,String total) async {
    final pdf = Document();

    var arabicFont =
        Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));

    pdf.addPage(MultiPage(
      build: (context) => [
        lang == 'ar'
            ? pw.Directionality(
                textDirection: TextDirection.ltr,
                child: pw.Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      pw.Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            pw.Text('عرض سعر',
                                textDirection: TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                    fontSize: 30,
                                    font: arabicFont)),
                            orderModel.orderStatus == 'pending'
                                ? pw.Text('حالة الدفع : معلقة ',
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                        fontSize: 25,
                                        font: arabicFont))
                                : pw.Text(
                                    orderModel.orderStatus + 'حالة الدفع : ',
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                        fontSize: 25,
                                        font: arabicFont)),
                            pw.Row(children: [
                              pw.Text('#' + orderModel.id.toString(),
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 22,
                                      font: arabicFont)),
                              pw.Text('فاتورة : ',
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                      fontSize: 25,
                                      font: arabicFont)),
                            ]),
                            pw.Row(children: [
                              pw.Text(orderModel.paymentMethod,
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                      fontSize: 25,
                                      font: arabicFont)),
                              pw.Text('طريقة الدفع : ',
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                      fontSize: 25,
                                      font: arabicFont))
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                  DateConverter.localDateToIsoStringAMPM(
                                      DateTime.parse(orderModel.createdAt)),
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 22,
                                      font: arabicFont)),
                              pw.Text('تاريخ الطلب : ',
                                  textDirection: TextDirection.rtl,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                      fontSize: 25,
                                      font: arabicFont)),
                            ]),
                            role != 'seller account'
                                ? pw.Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            ' ${orderModel != null && orderModel.shippingAddressData != null ? orderModel.shippingAddressData.address : ''}',
                                            maxLines: 3,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontSize: 22,
                                                font: arabicFont)),
                                        Text('يشحن إلى : ',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColors.black,
                                                fontSize: 25,
                                                font: arabicFont)),
                                      ])
                                : pw.Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text(orderModel.customerName,
                                            textDirection: TextDirection.rtl,
                                            maxLines: 3,
                                            style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontSize: 22,
                                                font: arabicFont)),
                                        Text('اسم العميل : ',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColors.black,
                                                fontSize: 25,
                                                font: arabicFont)),
                                      ]),
                            pw.SizedBox(height: 5),
                            pw.Container(
                                height: 1, color: PdfColors.grey, width: 400),
                            pw.SizedBox(height: 5),
                            Text('تفاصيل الطلب : ',
                                textDirection: TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                    fontSize: 25,
                                    font: arabicFont)),
                            pw.SizedBox(height: 5),
                            pw.Row(children: [
                              pw.Column(children: [
                                pw.Text("الكمية",
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        font: arabicFont,
                                        color: PdfColors.black)),
                                pw.ListView.builder(
                                    itemBuilder: (con, i) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                product[0][i].qty.toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 16)),
                                            pw.SizedBox(height: 0)
                                          ]);
                                    },
                                    itemCount: product[0].length),
                              ]),
                              pw.SizedBox(width: 10),
                              pw.Column(children: [
                                pw.Text("السعر",
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        font: arabicFont,
                                        color: PdfColors.black)),
                                pw.ListView.builder(
                                    itemBuilder: (con, i) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                product[0][i].price.toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 16)),
                                            pw.SizedBox(height: 0)
                                          ]);
                                    },
                                    itemCount: product[0].length),
                              ]),
                              pw.SizedBox(width: 10),
                              pw.Column(children: [
                                pw.Text("الخصم",
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        font: arabicFont,
                                        color: PdfColors.black)),
                                pw.ListView.builder(
                                    itemBuilder: (con, i) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                product[0][i]
                                                    .discount
                                                    .toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 16)),
                                            pw.SizedBox(height: 0)
                                          ]);
                                    },
                                    itemCount: product[0].length),
                              ]),
                              pw.SizedBox(width: 10),
                              pw.Column(children: [
                                pw.Text("الضريبة",
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        font: arabicFont,
                                        color: PdfColors.black)),
                                pw.ListView.builder(
                                    itemBuilder: (con, i) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                product[0][i].tax.toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 16)),
                                            pw.SizedBox(height: 0)
                                          ]);
                                    },
                                    itemCount: product[0].length),
                              ]),
                              pw.SizedBox(width: 10),
                              pw.Column(children: [
                                pw.Text("اسم المنتج",
                                    textDirection: TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        font: arabicFont,
                                        color: PdfColors.black)),
                                pw.ListView.builder(
                                    itemBuilder: (con, i) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                product[0][i]
                                                    .productDetails
                                                    .name,
                                                textDirection:
                                                    TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 16)),
                                            pw.SizedBox(height: 0)
                                          ]);
                                    },
                                    itemCount: product[0].length),
                              ]),
                            ]),
                            pw.SizedBox(height: 5),
                            pw.Container(
                                height: 1, color: PdfColors.grey, width: 400),
                            pw.SizedBox(height: 5),
                            pw.Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  pw.Text('المجموع',
                                      textDirection: TextDirection.rtl,
                                      style: pw.TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          font: arabicFont,
                                          color: PdfColors.black)),
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(order,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                        pw.SizedBox(width: 100),
                                        pw.Text('سعر الطلبات',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                      ])
                                  ,
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(fee,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                        pw.SizedBox(width: 100),
                                        pw.Text('رسوم الشحن',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                      ])
                                  ,
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(dis,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                        pw.SizedBox(width: 150),
                                        pw.Text('خصم',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                      ])
                                  ,
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(tax,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                        pw.SizedBox(width: 150),
                                        pw.Text('الضريبة',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                      ])
                                  ,
                                  pw.SizedBox(height: 5),
                                  pw.Container(
                                      height: 1, color: PdfColors.grey, width: 400),
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(total,
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                        pw.SizedBox(width: 100),
                                        pw.Text('المجموع العام',
                                            textDirection: TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                font: arabicFont,
                                                color: PdfColors.black)),
                                      ])
                                  ,
                                ]),
                          ])
                    ]))
            : pw.Directionality(
                textDirection: pw.TextDirection.ltr,
                child: pw.Row(children: [
                  pw.Directionality(
                      textDirection: pw.TextDirection.ltr,
                      child: pw.Text('Quotatiom',
                          textDirection: TextDirection.ltr,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                              fontSize: 25,
                              font: arabicFont)))
                ])),
        //  buildHeader( img, arabicFont),
        SizedBox(height: 18),
        Divider(),
        SizedBox(height: 18),
      ],
      //footer: (context) => buildFooter(invoice),
    ));
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(final img, var ara) => pw.Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Image(img, width: 200, height: 50, fit: BoxFit.fill),
          SizedBox(height: 0),
          SizedBox(height: 30),
        ],
      ));
}

class PdfApi {
  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
}
