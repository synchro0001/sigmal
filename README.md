# sigmal

[![Package Version](https://img.shields.io/hexpm/v/sigmal)](https://hex.pm/packages/sigmal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/sigmal/)

This is a dead simple signals library for the JavaScript target. It allows long-running processes to communicate. I made it to use on a web server, but it can be used in just about any application.

## Example

Here is a minimal example with [`smol`](http://hexdocs.pm/smol). Every time a request is made to the `say` path, the server emits `say` SSE events on the `listen` path.

```gleam
pub fn main() {
  let signal = signal.new()
  smol.new(handler(_, signal))
  |> smol.start
}

pub fn handler(request, signal) {
  case request.path_segments(request) {
    ["say", msg] -> {
      signal.send(signal, msg)
      smol.send_status(200)
    }
    ["listen"] ->
      smol.server_sent_events(Nil, fn(_) {
        use msg <- promise.await(signal.receive(signal))
        smol.send(Nil, smol.SseEvent(Some("say"), msg, None, None))
      })
    _ -> smol.send_status(404)
  }
  |> promise.resolve
}
```

## Usage

Always begin by creating your `Signals`. They must be shared in order for communication to work. There is no way to name a `Signal` or find one by name.

`Signals` are generic over the type of messages they transfer. This means that one `Signal` can only deliver one type of message, even across different topics. If you need to listen for multiple types of messages, you can either use multiple `Signals` (which is problematic because you can only await a `receive` call on one of them at a time), or write a wrapper type: 

```gleam
type Msg1 {
  Msg1(..)
}

type Msg2 {
  Msg2(..)
}

type MsgWrapper {
  Msg1Wrapper(Msg1)
  Msg2Wrapper(Msg2)
}

// inside a function
  use msg <- promise.await(signal.receive(my_signal))
  case msg {
    Msg1Wrapper(_) -> ..
    Msg2Wrapper(_) -> ..
  }

```

`receive_*` calls are resolved immediately after a `send_*` call is made to the corresponding topic(s). Messages are not stored or queued, i.e. if a message is not received, it is lost forever. This means that in order for a message to be delivered successfully, `receive_*` must be called *before* `send_*`.

There is no way to subscribe to messages from a signal / topic. However, you should be able to replicate this functionality with a recursive async function that repeatedly calls `receive_*`.

## Notes 

Please remember that this is a "dead simple" library. I do not intend to add any more complex functionality to it. However, please do feel free to use my code as a base for writing your own. 

I have done very little testing with this library. Bug reports are welcome.