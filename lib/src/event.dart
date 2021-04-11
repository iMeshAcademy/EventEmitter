// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of eventify;

///
/// Event class. This is send back to the subscriber when an event is triggered,
/// Subscriber can use the instance to retrieve the event data and other event related parameters.
/// eventName is a mandatory parameter and will represent the current event.
class Event {
  /// What event the emitter triggers.
  /// This is very useful to perform actions if you have single event handler to perform multiple operations.
  final String eventName;

  /// If the event associated has any event data, then this object holds reference to it.
  /// Few events might not return data. Validate this field before using it.
  final Object? eventData;

  /// If this field is valid, then it shows who send the event to.
  /// This can be very useful while debugging systems with large event queues.
  final Object? sender;

  /// Flag to identify whether the event is already handled.
  /// This is useful if we have event bubbling supported, where in it could be handled in any of the
  /// inheritance hirearchy or handled in one of the listener.
  /// Event should not be passed to other listeners if it is already handled by one listener.
  bool _handled = false;

  /// Default constructor for the Event class.
  /// [eventName] - the name of the event, used to identify the event.
  /// [eventData] - The data associated with the event.
  /// [sender] - Identifier to identify who is sending the event.
  Event(this.eventName, [this.eventData, this.sender]);

  /// Getter to fetch handled information.
  bool get handled => _handled;

  /// Setter to set the handled information. If handled already, then setting this value to false doesn't affect.
  set handled(bool val) => _handled = _handled || val;
}
