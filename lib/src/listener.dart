// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of eventify;

/// Handler for cancelling the event registration.
typedef void CancelEvent();

/// Listener is one who listen for specific event.
/// Listener register for notification with EventEmitter
/// Once the listener is registered, a Listener interface is returned back to the caller.
/// Caller can use this Listener interface to cancel the registration or check the state.
class Listener {
  /// A mechanism to cancel the event.
  final CancelEvent cancel;

  /// The event name, the subscriber subscribed to.
  final String eventName;

  /// The context from which subscriber is interested in.
  final Object context;

  /// The event callback, which the subscriber uses when he register it for.
  final EventCallback callback;

  /// Constructor for Listener.
  /// This will take four arguments.
  /// [eventName], [callback] are mandatory.
  /// [context], [cancel] are optional.
  /// if [cancel] callback is provided, then the listener can use that to cancel the subscription.
  Listener(this.eventName, this.context, this.callback, this.cancel);
}
