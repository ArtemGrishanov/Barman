package com.bar.api
{
        public class ServerProtocol
        {
				// client generated messages

                public static const C_LOAD_BAR:int=0x10;

                public static const C_CLIENT_COME:int=0x11;

                public static const C_CLIENT_SERVED:int=0x12;

                public static const C_CLIENT_DENIED:int=0x13;

                public static const C_PRODUCTION_LICENSED:int=0x14;

                public static const C_PRODUCTION_ADDED_TO_BAR:int=0x15;

                public static const C_PRODUCTION_DELETED:int=0x16;

                public static const C_USER_ATTRS_CHANGED:int=0x17;

                public static const C_MONEY_CENT_CHANGED:int=0x18;
                
                public static const C_DECOR_ADDED_TO_BAR:int=0x19;

                public static const C_DECOR_DELETED:int=0x20;

                public static const C_INVITE_FRIEND:int=0x21;

                public static const C_LOAD_FRIENDS:int=0x22;
                
                public static const C_LOAD_TOP:int=0x23;
                
                public static const C_LOAD_BAR_CATALOG:int=0x24;
                
                public static const C_VK_ATTRS:int=0x25;
                
                public static const C_MONEY_EURO_CHANGED:int=0x26;
                
                public static const C_RESET_GAME:int=0x27;
                
                public static const C_PRODUCTION_CHANGE_PARTS:int=0x28;
                
                public static const C_PRODUCTION_CHANGE_PLACE:int=0x29;
                
                // server generated messages
                
                public static const S_FIRST_LAUNCH:int=0x50;
                
                public static const S_ERROR:int=0x51;
                
                public static const S_MESSAGE_BOX:int=0x52;
                
                public static const S_NEWS_LOADED:int=0x53;
                
                public static const S_LEVEL_CHANGED:int=0x54;
                
                public static const S_EXP_CHANGED:int=0x55;
                
                public static const S_LOVE_CHANGED:int=0x56;
                
                public static const S_MONEY_CENT_CHANGED:int=0x57;
                
                public static const S_MONEY_EURO_CHANGED:int=0x58;
                
                public static const S_TOP_LOADED:int=0x59;
                
                public static const S_FRIENDS_LOADED:int=0x60;
                
                public static const S_BAR_CATALOG_LOADED:int=0x61;
                
                public static const S_BAR_LOADED:int=0x62;
        }
}

