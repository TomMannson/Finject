import 'package:finject/finject.dart';

@Injectable()
class DependencyClass {
  @Inject()
  DependencyClass2 dependencyClass2;
}

@Injectable()
class DependencyClass2 {}
