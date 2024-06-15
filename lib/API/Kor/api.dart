import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'const.dart';

// ignore: non_constant_identifier_names
final String APP_KEY = Const.APP_KEY;
// ignore: non_constant_identifier_names
final String APP_SECRET = Const.APP_SECRET;
// ignore: non_constant_identifier_names
String ACCESS_TOKEN = '';
// ignore: non_constant_identifier_names
final String CANO = Const.CANO;
// ignore: non_constant_identifier_names
final String ACNT_PRDT_CD = Const.ACNT_PRDT_CD;
// ignore: non_constant_identifier_names
final String DISCORD_WEBHOOK_URL = Const.DISCORD_WEBHOOK_URL;
// ignore: non_constant_identifier_names
final String URL_BASE = Const.URL_BASE;

Future<void> algorithm() async {
  try {
    ACCESS_TOKEN = await getAccessToken();

    List<String> symbolList = ["106240", "109740", "001790", "003380", "005880", "011200", "012030", "014190", "028670", "095610", "084650", "065420", "064480", "049180", "047400", "045300", "035890", "033540", "032580", "030200"];
    List<String> boughtList = [];
    int totalCash = await getBalance();
    int buyAmount = (totalCash * 0.33).toInt();

    await sendMessage("===국내 주식 자동매매 프로그램을 시작합니다===");
    while (true) {
      DateTime now = DateTime.now();
      DateTime t9 = DateTime(now.year, now.month, now.day, 9);
      DateTime tStart = DateTime(now.year, now.month, now.day, 9, 2);
      DateTime tSell = DateTime(now.year, now.month, now.day, 15, 15);
      DateTime tExit = DateTime(now.year, now.month, now.day, 15, 20);
      int today = now.weekday;

      if (today == 6 || today == 7) {
        await sendMessage("주말이므로 프로그램을 종료합니다.");
        break;
      }

      if (t9.isBefore(now) && tStart.isAfter(now)) {
        // 잔여 수량 매도
        // stock_dict = await getStockBalance();
      }

      if (tStart.isBefore(now) && tSell.isAfter(now)) {
        for (String sym in symbolList) {
          if (boughtList.length < 3) {
            if (boughtList.contains(sym)) continue;
            int targetPrice = await getTargetPrice(sym);
            int currentPrice = await getCurrentPrice(sym);
            if (targetPrice < currentPrice) {
              int buyQty = (buyAmount ~/ currentPrice);
              if (buyQty > 0) {
                await sendMessage("$sym 목표가 달성($targetPrice < $currentPrice) 매수를 시도합니다.");
                bool result = await buy(sym, buyQty.toString());
                if (result) {
                  boughtList.add(sym);
                  // await getStockBalance();
                  break;
                }
              }
            }
          }
        }
      }

      if (tSell.isBefore(now) && tExit.isAfter(now)) {
        // 일괄 매도
        // stock_dict = await getStockBalance();
      }

      if (tExit.isBefore(now)) {
        await sendMessage("프로그램을 종료합니다.");
        break;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  } catch (e) {
    await sendMessage("[오류 발생] $e");
  }
}

Future<void> sendMessage(String msg) async {
  final now = DateTime.now();
  final message = {
    "content": "[${now.toIso8601String()}] $msg",
  };
  final response = await http.post(
    Uri.parse(DISCORD_WEBHOOK_URL),
    body: jsonEncode(message),
    headers: {'Content-Type': 'application/json'},
  );
  debugPrint(response.body);
}

Future<String> getAccessToken() async {
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    "grant_type": "client_credentials",
    "appkey": APP_KEY,
    "appsecret": APP_SECRET,
  });
  final url = Uri.parse('$URL_BASE/oauth2/tokenP');
  final response = await http.post(url, headers: headers, body: body);
  final data = jsonDecode(response.body);
  ACCESS_TOKEN = data["access_token"];
  return ACCESS_TOKEN;
}

Future<String> hashKey(Map<String, dynamic> data) async {
  final headers = {
    "Content-Type": "application/json",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
  };
  final url = Uri.parse('$URL_BASE/uapi/hashkey');
  final response = await http.post(url, headers: headers, body: jsonEncode(data));
  final result = jsonDecode(response.body);
  return result["HASH"];
}

Future<int> getCurrentPrice(String code) async {
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "FHKST01010100",
  };
  final params = {
    "fid_cond_mrkt_div_code": "J",
    "fid_input_iscd": code,
  };
  final url = Uri.parse('$URL_BASE/uapi/domestic-stock/v1/quotations/inquire-price')
      .replace(queryParameters: params);
  final response = await http.get(url, headers: headers);
  final data = jsonDecode(response.body);
  return int.parse(data['output']['stck_prpr']);
}

Future<int> getTargetPrice(String code) async {
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "FHKST01010400",
  };
  final params = {
    "fid_cond_mrkt_div_code": "J",
    "fid_input_iscd": code,
    "fid_org_adj_prc": "1",
    "fid_period_div_code": "D",
  };
  final url = Uri.parse('$URL_BASE/uapi/domestic-stock/v1/quotations/inquire-daily-price')
      .replace(queryParameters: params);
  final response = await http.get(url, headers: headers);
  final data = jsonDecode(response.body);
  final stckOprc = int.parse(data['output'][0]['stck_oprc']);
  final stckHgpr = int.parse(data['output'][1]['stck_hgpr']);
  final stckLwpr = int.parse(data['output'][1]['stck_lwpr']);
  return stckOprc + ((stckHgpr - stckLwpr) * 0.5).toInt();
}

Future<void> getStockBalance() async {
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "TTTC8434R",
    "custtype": "P",
  };
  final params = {
    "CANO": CANO,
    "ACNT_PRDT_CD": ACNT_PRDT_CD,
    "AFHR_FLPR_YN": "N",
    "OFL_YN": "",
    "INQR_DVSN": "02",
    "UNPR_DVSN": "01",
    "FUND_STTL_ICLD_YN": "N",
    "FNCG_AMT_AUTO_RDPT_YN": "N",
    "PRCS_DVSN": "01",
    "CTX_AREA_FK100": "",
    "CTX_AREA_NK100": ""
  };
  final url = Uri.parse('$URL_BASE/uapi/domestic-stock/v1/trading/inquire-balance')
      .replace(queryParameters: params);
  final response = await http.get(url, headers: headers);
  final data = jsonDecode(response.body);
  final stockList = data['output1'];
  final evaluation = data['output2'];

  await sendMessage("====주식 보유잔고====");
  for (var stock in stockList) {
    if (int.parse(stock['hldg_qty']) > 0) {
      await sendMessage("${stock['prdt_name']}(${stock['pdno']}): ${stock['hldg_qty']}주");
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  await sendMessage("주식 평가 금액: ${evaluation[0]['scts_evlu_amt']}원");
  await Future.delayed(const Duration(milliseconds: 100));
  await sendMessage("평가 손익 합계: ${evaluation[0]['evlu_pfls_smtl_amt']}원");
  await Future.delayed(const Duration(milliseconds: 100));
  await sendMessage("총 평가 금액: ${evaluation[0]['tot_evlu_amt']}원");
  await Future.delayed(const Duration(milliseconds: 100));
  await sendMessage("=================");
}

Future<int> getBalance() async {
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "TTTC8908R",
    "custtype": "P",
  };
  final params = {
    "CANO": CANO,
    "ACNT_PRDT_CD": ACNT_PRDT_CD,
    "PDNO": "005930",
    "ORD_UNPR": "65500",
    "ORD_DVSN": "01",
    "CMA_EVLU_AMT_ICLD_YN": "Y",
    "OVRS_ICLD_YN": "Y",
  };
  final url = Uri.parse('$URL_BASE/uapi/domestic-stock/v1/trading/inquire-psbl-order')
      .replace(queryParameters: params);
  final response = await http.get(url, headers: headers);
  final data = jsonDecode(response.body);
  final cash = data['output']['ord_psbl_cash'];
  await sendMessage("주문 가능 현금 잔고: $cash원");
  return int.parse(cash);
}

Future<bool> buy(String code, String qty) async {
  // ignore: constant_identifier_names
  const PATH = "uapi/domestic-stock/v1/trading/order-cash";
  // ignore: non_constant_identifier_names
  final URL = Uri.parse('$URL_BASE/$PATH');
  final data = {
    "CANO": CANO,
    "ACNT_PRDT_CD": ACNT_PRDT_CD,
    "PDNO": code,
    "ORD_DVSN": "01",
    "ORD_QTY": qty,
    "ORD_UNPR": "0",
  };
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "TTTC0802U",
    "custtype": "P",
    "hashkey": await hashKey(data),
  };
  final response = await http.post(URL, headers: headers, body: jsonEncode(data));
  final result = jsonDecode(response.body);
  if (result['rt_cd'] == '0') {
    await sendMessage("[매수 성공] $result");
    return true;
  } else {
    await sendMessage("[매수 실패] $result");
    return false;
  }
}

Future<bool> sell(String code, String qty) async {
  // ignore: constant_identifier_names
  const PATH = "uapi/domestic-stock/v1/trading/order-cash";
  // ignore: non_constant_identifier_names
  final URL = Uri.parse('$URL_BASE/$PATH');
  final data = {
    "CANO": CANO,
    "ACNT_PRDT_CD": ACNT_PRDT_CD,
    "PDNO": code,
    "ORD_DVSN": "01",
    "ORD_QTY": qty,
    "ORD_UNPR": "0",
  };
  final headers = {
    "Content-Type": "application/json",
    "authorization": "Bearer $ACCESS_TOKEN",
    "appKey": APP_KEY,
    "appSecret": APP_SECRET,
    "tr_id": "TTTC0801U",
    "custtype": "P",
    "hashkey": await hashKey(data),
  };
  final response = await http.post(URL, headers: headers, body: jsonEncode(data));
  final result = jsonDecode(response.body);
  if (result['rt_cd'] == '0') {
    await sendMessage("[매도 성공] $result");
    return true;
  } else {
    await sendMessage("[매도 실패] $result");
    return false;
  }
}
