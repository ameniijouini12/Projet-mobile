import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/offer.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:hiatunisie/services/offer.service.dart';
import 'package:hiatunisie/utils/countdownDisplay.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;
  final TextStyle? textStyle;
  final String offerId;
  final OfferService offerService;

  const CountdownTimer({
    super.key,
    required this.endTime,
    required this.textStyle,
    required this.offerId,
    required this.offerService,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration? _remaining;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _startTimer();
  }

  void _updateRemaining() {
    if (_disposed) return;
    
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);
    
    if (remaining.isNegative) {
      _handleExpiration();
    } else {
      setState(() => _remaining = remaining);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      _updateRemaining();
    });
  }

  void _handleExpiration() {
    if (_disposed) return;
    
    _timer?.cancel();
    setState(() => _remaining = null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed) return;
      
      final offerViewModel = Provider.of<OfferViewModel>(context, listen: false);
      offerViewModel.removeOfferLocally(widget.offerId);
      
      widget.offerService.deleteOfferById(widget.offerId).catchError((error) {
        if (!error.toString().contains('404')) {
          debugPrint('Error deleting offer ${widget.offerId}: $error');
        }
      });
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == null) {
      return const SizedBox.shrink();
    }

    final days = _remaining!.inDays;
    final hours = _remaining!.inHours % 24;
    final minutes = _remaining!.inMinutes % 60;
    final seconds = _remaining!.inSeconds % 60;

    String text;
    if (_remaining!.inHours >= 24) {
      text = '${days}j:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (_remaining!.inHours >= 1) {
      text = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (_remaining!.inMinutes >= 1) {
      text = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      text = '${_remaining!.inSeconds} second${_remaining!.inSeconds == 1 ? '' : 's'}';
    }

    return CountdownDisplay(
      key: ValueKey('countdown_${widget.offerId}_${_remaining!.inSeconds}'),
      text: text,
      textStyle: widget.textStyle,
    );
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endTime != widget.endTime) {
      _updateRemaining();
      _startTimer();
    }
  }
}
