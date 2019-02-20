
import 'package:http/http.dart' show BaseRequest, StreamedResponse;
import 'package:http/io_client.dart' show IOClient;

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
}
