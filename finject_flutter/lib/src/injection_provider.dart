//import 'package:get_it/get_it.dart';
import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

abstract class AbstractInjectionProvider extends InjectionProvider {
  BuildContext context;

  FoundInjection findParrent(BuildContext context);
}

class FoundInjection {
  InjectionProvider provider;
  BuildContext foundIn;

  FoundInjection(this.provider, this.foundIn);
}
