/// Listener is one who listen for specific event.
/// Listener register for notification with EventEmitter
/// Once the listener is registered, a Listener interface is returned back to the caller.
/// Caller can use this Listener interface to cancel the registration or check the state.
///

part of eventify;

typedef void CancelEvent();

class Listener {
  /// A mechanism to cancel the event.
  final CancelEvent cancel;

  /// The event name, the subscriber subscribed to.
  final String eventName;

  /// The context from which subscriber is interested in.
  final Object context;

  Listener(this.eventName, this.context, this.cancel);
}
