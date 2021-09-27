import 'package:dartz/dartz.dart';
import 'package:sparks/models/CirclesListModel.dart';
import 'package:sparks/repository/CIrclesRepo.dart';

class CircleBloc {
  var repo = CirclesRepo();

  Future<Either<String, CirclesListModel>> circlesList() async {
    // _showLoader.sink.add(true);
    Either<String, CirclesListModel> result = await repo.getCirclesData();
    // var result = await repo.loginUser(_email.value, _password.value);

    result.fold((l) {
      //   _showLoader.sink.add(false);
      Left<String, CirclesListModel>(l);
    }, (r) {
      // _showLoader.sink.add(false);

      Right<String, CirclesListModel>(r);
    });
    return result;
  }
}
