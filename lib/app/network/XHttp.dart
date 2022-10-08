import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expenso/app/data/app_constants.dart';
import 'package:expenso/app/data/local_storage.dart';
import 'package:expenso/app/network/endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as pp;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Global network request dio instance singleton XHttp
class XHttp {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String PATCH = "PATCH";
  static const String DELETE = "DELETE";

  static const CUSTOM_ERROR_CODE = 'DIO_CUSTOM_ERROR'; // custom error code
  static const REQUEST_TYPE_STR = 'REQUEST'; // request type string
  static const RESPONSE_TYPE_STR = 'RESPONSE'; // response type string
  static const ERROR_TYPE_STR = 'RESPONSE_ERROR'; // error type string
  static const DEFAULT_LOAD_MSG = 'Please wait...'; // Default request prompt text

  static const CONNECT_TIMEOUT = 60000; // connection timeout
  static const RECEIVE_TIMEOUT = 60000; // receive timeout
  static const SEND_TIMEOUT = 60000; // send timeout

  static const DIALOG_TYPE_OTHERS = 'OTHERS'; // result processing - other types
  static const DIALOG_TYPE_TOAST = 'TOAST'; // Result processing - light prompt type
  static const DIALOG_TYPE_ALERT = 'ALERT'; // Result processing - pop-up window type
  static const DIALOG_TYPE_CUSTOM = 'CUSTOM'; // Result processing - custom processing

  static String loadMsg = DEFAULT_LOAD_MSG; // request prompt text

  static String errorShowTitle = 'Something went wrong'; // error message title

  static String? errorShowMsg; // error message text

  static CancelToken cancelToken =
      CancelToken(); // Cancel the network request token, all requests can be cancelled by default.

  static CancelToken whiteListCancelToken =
      CancelToken(); // Cancel the network request whitelist token, this token will not be cancelled.

  static var nullDioError;

  static Dio? dio;
  // var box = Hive.box(Constants.configName);
  String _getBaseUrl() {
    return Endpoints.BASE_URL;
    // return box.get(Constants.baseUrl, defaultValue: Endpoints.baseUrl) + "api/";
  }

  /// Generic global singleton, initialized on first use.
  XHttp._internal() {
    if (null == dio) {
      dio = Dio(BaseOptions(
        baseUrl: _getBaseUrl(),
        // contentType: ,
        // responseType: ,
        responseType: ResponseType.plain,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        sendTimeout: SEND_TIMEOUT,
      ));
      _init();
    }
  }

  /// Get the singleton itself
  static final XHttp _instance = XHttp._internal();

  /// Initialize dio
  void _init() {
    // add interceptor
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          if (kDebugMode) {
            print("before request");
          }
          _handleRequest(options, handler);
          // When there is a token, add the token. Put it after the print log to avoid leaking the token.
          // You can also use the XHttp.setToken() method to set the token after the login is successful, but it is best to do so for persistence.
          if (LocalStorage.box.get(AppConstants.isUserLoggedIn, defaultValue: false)) {
            String? token = LocalStorage.box.get(AppConstants.authenticationToken, defaultValue: null);
            //   // if (token != dio?.options.headers['authorization']) {
            //   // dio?.options.headers['authorization'] = token;
            //   // options.headers['authorization'] = token; // If it is not set, the first request will have problems. The above is that the global setting has not yet taken effect for this request.
            //   // }
            //   // options.headers["Content-Type"] = "application/json";
            //   // dio?.options.headers['Content-Type'] = "application/json";
            if (token != null) {
              options.headers["Authorization"] = 'Bearer $token';

              // options.headers["DeviceId"] = Storage.box.get(Constants.deviceId, defaultValue: '');
              // dio?.options.headers['Authorization'] = token;

              // dio?.options.headers['DeviceId'] = Storage.box.get(Constants.deviceId, defaultValue: '');
            }

            //   Logger().e(
            //       "DeviceId => ${Storage.box.get(Constants.deviceId, defaultValue: '')}");
            Logger().e("token => $token");
          }
          // options.headers["API-KEY"] = pp.GetPlatform.isAndroid ? '12345' : '12345';
          // dio?.options.headers['API-KEY'] = pp.GetPlatform.isAndroid ? '12345' : '12345';

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          if (kDebugMode) {
            print("before responding");
          }
          // _handleResponse(response, handler);
          RequestOptions option = response.requestOptions;
          int? code = response.statusCode;
          var decodedResponse = jsonDecode(response.data);
          // code = jsonDecode(response.data)["statusCode"];
          // print('nowfal $code');
          // String code = (response.data ?? {})['statusCode'];
          String msg = decodedResponse["message"];
          // String msg = (response.data ?? {})['msg'] ?? response.statusMessage;
          // Static data or based on the actual return structure analysis in the background, that is, when code == '0', data is valid data.
          bool isSuccess = decodedResponse["status"] ?? decodedResponse["reply"];
          bool isReAuth = decodedResponse["reauth"] ?? false;
          if (isReAuth) {
            LocalStorage.box.put(AppConstants.authenticationToken, decodedResponse["token"] ?? '');
          }
          // bool isSuccess = (code ?? response.statusCode) == 200;
          // bool isSuccess = option.contentType != null && option.contentType!.contains("text");
          _handleResponse(response, handler, isSuccess, msg);
          response.data =
              Result(response.data, isSuccess, code ?? response.statusCode!, msg, headers: response.headers);
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          if (kDebugMode) {
            print("before error");
          }

          // nullDioError = error;

          _handleError(error);
          // When an error occurs, a Result structure is also returned, through which the response status and other information can be obtained.
          if (error.response != null && error.response?.data != null) {
            error.response!.data = Result(error.response!.data, false, error.response!.statusCode!,
                errorShowMsg ?? error.response!.statusMessage!,
                headers: error.response?.headers);
          } else {
            throw Exception(errorShowMsg);
          }
          return handler.next(error);
        },
      ),
    );
    dio?.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    // print("Initializing Dio completed\nRequest timeout limit: $CONNECT_TIMEOUT ms\nReceive timeout limit: $RECEIVE_TIMEOUT ms\nSend timeout limit: $SEND_TIMEOUT ms\nDio-BaseUrl: ${dio.options.baseUrl}\nDio -Headers: ${dio.options.headers}");
  }

  /// Unified processing before request request
  void _handleRequest(RequestOptions options, handler) {
    Toast.hide();
    Toast.loading(loadMsg);
    Map logData = {
      'url': options.baseUrl + options.path,
      'method': options.method,
      'headers': options.headers,
      'data': options.data ??
          options
              .queryParameters, // GET request parameters can be in url or queryParameters, so this judgment needs to be added.
    };
    _dealRequestInfo(logData, REQUEST_TYPE_STR);
  }

  /// Unified processing before responding to response
  void _handleResponse(Response response, handler, bool isSuccess, String msg) {
    Map logData = {
      'url': response.requestOptions.uri,
      'method': response.requestOptions.method,
      'headers': response.headers,
      'data': response.data,
      'statusCode': response.statusCode,
      'statusMessage': response.statusMessage,
    };
    _dealRequestInfo(logData, RESPONSE_TYPE_STR);
    if (!isSuccess) {
      Toast.hide();
    } else {
      Toast.hide();
    }
  }

  /// Error error unified processing
  DioError _handleError(DioError error) {
    // You can also handle error messages here based on the status code, such as logging out, etc.
    String errorTypeInfo = 'other errors! ';
    switch (error.type) {
      case DioErrorType.connectTimeout:
        errorTypeInfo = 'Connection timed out! ';
        return error;
      case DioErrorType.sendTimeout:
        errorTypeInfo = "Request timed out!";
        break;
      case DioErrorType.receiveTimeout:
        errorTypeInfo = "Response timed out!";
        break;
      case DioErrorType.response:
        errorTypeInfo = "Service exception!";
        break;
      case DioErrorType.cancel:
        errorTypeInfo = "request cancellation!";
        break;
      case DioErrorType.other:
        errorTypeInfo = "${error.message}";
        break;
      default:
        break;
    }
    Map logData = {
      'url': error.requestOptions.baseUrl + error.requestOptions.path,
      'method': error.requestOptions.method,
      'headers': error.response?.headers,
      'data': error.response?.data,
      'statusCode': error.response?.statusCode,
      'statusMessage': error.response?.statusMessage,
      'errorType': error.type,
      'errorMessage': error.message,
      'errorTypeInfo': errorTypeInfo,
    };
    _dealRequestInfo(logData, ERROR_TYPE_STR);
    Toast.hide();
    errorShowMsg = "abce";
    return error;
  }

  /// Combine print request logs REQUEST RESPONSE RESPONSE_ERROR
  String _dealRequestInfo(Map logData, String logType) {
    String logStr = "\n";
    logStr += "========================== $logType START =================== =======\n";
    logStr += "- URL: ${logData['url']} \n";
    logStr += "- METHOD: ${logData['method']} \n";
    // logStr += "- HEADER: \n { \n";
    // logStr += parseData(logData['headers']);
    // logStr += "\n } \n";
    if (logData['data'] != null) {
      logStr += "- ${logType}_BODY: \n";
      logStr += "!!!!!----------*!*##~##~##~##*!*##~##~##~##*!* ----------!!!!!! \n";
      logStr += "${parseData(logData['data'])} \n";
      logStr += "!!!!!----------*!*##~##~##~##*!*##~##~##~##*!* ----------!!!!!! \n";
    }
    if (logType.contains(RESPONSE_TYPE_STR)) {
      logStr += "- STATUS_CODE: ${logData['statusCode']} \n";
      logStr += "- STATUS_MSG: ${logData['statusMessage']} \n";
    }
    if (logType == ERROR_TYPE_STR) {
      logStr += "- ERROR_TYPE: ${logData['errorType']} \n";
      logStr += "- ERROR_MSG: ${logData['errorMessage']} \n";
      logStr += "- ERROR_TYPE_INFO: ${logData['errorTypeInfo']} \n";
    }
    logStr += "========================== $logType E N D ==================== =======\n";
    logWrapped(logStr);
    return logStr;
  }

  /// Unified result prompt processing
  Future _showResultDialog(Response? response, resultDialogConfig) async {
    if (response == null) {
      return;
    }
    resultDialogConfig = resultDialogConfig ?? {};
    String dialogType = resultDialogConfig['type'] ?? XHttp.DIALOG_TYPE_TOAST;
    if (dialogType == XHttp.DIALOG_TYPE_OTHERS) {
      return; // other types of OTHERS custom processing
    }
    bool isSuccess = response.data?.success ?? false;
    String msg = response.data?.msg ?? 'unknown mistake';
    if (dialogType == XHttp.DIALOG_TYPE_TOAST) {
      // resultDialogConfig can have successMsg, errorMsg
      isSuccess
          ? Toast.show(resultDialogConfig['successMsg'] ?? msg, type: Toast.SUCCESS)
          : Toast.show(resultDialogConfig['errorMsg'] ?? msg, type: Toast.ERROR);
      return;
    }
    if (dialogType == XHttp.DIALOG_TYPE_ALERT) {
      // resultDialogConfig can have title, content, closeable, showCancel, cancelText, confirmText, confirmCallback, cancelCallback, closeCallback ...
      // Utils.showDialog(...);
      return;
    }
    if (dialogType == XHttp.DIALOG_TYPE_CUSTOM) {
      // resultDialogConfig can have onSucess, onError
      if (isSuccess) {
        if (resultDialogConfig['onSuccess'] != null) {
          resultDialogConfig['onSuccess'](response.data);
        }
      } else {
        if (resultDialogConfig['onError'] != null) {
          resultDialogConfig['onError'](response.data);
        }
      }
    }
  }

  /// Handle exception
  void _catchOthersError(e) {
    String errMsg = "${errorShowMsg ?? e}$CUSTOM_ERROR_CODE".split(CUSTOM_ERROR_CODE)[0];
    int errMsgLength = errMsg.length;
    String errshowMsg = errMsgLength > 300 ? errMsg.substring(0, 150) : errMsg;
    if (e is DioError) {
      if (CancelToken.isCancel(e)) {
        Toast.show('Cancel Request Successful');
        return;
      }
      // Toast.show(errshowMsg, type: Toast.WARNING);
      return;
    }
    // Toast.show(errshowMsg + "\n...", type: Toast.ERROR);
  }

  /// XHttp.xxx can be called directly (add static keyword to the following methods such as get/post), but considering the situation of multiple servers, it is recommended to call XHttp.getInstance().xxx.
  static XHttp getInstance({String? baseUrl, String? msg}) {
    String targetBaseUrl = baseUrl ?? _instance._getBaseUrl();
    loadMsg = msg ?? DEFAULT_LOAD_MSG;
    if (dio?.options.baseUrl != targetBaseUrl) {
      dio?.options.baseUrl = targetBaseUrl;
    }
    return _instance;
  }

  /// Cancel all requests with default cancelToken
  static XHttp cancelRequest() {
    Toast.hide();
    cancelToken.cancel('cancel request');
    cancelToken =
        CancelToken(); // Pit! After cancellation, cancelToken must be recreated, otherwise subsequent requests using the original cancelToken will be invalid
    return _instance;
  }

  /// Cancel all whitelist cancelToken requests
  static XHttp cancelWhiteListRequest() {
    Toast.hide();
    whiteListCancelToken.cancel('cancel whiteList request');
    whiteListCancelToken = CancelToken();
    return _instance;
  }

  /// Get cancelToken
  static CancelToken getCancelToken() {
    return cancelToken;
  }

  /// Get whiteListCancelToken
  static CancelToken getWhiteListCancelToken() {
    return whiteListCancelToken;
  }

  /// Get a new cancelToken
  static CancelToken getNewCancelToken() {
    return CancelToken();
  }

  /// get request
  Future get(String url, [Map<String, dynamic>? params, resultDialogConfig, bool isCancelWhiteList = false]) async {
    // Write square brackets to ignore parameter names, because parameters must be passed in order。
    Response? response;
    CancelToken setCancelToken = isCancelWhiteList ? whiteListCancelToken : cancelToken;
    try {
      if (params != null) {
        response = await dio!.get(url, queryParameters: params, cancelToken: setCancelToken);
        return response.data;
      } else {
        response = await dio!.get(url, cancelToken: setCancelToken);
        return response.data;
      }
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response!, resultDialogConfig);
    }
  }

  /// post request
  Future post(String url, [Map<String, dynamic>? data, resultDialogConfig, bool isCancelWhiteList = false]) async {
    Response? response;
    try {
      response = await dio?.post(url, data: data, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
      return response?.data;
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response, resultDialogConfig);
    }
  }

  /// put request
  Future put(String url, [Map<String, dynamic>? data, resultDialogConfig, bool isCancelWhiteList = false]) async {
    Response? response;
    try {
      response = await dio?.put(url, data: data, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
      return response?.data;
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response, resultDialogConfig);
    }
  }

  /// patch request
  Future patch(String url, [Map<String, dynamic>? data, resultDialogConfig, bool isCancelWhiteList = false]) async {
    Response? response;
    try {
      response = await dio?.patch(url, data: data, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
      return response?.data;
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response, resultDialogConfig);
    }
  }

  /// delete request
  Future delete(String url, [Map<String, dynamic>? data, resultDialogConfig, bool isCancelWhiteList = false]) async {
    Response? response;
    try {
      response =
          await dio?.delete(url, data: data, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
      return response?.data;
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response, resultDialogConfig);
    }
  }

  /// request
  static Future request(
    String url, {
    String method = XHttp.GET,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool isCancelWhiteList = false,
    resultDialogConfig,
    Options? options,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    String? msg,
    String? baseUrl,
  }) async {
    XHttp.getInstance(baseUrl: baseUrl, msg: msg);
    Response? response;
    try {
      response = await dio?.request(
        url,
        options: options ?? Options(method: method, contentType: Headers.jsonContentType),
        queryParameters: queryParameters,
        data: data,
        cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return response?.data;
    } on DioError catch (e) {
      _instance._catchOthersError(e);
      var _data = jsonDecode(e.response?.data.data);
      var _msg = _data['message'];
      return Result(
        e.response?.data,
        false,
        e.response!.statusCode!,
        _msg ?? 'Something wen\'t wrong',
      );
    } finally {
      _instance._showResultDialog(
        response,
        resultDialogConfig ?? {'type': XHttp.DIALOG_TYPE_OTHERS},
      ); // request requests need to process the result by themselves by default
    }
  }

  /// download file
  Future downloadFile(urlPath, savePath, [resultDialogConfig, bool isCancelWhiteList = false]) async {
    Response? response;
    try {
      response = await dio?.download(urlPath, savePath, onReceiveProgress: (int count, int total) {
        // progress
        print("$count $total");
      }, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
      return response?.data;
    } catch (e) {
      _catchOthersError(e);
    } finally {
      _showResultDialog(response, resultDialogConfig);
    }
  }

  // /// post form request [Web]
  // Future postForm(String url, [Map<String, dynamic> params, resultDialogConfig, bool isCancelWhiteList = false]) async {
  // Response response;
  // try {
  // response = await dio.post(url,
  // queryParameters: params, cancelToken: isCancelWhiteList ? whiteListCancelToken : cancelToken);
  // return response.data;
  // } catch (e) {
  // _catchOthersError(e);
  // } finally {
  // _showResultDialog(response, resultDialogConfig);
  // }
  // }

  /// +++++++++++++++++++++++++ Small extension [to be added: retry, proxy/proxy, automatic exit and reconnection according to status code, etc.] +++++++++++++++++++++++++++
  /// Get the current baseUrl
  static String? getBaseUrl() {
    return dio?.options.baseUrl;
  }

  /// Set the current baseUrl
  static XHttp setBaseUrl(String baseUrl) {
    dio?.options.baseUrl = baseUrl;
    return _instance;
  }

  /// Get the current headers
  static Map? getHeaders() {
    return dio?.options.headers;
  }

  /// Get the current headers property
  static dynamic getHeader(String key) {
    return dio?.options.headers[key];
  }

  /// Set the current headers
  static XHttp setHeaders(Map headers) {
    dio?.options.headers = headers.cast<String, dynamic>();
    return _instance;
  }

  /// Set the current headers property
  static XHttp setHeader(String key, String value) {
    dio?.options.headers[key] = value;
    return _instance;
  }

  /// Delete the current request header attribute
  static XHttp removeHeader(String key) {
    dio?.options.headers.remove(key);
    return _instance;
  }

  /// Delete all current request header attributes
  static XHttp removeAllHeaders() {
    dio?.options.headers.clear();
    return _instance;
  }

  /// Get all current timeouts
  static Map getRequestTimeout() {
    return {
      'connectTimeout': dio?.options.connectTimeout,
      'receiveTimeout': dio?.options.receiveTimeout,
      'sendTimeout': dio?.options.sendTimeout
    };
  }

  /// Set all current timeouts
  static XHttp setRequestTimeout(int timeout) {
    dio?.options.connectTimeout = timeout;
    dio?.options.receiveTimeout = timeout;
    dio?.options.sendTimeout = timeout;
    return _instance;
  }

  /// Set the current connection timeout
  static XHttp setConnectTimeout(int timeout) {
    dio?.options.connectTimeout = timeout;
    return _instance;
  }

  /// Set the current receive timeout
  static XHttp setReceiveTimeout(int timeout) {
    dio?.options.receiveTimeout = timeout;
    return _instance;
  }

  /// Set the current sending timeout
  static XHttp setSendTimeout(int timeout) {
    dio?.options.sendTimeout = timeout;
    return _instance;
  }

  /// Get user data
  static Map<String, dynamic>? getAuthUser() {
    String? token = dio?.options.headers['authorization'];
    if (null == token) {
      return null;
    }
    // Parse token
    return {'account': 'xxx', 'name': 'xxx', 'roles': 'xxx'};
  }

  /// Set the current token
  static XHttp setAuthToken([String? token]) {
    // if (null == token) {
    // dio?.options.headers.remove('API-Auth');
    // dio?.options.headers.remove('API-KEY');
    // } else {
    // dio?.options.headers['API-Auth'] = token;
    // dio?.options.headers['API-KEY'] = '12345';
    // }
    return _instance;
  }

  /// Set the error message title
  static XHttp setErrorTitle(String msg) {
    errorShowTitle = msg;
    return _instance;
  }

// /// Set the current request data format
// static XHttp setContentType(String contentType) {
// dio.options.contentType = contentType;
// return _instance;
// }

// /// Set the current request data format
// static XHttp setContentTypeMultipartForm() {
// dio.options.contentType = "multipart/form-data";
// return _instance;
// }

// /// Set the current request return data format
// static XHttp setDataType(ResponseType dataType) {
// dio.options.responseType = dataType;
// return _instance;
// }

// /// Set the current request return data format
// static XHttp setDataTypeJson() {
// dio.options.responseType = ResponseType.json;
// return _instance;
// }

// ----- [cookie/charset/accept/encoder/decoder] These can be achieved by setting headers -----
  static void handleError(dynamic result) {
    // switch (result.code) {
    // case 401:
    //   SnackBarFailure(
    //     titleText: "Error!",
    //     messageText: result.msg ?? 'Unauthorized.',
    //   ).show();
    //   break;
    // case 500:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Internal Server Error').show();
    //   break;
    // case 404:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Not Found').show();
    //   break;
    // case 403:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Forbidden').show();
    //   break;
    // case 400:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Bad Request').show();
    //   break;
    // case 408:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Request Timeout').show();
    //   break;
    // case 502:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Bad Gateway').show();
    //   break;
    // case 503:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Service Unavailable').show();
    //   break;
    // case 504:
    //   SnackBarFailure(titleText: "Error!", messageText: result.msg ?? 'Gateway Timeout').show();

    //   break;
    // }
  }
}

/// ================================================== ======= The following content is a tool method ======================================= ===============
/// Analytical data
String parseData(data) {
  String responseStr = "";
  if (data is Map) {
    responseStr += data.mapToStructureString();
  } else if (data is FormData) {
    final formDataMap = Map()
      ..addEntries(data.fields)
      ..addEntries(data.files);
    responseStr += formDataMap.mapToStructureString();
  } else if (data is List) {
    responseStr += data.listToStructureString();
  } else {
    responseStr += data.toString();
  }
  return responseStr;
}

/// Segmented log, which can be written to the log.
void logWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

/// Map extension, Map to structured string output.
extension Map2StringEx on Map {
  String mapToStructureString({int indentation = 0, String space = " "}) {
    if (this == null || this.isEmpty) {
      return "$this";
    }
    String result = "";
    String indentationContent = space * indentation;
    result += "{";
    this.forEach((key, value) {
      if (value is Map) {
        result += "\n$indentationContent" + "\"$key\": ${value.mapToStructureString(indentation: indentation + 1)},";
      } else if (value is List) {
        result += "\n$indentationContent" + "\"$key\": ${value.listToStructureString(indentation: indentation + 1)},";
      } else {
        result += "\n$indentationContent" + "\"$key\": ${value is String ? "\"$value\"," : "$value,"}";
      }
    });
    result = result.substring(0, result.length - 1); // remove last comma
    result += "\n$indentationContent}";
    return result;
  }
}

/// List extension, List to structured string output.
extension List2StringEx on List {
  String listToStructureString({int indentation = 0, String space = " "}) {
    if (this == null || this.isEmpty) {
      return "$this";
    }
    String result = "";
    String indentationContent = space * indentation;
    result += "[";
    for (var value in this) {
      if (value is Map) {
        result += "\n$indentationContent" +
            space +
            "${value.mapToStructureString(indentation: indentation + 1)},"; // looks better with spaces
      } else if (value is List) {
        result += value.listToStructureString(indentation: indentation + 1);
      } else {
        result += "\n$indentationContent" + value is String ? "\"$value\"," : "$value,";
      }
    }
    result = result.substring(0, result.length - 1); // remove last comma
    result += "\n$indentationContent]";
    return result;
  }
}

/// Result processing
class Result {
  var data;
  bool success;
  int code;
  String msg;
  var headers;
  Result(this.data, this.success, this.code, this.msg, {this.headers});
}

class Toast {
  Toast._() {
    // EasyLoading has initialized the build globally
    // EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    // Custom styles are available here
  }
  static final Toast _instance = Toast._();

  static const String SUCCESS = "SUCCESS";
  static const String ERROR = "ERROR";
  static const String WARNING = "WARNING";
  static const String INFO = "INFO";

  static loading(String msg) {
    EasyLoading.show(status: msg);
  }

  static progeress(double value, String msg) {
    EasyLoading.showProgress(value, status: msg);
  }

  static show(String msg, {String? type}) {
    switch (type) {
      case Toast.SUCCESS:
        EasyLoading.showSuccess(msg);
        break;
      case Toast.ERROR:
        EasyLoading.showError(msg);
        break;
      case Toast.WARNING:
        EasyLoading.showInfo(msg);
        break;
      case Toast.INFO:
      default:
        EasyLoading.showToast(msg);
        break;
    }
  }

  static hide() {
    EasyLoading.dismiss();
  }
}

// /// Example of use: If multiple baseUrls are not set, getInstance() can be omitted, remember to set the static keyword for get, post or directly initialize multiple instances of baseUrl. You can also refer to request to set baseUrl in get and post methods.
// XHttp.getInstance().post("/user/login", {
// "username": username,
// "password": password
// }).then((res) {
// // DO SOMETHING
// }).catchError((err) {
// // DO SOMETHING
// });
