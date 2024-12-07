import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'list_page_model.dart';
export 'list_page_model.dart';
// 통신을 위한 http 패키지
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 파싱을 위한 import

class ListPageWidget extends StatefulWidget {
  /// 2번째 리스트 페이지
  const ListPageWidget({super.key});

  @override
  State<ListPageWidget> createState() => _ListPageWidgetState();
}

class Performance {
  final String prfnm;
  final String genrenm;
  final String prfruntime;
  final String fcltynm;
  final String poster; // 포스터 URL 추가

  Performance({
    required this.prfnm,
    required this.genrenm,
    required this.prfruntime,
    required this.fcltynm,
    required this.poster, // 포스터 필드 추가
  });

  // JSON 데이터를 Dart 오브젝트로 변환하는 factory
  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      prfnm: json['prfnm'],
      genrenm: json['genrenm'],
      prfruntime: json['prfruntime'],
      fcltynm: json['fcltynm'],
      poster: json['poster'], // 포스터 URL 매핑
    );
  }
}
class _ListPageWidgetState extends State<ListPageWidget>
    with TickerProviderStateMixin {
  late ListPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Performance>> futurePerformances; // 비동기 데이터

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListPageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // TabBarController 초기화
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    // 공연 데이터를 가져오는 Future 초기화
    futurePerformances = fetchPerformances();
  }

  // API에서 공연 데이터를 받아오는 함수 추가
  Future<List<Performance>> fetchPerformances() async {
    try {
      final response = await http.get(Uri.parse('http://3.34.189.58/performances'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((data) => Performance.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load performances');
      }
    } catch (e) {
      throw Exception('Failed to load performances: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFAFC4),
          automaticallyImplyLeading: true,
          actions: [
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 50.0,
              fillColor: Color(0xFFFFAFC4),
              icon: Icon(
                Icons.shopping_cart,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 50.0,
              fillColor: Color(0xFFFFAFC4),
              icon: Icon(
                Icons.mail,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 1.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                            child: Container(
                              width: 200.0,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: '검색',
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: FlutterFlowTheme.of(context).primary,
                                validator: _model.textControllerValidator.asValidator(context),
                              ),
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).alternate,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          icon: Icon(
                            Icons.tune_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // TabBar 추가
                    Align(
                      alignment: Alignment(0.0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                        labelStyle: FlutterFlowTheme.of(context).labelSmall.override(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                            ),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        tabs: [
                          Tab(
                            text: '공연',
                            icon: FaIcon(
                              FontAwesomeIcons.theaterMasks,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Tab(
                            text: '맛집',
                            icon: Icon(
                              Icons.store,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Tab(
                            text: '카페',
                            icon: Icon(
                              Icons.local_cafe,
                            ),
                          ),
                        ],
                        controller: _model.tabBarController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          // 공연 데이터 출력하는 탭
                          FutureBuilder<List<Performance>>(
                            future: futurePerformances,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Failed to load data'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('No performances found'));
                              } else {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final performance = snapshot.data![index];
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(50.0, 12.0, 50.0, 12.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: Image.network(
                                                  performance.poster, // API에서 받은 이미지 URL을 사용
                                                  width: double.infinity,
                                                  height: 400.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Text('이미지를 불러올 수 없습니다.'); // 오류 발생 시 처리
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 4.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      performance.prfnm, // 공연명
                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                            fontFamily: 'Inter',
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0), // 장르 왼쪽에 15px 여백 추가
                                                    child: Text(
                                                      performance.genrenm, // 장르
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      performance.fcltynm, // 공연장명
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            fontSize: 14.0,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    performance.prfruntime, // 런타임
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                        ),
                                                  ),
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          // 다른 탭 내용
                          Center(child: Text("맛집 탭 내용")),
                          Center(child: Text("카페 탭 내용")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
