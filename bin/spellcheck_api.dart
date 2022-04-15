import 'package:shelf/shelf.dart' ;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'check.dart';


void main(List<String> args) async {

final app = Router();

app.get('/',(Request request){
  return Response.ok('Hello World Check');
}) ;

app.post('/check',(Request request)async{
  final payload = await request.readAsString();
  final data = spellcheck(payload);
  return Response.ok(data);

}

);

app.get('/check',(Request request){
  return Response.ok('');

}
);
 

  var server = await io.serve(app,'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}

