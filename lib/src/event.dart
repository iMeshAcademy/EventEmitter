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
  final Object eventData;

  /// If this field is valid, then it shows who send the event to.
  /// This can be very useful while debugging systems with large event queues.
  final Object sender;

  ///
  /// The context at which the listner want to process the data.
  /// Perform sanity checks before using this field.
  ///
  final Object context;

  Event(this.eventName,
      [this.eventData = null, this.context = null, this.sender = null]);
}
