import consumer from "./consumer"

consumer.subscriptions.create("TextsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Hello from TextsChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("We have received some data: ", data)
  }
});
