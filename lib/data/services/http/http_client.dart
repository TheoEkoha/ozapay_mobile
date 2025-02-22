import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ozapay/data/models/auth/login_model.dart';
import 'package:retrofit/retrofit.dart';

part 'http_client.g.dart';

@injectable
@RestApi()
abstract class HttpClient {
  @factoryMethod
  factory HttpClient(
    Dio dio, {
    @Named('apiBaseUrl') String baseUrl,
  }) = _HttpClient;

  @GET('/users')
  Future getUsers();

  @GET('/users')
  Future getUserByEmail(@Query('email') String email);

  @POST("/user/email_login/prepare")
  Future verifyEmailAndPassword(@Body() Map<String, dynamic> body);

  @POST("/user/sms_login/prepare")
  Future signinPhone(@Body() Map<String, dynamic> body);

  @POST("/user/login")
  Future<LoginModel> login(@Body() Map<String, dynamic> body);

  @POST("/users")
  Future register(@Body() Map<String, dynamic> body);

  @PATCH('/user/{id}')
  Future patchUser(@Path('id') int id, @Body() Map<String, dynamic> body);

  @POST("/user/verify/{id}")
  Future verifyCode(@Path('id') int id, @Body() Map<String, dynamic> body);

  @POST("/user/code/resend/{id}")
  Future resendCode(@Path('id') int id, @Body() Map<String, dynamic> body);

  @PATCH('/user/new/pass')
  Future updateUserPassword(@Body() Map<String, dynamic> body);

  @POST("/token/refresh")
  Future<LoginModel> refreshToken(@Body() Map<String, dynamic> body);
}
