// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of eventify;

/// The callback function to receive event notification.
/// [ev] - [Event] event emitted by the publisher.
/// [context] - [Object] passed while registering the subscription as context. This is useful especially when the listener want to receive context information for all future events emitted for the context.
typedef void EventCallback(Event ev, Object context);

/// This class provides necessary implementations for subscribing and cancelling the event subscriptions and publishing events to the subcribers.
class EventEmitter {
  Map<String, Set<Listener>> _listeners = Map<String, Set<Listener>>();

  /// API to register for notification.
  /// It is mandatory to pass event name and callback parameters.
  /// [event] - Event name used for the subscription. A valid event name is mandatory.
  /// [context] - Context information, which need to be sent in all emitted events.
  /// [callback] - [EventCallback] function registered to receive events emitted from the publisher. A valid callback function is mandatory.
  Listener on(String event, Object context, EventCallback callback) {
    if (null == event || event.trim().isEmpty) {
      throw ArgumentError.notNull("event");
    }

    if (null == callback) {
      throw ArgumentError.notNull("callback");
    }

    // Check if the particular listener is there in the listeners collection
    // Return the listener instance, if already registered.

    Set<Listener> subs =
        this._listeners.putIfAbsent(event, () => Set<Listener>());

    // Create new element.
    Listener listener = Listener.Default(event, context, callback);

    listener._cancelCallback = () {
      this._removeListener(listener);
    };

    subs.add(listener);

    return listener;
  }

  /// Remove event listener from emitter.
  /// This will unsubscribe the caller from the emitter from any future events.
  /// Listener should be a valid instance.
  /// [listener] - [Listener] instance to be removed from the event subscription.
  void off(Listener listener) {
    if (null == listener) {
      throw ArgumentError.notNull("listener");
    }

    // Check if the listner has a valid callback for cancelling the subscription.
    // Use the callback to cancel the subscription.
    if (false == listener.cancel()) {
      // Assuming that subscription was not cancelled, could be that the cancel callback was not registered.
      // Follow the old trained method to remove the subrscription .
      this._removeListener(listener);
    }
  }

  /// Private method to remove a listener from subject.
  /// The listener should not be a null object.
  void _removeListener(Listener listener) {
    if (null == listener) {
      throw new ArgumentError.notNull("listener");
    }
    if (_listeners.containsKey(listener.eventName)) {
      var subscribers = _listeners[listener.eventName];

      subscribers.remove(listener);
      if (subscribers.length == 0) {
        this._listeners.remove(listener.eventName);
      }
    }
  }

  /// Unsubscribe from getting any future events from emitter.
  /// This mechanism uses event name and callback to unsubscribe from all possible events.
  /// [eventName] - Event name for the subscription.
  /// [callback] - [EventCallback] used when registering subscription using [on] function.
  void removeListener(String eventName, EventCallback callback) {
    if (null == eventName || eventName.trim().isEmpty) {
      throw ArgumentError.notNull("eventName");
    }

    if (null == callback) {
      throw ArgumentError.notNull("callback");
    }

    // Check if listeners have the specific event already registered.
    // if so, then check for the callback registration.

    if (this._listeners.containsKey(eventName)) {
      Set<Listener> subs = this._listeners[eventName];
      subs.removeWhere((element) =>
          element?.eventName == eventName && element?.callback == callback);
    }
  }

  /// API to emit events.
  /// event is a required parameter.
  /// If sender information is sent, it will be used to intimate user about it.
  /// [event] - What event needs to be emitted.
  /// [sender] - The sender who published the event. Ignore if not required.
  /// [data] - Data the event need to carry. Ignore this argument if no data needs to be sent.
  void emit(String event, [Object sender, Object data]) {
    if (null == event || event.trim().isEmpty) {
      throw ArgumentError.notNull("event");
    }

    if (this._listeners.containsKey(event)) {
      Event ev = Event(event, data, sender);
      List<Listener> sublist = this._listeners[event].toList();
      sublist.forEach((item) {
        if (null == item || ev.handled) {
          return;
        }
        item.callback(ev, item.context);
      });
    }
  }

  /// Clear all subscribers from the cache.
  void clear() {
    this._listeners.clear();
  }

  /// Remove all listeners which matches with the callback provided.
  /// It is possible to register for multiple events with a single callback.
  /// This mechanism ensure that all event registrations would be cancelled which matches the callback.
  /// [callback] - The event callback used during subscription.
  void removeAllByCallback(EventCallback callback) {
    if (null == callback) {
      throw ArgumentError.notNull("callback");
    }
    this._listeners.forEach((key, lst) {
      lst.removeWhere((item) => item?.callback == callback);
    });
  }

  /// Use this mechanism to remove all subscription for a particular event.
  /// Caution : This will remove all the listeners from multiple files or classes or modules.
  /// Think twice before calling this API and make sure you know what you are doing!!!
  /// [event] - Event name used during subscription.
  void removeAllByEvent(String event) {
    if (null == event || event.trim().isEmpty) {
      throw ArgumentError.notNull("event");
    }
    this._listeners.removeWhere((key, val) => key == event);
  }

  /// Get the unique count of events registered in the emitter.
  int get count => this._listeners.length;

  /// Get the list of subscribers for a particular event.
  int getListenersCount(String event) =>
      this._listeners.containsKey(event) ? this._listeners[event].length : 0;
}
