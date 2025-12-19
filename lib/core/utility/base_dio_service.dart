// hata yakalamaya yardımcı olur
import 'package:dio/dio.dart';

class BaseDioService {
  BaseDioService._();
  static final BaseDioService service = BaseDioService._();

  String handleDioError(DioException e,String? responsemMessage) {
    String message;
    // MyLog.debug("handleDioError $responsemMessage");
    if (responsemMessage != null) {
        // MyLog.debug("handleDioError0");
      message = responsemMessage;
    } else {
      switch (e.type) {
        case DioExceptionType.connectionError:
        // MyLog.debug("handleDioError1");
          message =
              "İnternet bağlantınızı kontrol edip daha sonra tekrar deneyin.";
          break;
        case DioExceptionType.connectionTimeout:
        // MyLog.debug("handleDioError2");
          message =
              responsemMessage ?? "Bağlantı zaman aşımına uğradı.";
          break;
        case DioExceptionType.badCertificate:
        // MyLog.debug("handleDioError3");
          message =
              responsemMessage ?? "Bir sorun oluştu:Hata kodu #1";
          break;
        case DioExceptionType.badResponse:
        // MyLog.debug("handleDioError4");
          message =
              responsemMessage ?? "Bir sorun oluştu:Hata kodu #2";
          break;
        case DioExceptionType.receiveTimeout:
        // MyLog.debug("handleDioError5");
          message =
              responsemMessage ?? "Bir sorun oluştu:Hata kodu #3";
          break;
        default:
        // MyLog.debug("handleDioError6");
          message =
              responsemMessage ?? "Bir sorun oluştu:Hata kodu #5";
          break;
      }
    }

    return message;
  }
}