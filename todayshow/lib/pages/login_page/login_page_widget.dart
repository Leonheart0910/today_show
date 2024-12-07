import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_naver_login/flutter_naver_login.dart';

// GlobalKey 선언을 여기에 추가
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();



class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget>
    with TickerProviderStateMixin {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // 네이버 로그인 후 데이터를 저장할 변수
  bool isLogin = false;
  String? accessToken;
  String? refreshToken;
  String? expiresAt;
  String? tokenType;

  String? userId;
  String? userName;
  String? userEmail;
  String? userGender;
  String? userBirthday;
  String? userBirthyear;

      /// [error] 메시지를 스낵바로 보여주는 메서드
  void _showSnackError(String error) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error.toString()),
      ),
    );
  }

  // 실제 AWS 서버 주소로 변경하세요. HTTPS 사용을 권장합니다.
  final String backendUrl = 'http://3.34.189.58';



  // 네이버 로그인 메서드
void signInWithNaver() async {
  try {
    // 네이버 로그인 수행
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    // 로그인이 성공한 경우
    if (result.status == NaverLoginStatus.loggedIn) {
      // 토큰 정보 및 사용자 정보 가져오기
      final NaverAccessToken tokenResult = await FlutterNaverLogin.currentAccessToken;

      // 상태 업데이트
      setState(() {
        accessToken = tokenResult.accessToken;       // 액세스 토큰
        refreshToken = tokenResult.refreshToken;     // 리프레시 토큰
        tokenType = tokenResult.tokenType;           // 토큰 타입
        expiresAt = result.accessToken.expiresAt.toString(); // 토큰 만료 시간
        userId = result.account.id;                  // 사용자 ID
        userEmail = result.account.email;            // 사용자 이메일
        userName = result.account.name;              // 사용자 이름
        userGender = result.account.gender;          // 성별
        userBirthday = result.account.birthday;      // 생일
        userBirthyear = result.account.birthyear;    // 출생년도
        isLogin = true;                              // 로그인 상태 설정
      });

      MyApp.of(context).login();
      print('Naver AccessToken: $accessToken');
      print('Naver RefreshToken: $refreshToken');
      print('Naver ExpiresAt: $expiresAt');
      print('Naver TokenType: $tokenType');
      print('Naver User ID: $userId');
      print('Naver User Email: $userEmail');
      print('Naver User Name: $userName');
      print('Naver User Gender: $userGender');
      print('Naver User Birthday: $userBirthday');
      print('Naver User Birthyear: $userBirthyear');

        // 로그인 성공 후 백엔드로 사용자 데이터 전송
        await sendUserDataToBackend();

      // 서버에 토큰 및 사용자 정보를 전달하는 함수 호출 (예시)
      // sendTokensToServer(accessToken, refreshToken);

    } else {
      // 로그인 실패 처리
      _showSnackError('Naver Login Failed: ${result.status}');
    }
  } catch (error) {
    // 로그인 에러 처리
    _showSnackError(error.toString());
  }
}
  // 백엔드로 사용자 데이터 전송 메서드
  Future<void> sendUserDataToBackend() async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'expiresAt': expiresAt,
          'tokenType': tokenType,
          'userId': userId,
          'userEmail': userEmail,
          'userName': userName,
          'userGender': userGender,
          'userBirthday': userBirthday,
          'userBirthyear': userBirthyear,
        }),
      );

      if (response.statusCode == 200) {
        print('User data sent to AWS backend successfully');
        // TODO: 성공 처리 로직 추가 (예: 사용자에게 성공 메시지 표시)
      } else {
        print('Failed to send user data to AWS backend. Status code: ${response.statusCode}');
        // TODO: 실패 처리 로직 추가 (예: 사용자에게 오류 메시지 표시)
      }
    } catch (error) {
      print('Error sending user data to AWS backend: $error');
      // TODO: 에러 처리 로직 추가 (예: 사용자에게 네트워크 오류 메시지 표시)
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 140.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.9, 1.0),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-0.349, 0),
            end: Offset(0, 0),
          ),
        ],
      ),
    });
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
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).error,
                FlutterFlowTheme.of(context).error
              ],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.87, -1.0),
              end: AlignmentDirectional(-0.87, 1.0),
            ),
          ),
          alignment: AlignmentDirectional(0.0, -1.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 32.0),
                  child: Container(
                    width: 200.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      '오늘의 공연',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Inter Tight',
                            color: Color(0xff5963),
                            fontSize: 38.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 570.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 40.0),
                              child: Text(
                                '오늘도 교양이 넘치는 그대에게\n',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 16.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  signInWithNaver();
                                },
                                text: '네이버 로그인',
                                icon: Container(
                                  width: 24.0, // N의 크기
                                  height: 24.0,                             
                                  alignment: Alignment.center,
                                  child: Text(
                                    'N', // 네이버 로고의 "N"
                                    style: TextStyle(
                                      fontFamily: 'Arial', // 굵은 "N" 스타일을 표현할 수 있는 글꼴
                                      fontWeight: FontWeight.w900, // 더 두꺼운 글씨체
                                      fontSize: 24.0,
                                      color: Colors.white, // 흰색 "N" 텍스트
                                    ),
                                  ),
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 70.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF00C300),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 24.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Color(0xFF00C300),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  hoverColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // 카카오 로그인 로직 추가
                                },
                                text: '카카오 로그인',
                                icon: FaIcon(
                                  FontAwesomeIcons.kickstarterK,
                                  size: 24.0,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 70.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFF9E000),
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Color(0xFFF9E000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  hoverColor: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                              ),
                            ),
                            // You will have to add an action on this rich text to go to your login page.
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 64.0, 0.0, 12.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '이용약관 | 개인정보 처리방침',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: '',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animateOnPageLoad(
                      animationsMap['containerOnPageLoadAnimation']!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
