// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of eventify;

/// Handler for cancelling the event registration.
typedef void CancelEvent();

/**
 * Listener is one who listen for specific event.
 * Listener register for notification with EventEmitter
 * Once the listener is registered, a Listener interface is returned back to the caller.
 * Caller can use this Listener interface to cancel the registration or check the state.
 */
class Listener {
  /// A mechanism to cancel the event.
  CancelEvent? _cancelCallback;

  /// The event name, the subscriber subscribed to.
  final String eventName;

  /// The context from which subscriber is interested in.
  final Object? context;

  /**
   * The event callback, which the subscriber uses when he register it for.
   */
  final EventCallback callback;

  /// Constructor for Listener.
  /// This will take four arguments.
  /// [eventName], [callback] are mandatory.
  /// [context], [_cancelCallback] are optional.
  /// if [_cancelCallback] callback is provided, then the listener can use that to cancel the subscription.
  Listener(this.eventName, this.context, this.callback, this._cancelCallback);

  /// Constructor for Listener.
  /// This will take four arguments.
  /// [eventName], [callback] are mandatory.
  /// [context] is optional.
  Listener.Default(this.eventName, this.context, this.callback);

  /// Cancel the event subscription with the subject.
  /// Eventhough the cancel method is called, listener doesn't check the cancellation of the subscription.
  /// Subscription cancellation shall be implemented in the _cancelCallback function.
  /// The Default constructor doesn't provide a mechanism to cancel the subscription.
  /// Use the EventEmitter.on to cancel the suscrition effectively.
  /// Returns true, if _cancelCallback is successfully executed, false otherwise.
  bool cancel() {
    if (null != this._cancelCallback) {
      this._cancelCallback!();
      return true;
    }

    return false;
  }
}
