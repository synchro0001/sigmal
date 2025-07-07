//// See the readme for an example and some usage notes.

import gleam/javascript/array.{type Array}
import gleam/javascript/promise.{type Promise}

pub type Signal(a)

@external(javascript, "./signal.js", "newSignal")
pub fn new() -> Signal(a)

/// Sends a message to the default (empty string, `""`) topic of the signal. 
/// This will not send a message to any of the other topics, i.e. is
/// not a catch-all.
pub fn send(signal signal: Signal(a), message message: a) -> Nil {
  send_to_topic(signal, "", message)
}

/// Sends a message to the specified topic. 
/// 
/// Do not use the empty string (`""`) topic as that is reserved for the `send` 
/// and `receive` functions.
pub fn send_to_topic(
  signal signal: Signal(a),
  topic topic: String,
  message message: a,
) -> Nil {
  send_to_topics(signal, [topic], message)
}

/// Sends a message to the specified topics. The message are sent in the order
/// of the topics provided.
/// 
/// Do not use the empty string (`""`) topic as that is reserved for the `send` 
/// and `receive` functions.
pub fn send_to_topics(
  signal signal: Signal(a),
  topics topics: List(String),
  message message: a,
) -> Nil {
  do_send_to_topics(signal:, topics: array.from_list(topics), message:)
}

@external(javascript, "./signal.js", "send")
fn do_send_to_topics(
  signal signal: Signal(a),
  topics topics: Array(String),
  message message: a,
) -> Nil

/// Receives a message from the default (empty string, `""`) topic of the signal.
/// This will not receive messages from any of the other topics, i.e. is
/// not a catch-all. 
pub fn receive(signal signal: Signal(a)) -> promise.Promise(a) {
  receive_from_topic(signal, "")
}

/// Receives a message from the specified topic. 
/// 
/// Do not use the empty string (`""`) topic as that is reserved for the `send` 
/// and `receive` functions.
pub fn receive_from_topic(
  signal signal: Signal(a),
  topic topic: String,
) -> Promise(a) {
  receive_from_topics(signal, [topic])
}

/// Receive a message to the specified topics. Only the first message to any of 
/// the topics is returned, and the rest ignored.
/// 
/// Do not use the empty string (`""`) topic as that is reserved for the `send` 
/// and `receive` functions.
pub fn receive_from_topics(
  signal signal: Signal(a),
  topics topics: List(String),
) -> Promise(a) {
  do_receive_from_topics(signal:, topics: array.from_list(topics))
}

@external(javascript, "./signal.js", "receive")
fn do_receive_from_topics(
  signal signal: Signal(a),
  topics topics: Array(String),
) -> Promise(a)
