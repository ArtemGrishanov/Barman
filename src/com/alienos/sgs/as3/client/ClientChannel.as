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
        import flash.utils.ByteArray;

        public class ClientChannel
        {
                private var _name:String;
                private var _id:Number;
                private var _rawId:ByteArray;

                /**
                 *  Stores details about the client channel.
                 */
                public function ClientChannel(name:String, rawId:ByteArray)
                {
                        _name=name;
                        _rawId=rawId;
                        _rawId.position=0;
                        _id=bytesToChannelId(_rawId);
                }

                public function get name():String
                {
                        return _name;
                }

                public function get id():Number
                {
                        return _id;
                }

                public function get rawId():ByteArray
                {
                        return _rawId;
                }

                //This could very well overflow Number's ability to store values
                //not sure what to do here.  Why does the channel id have to potentially
                //be so huge? *boggle*
                public static function bytesToChannelId(buf:ByteArray):Number
                {
                        var rslt:Number=0;
                        var shift:Number=(buf.bytesAvailable - 1) * 8;
                        for (var x:int=0; x <= buf.bytesAvailable; x++)
                        {
                                var bv:int=buf.readByte();
                                rslt+=(bv & 255) << shift;
                                shift-=8;
                        }
                        return rslt;
                }
        }
}
