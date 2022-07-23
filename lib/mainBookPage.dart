import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List? data = [];
  TextEditingController searchController = TextEditingController();
  int page = 1;
   ScrollController _scrollController = ScrollController();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange){
        print("bottom");
        page ++;
        getJsonData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:TextField(
        controller: searchController,
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "책 제목을 검색해주세요."
        ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page = 1;
          data?.clear();
          getJsonData();
          // if(data!.length <=10 ){
          // getJsonData();
          // }else{
          // data = [];
          // }

        },
        child: Icon(Icons.file_download),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
              child: data?.length == 0
                  ? Center(
                      child: Text("데이터가 없습니다"),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            child: Row(
                              children: [
                                Image.network(data?[index]["thumbnail"],height: 100,width: 100,fit: BoxFit.contain,)
                              ,Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 150,
                                  ),
                                  Text("제목 : ${data?[index]["title"].toString() ?? "hello"}",overflow: TextOverflow.fade,softWrap: false,maxLines: 2,),
                                  Text("저자 : ${data?[index]["authors"].toString() ?? "hello"}"),
                                  Text("가격 : ${data?[index]["sale_price"].toString() ?? "hello"}"),
                                  Text("판매중 : ${data?[index]["status"].toString() ?? "hello"}"),
                                ],
                              ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                        );
                      }))
        ],
      )),
    );
  }

  Future<String> getJsonData() async {
    //  List? datas;
    var url = "https://dapi.kakao.com/v3/search/book?target=title&query=${searchController.text}&page$page=${searchController.text}";
    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK e7923a1319b49d514bb65c81b88bdea6"});
    if (response.statusCode == 200) {
      setState(() {
        var dartConvertedToJson = json.decode(response.body);
        List result = dartConvertedToJson["documents"];
        print(result);
        data?.addAll(result);
      });
      return response.body;
    } else {
      return "";
    }
  }

}
