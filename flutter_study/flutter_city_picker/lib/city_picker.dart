import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qfqz_app/utils/global.dart';

typedef void CityCallback(CityInfo cityInfo);

class CityInfo {
  CityInfo(
      this.provinceId,
      this.provinceName,
      this.cityId,
      this.cityName,
      this.districtId,
      this.districtName,
      );

  int provinceId = 1;
  int cityId = 1;
  int districtId = 1;
  String provinceName = "";
  String cityName = "";
  String districtName = "";
}

class CityPicker extends StatefulWidget {
  final CityCallback onSelect;

  const CityPicker({Key key, this.onSelect}) : super(key: key);

  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  List provinceList = [];
  List cityList = [];
  List districtList = [];
  int provinceId = 1;
  int cityId = 1;
  int districtId = 1;
  String provinceName = "";
  String cityName = "";
  String districtName = "";
  bool isGetData = false;

  FixedExtentScrollController provinceController =
  FixedExtentScrollController();
  FixedExtentScrollController cityController = FixedExtentScrollController();
  FixedExtentScrollController districtController =
  FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    getProvince().then((e) {
      getCity().then((e) {
        getDistrict().then((e) {
          isGetData = true;
          districtName = districtList[0]["name"];
          districtId = districtList[0]["id"];
          cityName = cityList[0]["name"];
          cityId = cityList[0]["id"];
          provinceName = provinceList[0]["name"];
          provinceId = provinceList[0]["id"];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetData) {
      return Container(
        color: Colors.white,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[CupertinoActivityIndicator()],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "取消",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "宋体",
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      margin:
                      const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Text(
                        "确定",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: "宋体",
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    onTap: () {
                      widget.onSelect(CityInfo(provinceId, provinceName, cityId,
                          cityName, districtId, districtName));
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                height: 200,
                padding: const EdgeInsets.only(left: 5),
                color: Colors.white,
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  //选择器背景色
                  itemExtent: 30,
                  //item的高度
                  squeeze: 1,
                  onSelectedItemChanged: (index) {
                    //选中item的位置索引
                    setState(() {
                      provinceId = provinceList[index]["id"];
                      provinceName = provinceList[index]["name"];
                      getCity().then((e) {
                        cityName = cityList[0]["name"];
                        cityId = cityList[0]["id"];
                      });
                      cityController.jumpToItem(0);
                      districtController.jumpToItem(0);
                    });
                  },
                  children: provinceWidget(),
                  scrollController: provinceController,
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  //选择器背景色
                  itemExtent: 30,
                  //item的高度
                  squeeze: 1,
                  onSelectedItemChanged: (index) {
                    //选中item的位置索引
                    setState(() {
                      cityId = cityList[index]["id"];
                      cityName = cityList[index]["name"];
                      getDistrict().then((e) {
                        districtName = districtList[0]["name"];
                        districtId = districtList[0]["id"];
                      });
                      districtController.jumpToItem(0);
                    });
                  },
                  children: cityWidget(),
                  scrollController: cityController,
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  //选择器背景色
                  itemExtent: 30,
                  //item的高度
                  squeeze: 1,
                  onSelectedItemChanged: (index) {
                    //选中item的位置索引
                    districtId = districtList[index]["id"];
                    districtName = districtList[index]["name"];
                  },
                  children: districtWidget(),
                  scrollController: districtController,
                ),
              ),
            ],
          )
        ],
      );
    }
  }

  List<Widget> provinceWidget() {
    List<Widget> result;
    if (provinceList.isNotEmpty) {
      result = [];
      for (int i = 0; i < provinceList.length; i++) {
        result.add(
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              provinceList[i]["name"],
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }
    return result;
  }

  List<Widget> cityWidget() {
    List<Widget> result = [];
    if (cityList.isNotEmpty) {
      for (int i = 0; i < cityList.length; i++) {
        result.add(
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              cityList[i]["name"],
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }
    return result;
  }

  List<Widget> districtWidget() {
    List<Widget> result = [];
    if (districtList.isNotEmpty) {
      for (int i = 0; i < districtList.length; i++) {
        result.add(
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              districtList[i]["name"],
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }
    return result;
  }

  getProvince() async {
    Response response = await Dio().get(server + "/main/baseData/loadProvince");
    if (mounted) {
      setState(() {
        provinceList = jsonDecode(response.data);
      });
    }
  }

  getCity() async {
    Response response = await Dio().get(server +
        "/main/baseData/loadCityByProvinceId?provinceId=" +
        provinceId.toString());
    if (mounted) {
      setState(() {
        cityList = jsonDecode(response.data);
        if (cityList.isEmpty) {
          cityList.add({"id": 0, "name": provinceName});
          districtList = [];
          districtList.add({"id": 0, "name": "市辖区"});
        } else {
          cityId = cityList[0]["id"];
          getDistrict().then((e) {
            districtName = districtList[0]["name"];
            districtId = districtList[0]["id"];
          });
        }
      });
    }
  }

  getDistrict() async {
    Response response = await Dio().get(
        server + "/main/baseData/loadDistrict?cityId=" + cityId.toString());
    if (mounted) {
      setState(() {
        districtList = jsonDecode(response.data);
        if (districtList.isEmpty) {
          districtList.add({"id": 0, "name": "市辖区"});
        }
      });
    }
  }
}
