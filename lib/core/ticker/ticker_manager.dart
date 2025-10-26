import 'package:flutter/scheduler.dart';

abstract class TickerManagerProtocol {
  bool get isActive;
  VoidCallback? onTick;
  void stop();
  void dispose();
  void start(TickerProvider vsync);
}

class TickerManager extends TickerManagerProtocol {
  Ticker? _ticker;
  Duration _lastFetch = Duration.zero;
  final Duration fetchInterval;

  TickerManager({required this.fetchInterval});

  @override
  void start(TickerProvider vsync) {
    _ticker?.dispose();
    _ticker = vsync.createTicker((elapsed) {
      if (elapsed - _lastFetch >= fetchInterval) {
        _lastFetch = elapsed;
        onTick?.call();
      }
    })..start();
  }

  @override
  void stop() {
    _ticker?.stop();
  }

  @override
  bool get isActive => _ticker?.isActive ?? false;

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
  }
}
