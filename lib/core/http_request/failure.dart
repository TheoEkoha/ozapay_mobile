part of 'multiple_result.dart';

abstract class Failure implements Exception {
  final List<String> message;

  const Failure(this.message);

  factory Failure.fromRequest(Response<dynamic>? response) {
    if (response?.statusCode != null && response?.statusMessage != null) {
      List<String> status = [];

      status.add(response!.statusMessage ?? "");

      switch (response.statusCode) {
        case HttpStatus.badRequest:
          return BadRequestFailure(status);

        case HttpStatus.unauthorized:
          return UnAuthorizedFailure(status);

        case HttpStatus.forbidden:
          return ForbiddenFailure(status);

        case HttpStatus.notFound:
          return NotFoundFailure(status);

        case HttpStatus.internalServerError:
          return InternalServerFailure(status);

        case HttpStatus.gatewayTimeout:
          return TimeoutFailure(status);

        default:
          return UncategorizedFailure(status);
      }
    } else {
      return const UnknownFailure(
        ["Une erreur est survenue! Veuillez réessayer plus tard!"],
      );
    }
  }
}

/// 400
class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

/// 401
class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure(super.message);
}

/// 403
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

/// 404
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// 500
class InternalServerFailure extends Failure {
  const InternalServerFailure(super.message);
}

/// 503
class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure(super.message);
}

/// 504
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class UncategorizedFailure extends Failure {
  const UncategorizedFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class InternetConnectionFailure extends Failure {
  const InternetConnectionFailure(super.message);
}

class WalletFailure extends Failure {
  const WalletFailure(super.message);
}
