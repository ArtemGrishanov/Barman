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

        import flash.events.Event;
        import flash.utils.ByteArray;

        public class SgsEvent extends Event
        {
                public static const LOGIN_SUCCESS:String="loginSuccess";
                public static const LOGIN_FAILURE:String="loginFailure";
                public static const LOGIN_REDIRECT:String="loginRedirect";
                public static const RECONNECT_SUCCESS:String="reconnectSuccess";
                public static const RECONNECT_FAILURE:String="reconnectFailure";
                public static const SESSION_MESSAGE:String="sessionMessage";
                public static const LOGOUT:String="logout";
                public static const CHANNEL_JOIN:String="channelJoin";
                public static const CHANNEL_MESSAGE:String="channelMessage";
                public static const CHANNEL_LEAVE:String="channelLeave";
                public static const RAW_MESSAGE:String="rawMessage";

                public var failureMessage:String;
                public var sessionMessage:ByteArray;
                public var channelMessage:ByteArray;
                public var rawMessage:SgsByteArray;
                public var channel:ClientChannel;
                public var host:String;
                public var port:int;

                public function SgsEvent(type:String)
                {
                        super(type);
                }
        }
}
