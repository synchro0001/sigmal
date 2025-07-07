class Signal {
  constructor() {
    this.topics = new Map();
  }

  send(topics, message) {
    for (const topic of topics) {
      const receivers = this.topics.get(topic);
      if (receivers) {
        receivers.forEach((receiver) => {
          receiver.resolve(message);
        });
        this.topics.set(topic, []);
      }
    }
  }

  receive(topics) {
    return new Promise((resolve, reject) => {
      for (const topic of topics) {
        if (!this.topics.has(topic)) {
          this.topics.set(topic, []);
        }
        this.topics.get(topic).push({ resolve, reject });
      }
    });
  }
}

export function newSignal() {
  return new Signal();
}

export function send(signal, topics, message) {
  return signal.send(topics, message);
}

export async function receive(signal, topics) {
  return await signal.receive(topics);
}
