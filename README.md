# EventEmitter

EventEmitter for dart. This can be used in any application to register for events and get notified once it is fired.

----------


This library provide mechanism to register for event notifications with emitter or publisher and get notified in the event of an event.

One main advantage of the mehanism is that, it support context from where the subscriber is listening. The context could be any additional data the subscriber is interested in.

Another feature this has is the ability to receive sender information, which could be handy if the subscriber wish to know about the publisher.

## Example

```Dart
    void performAddition(){

    }

    EventCallback cb = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              performAddition();
              break;
          }
        }
      };

    EventEmitter emitter = new EventEmitter();
    Listener listener = emitter.on("add", this , cb);

    emitter.emit("add","keyboard",10);

```

----------

As shown in the above example, it is easy to register for events and get notified once it is triggered.

