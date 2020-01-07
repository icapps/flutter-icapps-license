part 'injector.g.dart';

abstract class Injector {
  void registerCommonDependencies();

  void registerViewModelFactories();
}

void setupDependencyTree() {
  _$Injector()
    ..registerCommonDependencies()
    ..registerViewModelFactories();
}
