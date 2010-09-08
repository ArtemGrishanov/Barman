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

package com.alienos.sgs.as3.protocol
{

        public class SimpleSgsProtocol
        {
                public static const MAX_MESSAGE_LENGTH:int=65535;

                public static const MAX_PAYLOAD_LENGTH:int=65532;

                public static const VERSION:int=0x04;

                public static const LOGIN_REQUEST:int=0x10;

                public static const LOGIN_SUCCESS:int=0x11;

                public static const LOGIN_FAILURE:int=0x12;

                public static const LOGIN_REDIRECT:int=0x13;

                public static const RECONNECT_REQUEST:int=0x20;

                public static const RECONNECT_SUCCESS:int=0x21;

                public static const RECONNECT_FAILURE:int=0x22;

                public static const SESSION_MESSAGE:int=0x30;

                public static const LOGOUT_REQUEST:int=0x40;

                public static const LOGOUT_SUCCESS:int=0x41;

                public static const CHANNEL_JOIN:int=0x50;

                public static const CHANNEL_LEAVE:int=0x51;

                public static const CHANNEL_MESSAGE:int=0x52;
        }
}

