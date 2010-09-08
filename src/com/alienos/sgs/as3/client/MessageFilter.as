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
        import com.alienos.sgs.as3.util.SgsByteArray;

        import flash.events.EventDispatcher;

        public class MessageFilter extends EventDispatcher
        {
                private var messageBuffer:SgsByteArray;

                public function MessageFilter()
                {
                        messageBuffer=new SgsByteArray();
                }

                public function receive(buf:SgsByteArray, client:SimpleClient):void
                {
                        //Stuff any new bytes into the buffer
                        messageBuffer.writeBytes(buf, 0, buf.length);
                        messageBuffer.position=0;

                        while (messageBuffer.bytesAvailable > 2)
                        {
                                var payloadLength:int=messageBuffer.readShort();

                                if (messageBuffer.bytesAvailable >= payloadLength)
                                {
                                        var newMessage:SgsByteArray=new SgsByteArray();
                                        messageBuffer.readBytes(newMessage, 0, payloadLength);
                                        var event:SgsEvent=new SgsEvent(SgsEvent.RAW_MESSAGE);
                                        event.rawMessage=newMessage;
                                        dispatchEvent(event);
                                }
                                else
                                {
                                        //Roll back the length we read
                                        messageBuffer.position-=2;
                                        break;
                                }
                        }

                        var newBuffer:SgsByteArray=new SgsByteArray();
                        newBuffer.writeBytes(messageBuffer, messageBuffer.position, messageBuffer.bytesAvailable);
                        messageBuffer=newBuffer;
                }
        }
}
