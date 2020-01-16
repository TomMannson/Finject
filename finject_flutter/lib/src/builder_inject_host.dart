import 'package:finject/finject.dart';
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/material.dart';

class BuilderInjectHost extends StatelessWidget {
  final LayoutInjectWidgetBuilder builder;
  final InjectionProviderImpl _provider;

  @protected
  BuilderInjectHost(this.builder) : _provider = InjectionProviderImpl();

  @override
  Widget build(BuildContext context) {
    _provider.context = context;
    Widget child = builder(context, _provider);
    _provider.inject(child);
    return child;
  }
}

typedef LayoutInjectWidgetBuilder = Widget Function(BuildContext context, InjectionProvider finjector);
