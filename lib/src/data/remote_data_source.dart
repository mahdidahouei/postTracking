import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:post_tracking/src/data/models/required_data.dart';
import 'package:post_tracking/src/data/models/tracking_data_result.dart';

import 'helpers/extract_tracking_data_from_html_helper.dart';

class RemoteDataSource {
  final Dio client = Dio(BaseOptions(baseUrl: "https://tracking.post.ir"));
  final cookieJar = CookieJar();

  RemoteDataSource() {
    client.interceptors.add(CookieManager(cookieJar));
  }

  Future<RequiredData> fetchWebsiteData() async {
    final response = await client.get("/");
    final List<Cookie> cookies =
        await cookieJar.loadForRequest(Uri.parse("https://tracking.post.ir/"));

    final document = parse(response.data);

    final sessionIdCookie =
        cookies.firstWhere((element) => element.name == "ASP.NET_SessionId");
    final bigIPServerPoolFarm126Cookie = cookies
        .firstWhere((element) => element.name == "BIGipServerPool_Farm_126");

    final sessionId = sessionIdCookie.value;
    final bigIPServerPoolFarm126 = bigIPServerPoolFarm126Cookie.value;

    late String viewState;
    late String viewStateGenerator;
    late String eventValidation;

    final viewStateElement =
        document.querySelector("input[name='__VIEWSTATE']");
    if (viewStateElement != null) {
      viewState = viewStateElement.attributes['value'] ?? '';
    }

    // Find and extract the value of __ViewStateGenerator.
    final viewStateGeneratorElement =
        document.querySelector("input[name='__VIEWSTATEGENERATOR']");
    if (viewStateGeneratorElement != null) {
      viewStateGenerator = viewStateGeneratorElement.attributes['value'] ?? '';
    }

    // Find and extract the value of __EventValidation.
    final eventValidationElement =
        document.querySelector("input[name='__EVENTVALIDATION']");
    if (eventValidationElement != null) {
      eventValidation = eventValidationElement.attributes['value'] ?? '';
    }

    return RequiredData(
      sessionId: sessionId,
      bigIPServerPoolFarm126: bigIPServerPoolFarm126,
      viewState: viewState,
      viewStateGenerator: viewStateGenerator,
      eventValidation: eventValidation,
    );
  }

  Future<TrackingDataResult> track({
    required String trackingNumber,
    required String sessionId,
    required String bigIPServerPoolFarm126,
    required String viewState,
    required String viewStateGenerator,
    required String eventValidation,
  }) async {
    final data = {
      "scripmanager1": "pnlMain|btnSearch",
      "__LASTFOCUS": "",
      "txtVoteReason": "",
      "txtVoteTel": "",
      "__EVENTTARGET": "btnSearch",
      "__EVENTARGUMENT": "",
      "__VIEWSTATE": viewState,
      "__VIEWSTATEGENERATOR": viewStateGenerator,
      "__EVENTVALIDATION": eventValidation,
      "txtbSearch": trackingNumber,
      "__VIEWSTATEENCRYPTED": "",
      "__ASYNCPOST": "true",
    };

    final formData = FormData.fromMap(data);

    final headers = {
      HttpHeaders.hostHeader: "tracking.post.ir",
      HttpHeaders.acceptEncodingHeader: "gzip, deflate, br",
      HttpHeaders.refererHeader: "https://tracking.post.ir/",
      HttpHeaders.userAgentHeader:
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
      "Origin": "https://tracking.post.ir",
      HttpHeaders.connectionHeader: "keep-alive",
      HttpHeaders.acceptHeader: "*/*",
      HttpHeaders.cookieHeader:
          "ASP.NET_SessionId=$sessionId; BIGipServerPool_Farm_126=$bigIPServerPoolFarm126",
      HttpHeaders.contentTypeHeader:
          "application/x-www-form-urlencoded; charset=utf-8",
    };

    // final response = await _getTestData(
    //   RequestOptions(
    //     path: "https://tracking.post.ir/",
    //     headers: headers,
    //   ),
    // );
    final response = await client.post(
      "/",
      data: formData,
      options: Options(
        headers: headers,
      ),
    );

    return extractTrackingData(response.data, trackingNumber);
  }

  Future<Response> _getTestData(RequestOptions options) async {
    final html = await rootBundle.loadString('test_html/post_tracking.html');
    return Response(
      requestOptions: options,
      data: html,
      statusCode: 200,
    );
  }

  /*
{
   "status": "success",
   "country": "Iran",
   "countryCode": "IR",
   "region": "23",
   "regionName": "Tehran",
   "city": "Tehran",
   "zip": "",
   "lat": 35.7599,
   "lon": 51.4739,
   "timezone": "Asia/Tehran",
   "isp": "IRANCELL",
   "org": "",
   "as": "AS44244 Iran Cell Service and Communication Company",
   "query": "5.124.238.182"
}
   */

  Future<bool> isIranianIP() async {
    const path = "http://ip-api.com/json";
    final response = await client.get(path);

    return response.data["countryCode"] == "IR";
  }
}
