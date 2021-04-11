// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Eventify library.
/// Eventify provides an effective interface for subscribing and emitting events.
/// This framework also emits context based events.
/// Subscriptions can be cancelled using the default cancellation logic available with subscriber itself.
library eventify;

part 'src/event.dart';
part 'src/event_emitter.dart';
part 'src/listener.dart';
