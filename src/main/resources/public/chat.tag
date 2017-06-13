<chat>
    <div id="wrapper">
        <section id="left">
            <div id="chatControls">
                <input id="message" ref="message" placeholder="Type your message" onkeyup={onKeyUp}>
                <button id="send" onclick={onClick}>Send</button>
            </div>

            <Article each={messages}>
                <b>
                    {sender} says:
                </b>
                <p>
                    {message}
                </p>
                <span class="timestamp">
                    {timestamp}
                </span>
            </Article>
        </section>

        <section id="right">
            <ul id="userlist">
                <li each={users}>{user}</li>
            </ul>
        </section>
    </div>




    <script>
        var self = this
        this.messages = [];
        this.users = [];

        //Establish the WebSocket connection and set up event handlers
        var webSocket = new WebSocket("ws://" + location.hostname + ":" + location.port + "/chat");
        webSocket.onmessage = function (msg) { updateChat(msg); };
        webSocket.onclose = function () { alert("WebSocket connection closed") };

        function updateChat(msg) {
            var data = JSON.parse(msg.data);
            self.messages.unshift({
                'message': data.message,
                'sender' : data.sender,
                'timestamp' : data.timestamp,
            });
            self.users = [];
            data.userList.forEach(function(user){
                self.users.push({'user': user});
            });
            self.update();
        }

        onClick(e) {
            sendMessage(self.refs.message.value);
        }

        onKeyUp(e) {
            if (e.keyCode === 13) { sendMessage(e.target.value); }
        }

        function sendMessage(message) {
            if (message !== "") {
                webSocket.send(message);
                self.refs.message.value.value = "";
            }
        }
    </script>
</chat>