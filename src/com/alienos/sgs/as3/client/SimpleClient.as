/*
 *  Copyright (c) 2008 Jonathan Wagner
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.alienos.sgs.as3.client
{
        import com.alienos.sgs.as3.protocol.SimpleSgsProtocol;
        import com.alienos.sgs.as3.util.HashMap;
        import com.alienos.sgs.as3.util.SgsByteArray;
        
        import flash.events.Event;
        import flash.events.EventDispatcher;
        import flash.events.ProgressEvent;
        import flash.net.Socket;
        import flash.utils.ByteArray;

        public class SimpleClient extends EventDispatcher
        {

                //Currently unused
                private var reconnectKey:ByteArray=new ByteArray();
                private var channels:HashMap=new HashMap();
                private var sock:Socket;//=new Socket(null, 0);
                private var host:String;
                private var port:int;
                private var username:String;
                private var passwd:String;
                private var messageFilter:MessageFilter;


                /**
                 * Constructs the SimpleClient. The provided host and port
                 * will be used to connect when the login() method is called
                 */
                public function SimpleClient(host:String, port:int)
                {
                        this.host=host;
                        this.port=port;
                        sock=new Socket(host, port);
                        sock.addEventListener(Event.CLOSE, onClose);
                        sock.addEventListener(Event.CONNECT, onConnect);
                        sock.addEventListener(ProgressEvent.SOCKET_DATA, onData);
                        messageFilter=new MessageFilter();
                        messageFilter.addEventListener(SgsEvent.RAW_MESSAGE, onRawMessage);
                }

                /**
                 *  Reqest a login with the specified username and password.
                 */
                public function login(username:String, passwd:String):void
                {
                        sock.connect(host, port);
                        this.username=username;
                        this.passwd=passwd;
                }

                /**
                 *  Sends a message to the specified channel.
                 */
                public function channelSend(channel:ClientChannel, message:ByteArray):void
                {
                        var buf:ByteArray=new ByteArray();
                        buf.writeByte(SimpleSgsProtocol.CHANNEL_MESSAGE);
                        buf.writeShort(channel.rawId.length);
                        buf.writeBytes(channel.rawId);
                        buf.writeBytes(message);
                        buf.position=0;
                        sock.writeShort(buf.length);
                        sock.writeBytes(buf);
                        sock.flush();
                }

                /**
                 * Returns a list of channels a client has currently joined.
                 */
                public function getChannels():Array
                {
                        return channels.getValues();
                }

                /**
                 *  Sends message to sgs over the session connection
                 */
                public function sessionSend(message:ByteArray):void
                {
                        var buf:ByteArray=new ByteArray();
                        buf.writeByte(SimpleSgsProtocol.SESSION_MESSAGE);
                        buf.writeBytes(message);
                        sock.writeShort(buf.length);
                        sock.writeBytes(buf);
                        sock.flush();
                }

                public function logout(force:Boolean=false):void
                {
                        if (force)
                        {
                                sock.close();
                        }
                        else
                        {
                                var buf:ByteArray=new ByteArray();
                                buf.writeByte(SimpleSgsProtocol.LOGOUT_REQUEST);
                                sock.writeShort(buf.length);
                                sock.writeBytes(buf);
                                sock.flush();
                        }
                }


                private function onClose(event:Event):void
                {
                        dispatchEvent(new SgsEvent(SgsEvent.LOGOUT));
                }

                /**
                 * Once the connection is established, we can complete the login
                 */
                private function onConnect(event:Event):void
                {
                        var buf:ByteArray=new ByteArray();
                        buf.writeByte(SimpleSgsProtocol.LOGIN_REQUEST);
                        buf.writeByte(SimpleSgsProtocol.VERSION);
                        buf.writeUTF(username);
                        buf.writeUTF(passwd);
                        sock.writeShort(buf.length);
                        sock.writeBytes(buf);
                        sock.flush();
                }

                private function onData(event:ProgressEvent):void
                {
                        trace("SimpleClient.onData(): received [" + event.bytesLoaded + "] bytes");
                        var buf:SgsByteArray=new SgsByteArray();
                        sock.readBytes(buf, 0, sock.bytesAvailable);
                        messageFilter.receive(buf, this);
                }

                public function onRawMessage(e:SgsEvent):void
                {
                        receivedMessage(e.rawMessage);
                }


                /**
                 * This is the heart of the SimpleClient.  The method reads
                 * the incoming data, parses the commands based on the SimpleSgsProtocol byte
                 * and dispatches events
                 *
                 */
                private function receivedMessage(message:SgsByteArray):void
                {
                        var command:int=message.readByte();
                        var e:SgsEvent=null;
                        var buf:ByteArray=new ByteArray();
                        var channel:ClientChannel;

                        if (command == SimpleSgsProtocol.LOGIN_SUCCESS)
                        {
                                //TODO reconnectkey support?
                                message.readBytes(reconnectKey);
                                dispatchEvent(new SgsEvent(SgsEvent.LOGIN_SUCCESS));
                        }

                        else if (command == SimpleSgsProtocol.LOGIN_FAILURE)
                        {
                                e=new SgsEvent(SgsEvent.LOGIN_FAILURE);
                                e.failureMessage=message.readSgsString();
                                dispatchEvent(e);
                        }

                        else if (command == SimpleSgsProtocol.LOGIN_REDIRECT)
                        {
                                var newHost:String=message.readSgsString();
                                var newPort:int=message.readInt();
                                e=new SgsEvent(SgsEvent.LOGIN_REDIRECT);
                                e.host=newHost;
                                e.port=newPort;
                                dispatchEvent(e);
                        }

                        else if (command == SimpleSgsProtocol.RECONNECT_SUCCESS)
                        {
                                //TODO reconnectkey support?
                                reconnectKey=new ByteArray();
                                message.readBytes(reconnectKey);
                                dispatchEvent(new SgsEvent(SgsEvent.RECONNECT_SUCCESS));
                        }


                        else if (command == SimpleSgsProtocol.RECONNECT_FAILURE)
                        {
                                e=new SgsEvent(SgsEvent.RECONNECT_FAILURE);
                                e.failureMessage=message.readSgsString();
                                dispatchEvent(e);
                        }

                        else if (command == SimpleSgsProtocol.SESSION_MESSAGE)
                        {
                                message.readBytes(buf);
                                e=new SgsEvent(SgsEvent.SESSION_MESSAGE);
                                e.sessionMessage=buf;
                                dispatchEvent(e);
                        }
                        else if (command == SimpleSgsProtocol.LOGOUT_SUCCESS)
                        {
                                e=new SgsEvent(SgsEvent.LOGOUT);
                                dispatchEvent(e);
                        }
                        else if (command == SimpleSgsProtocol.CHANNEL_JOIN)
                        {
                                var channelName:String=message.readSgsString();
                                message.readBytes(buf);
                                channel=new ClientChannel(channelName, buf);
                                channels.put(channel.id, channel);
                                e=new SgsEvent(SgsEvent.CHANNEL_JOIN);
                                e.channel=channel;
                                dispatchEvent(e);
                        }
                        else if (command == SimpleSgsProtocol.CHANNEL_MESSAGE)
                        {
                                //Read channelId bytes
                                message.readBytes(buf, 0, message.readUnsignedShort());
                                channel=channels.getValue(ClientChannel.bytesToChannelId(buf));
                                buf=new ByteArray();
                                message.readBytes(buf);
                                e=new SgsEvent(SgsEvent.CHANNEL_MESSAGE);
                                e.channel=channel;
                                e.channelMessage=buf;
                                dispatchEvent(e);
                        }
                        else if (command == SimpleSgsProtocol.CHANNEL_LEAVE)
                        {
                                //Read channelId bytes
                                message.readBytes(buf);
                                channel=channels.getValue(ClientChannel.bytesToChannelId(buf));

                                if (channel != null)
                                {
                                        channels.remove(channel.id);
                                        e=new SgsEvent(SgsEvent.CHANNEL_LEAVE);
                                        e.channel=channel;
                                        dispatchEvent(e);
                                }
                        }
                        else
                        {
                                throw new Error("Undefined protocol command:" + command);
                        }
                }
        }
}
