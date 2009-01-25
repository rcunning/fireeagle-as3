/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.realtime
{
	import flash.events.Event;
	
	/**
	 * Event class for Fire Eagle xmpp event on <code>XMPPConnection</code>.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class RealTimeEvent extends Event
	{
		/**
		 * Constant defining the name of the event fired when the XMPP session has been established successfully.
		 * @see XMPPConnection
		 */
		public static const XMPP_SESSION:String = "xmppSession";
		/**
		 * Constant defining the name of the event fired when a secure XMPP connection is established.
		 * @see XMPPConnection
		 */
		public static const XMPP_SECURE:String = "xmppSecure";
		/**
		 * Constant defining the name of the event fired when XMPP authorization has succeeded.
		 * @see XMPPConnection
		 */
		public static const XMPP_AUTH_SUCCESS:String = "xmppAuthSuccess";
		/**
		 * Constant defining the name of the event fired when XMPP authorization has failed.
		 * @see XMPPConnection
		 */
		public static const XMPP_AUTH_FAIL:String = "xmppAuthFail";
		/**
		 * Constant defining the name of the event fired when the XMPP socket has been connected.
		 * @see XMPPConnection
		 */
		public static const XMPP_CONNECT:String = "xmppConnect";
		/**
		 * Constant defining the name of the event fired when the XMPP socket has been disconnected.
		 * @see XMPPConnection
		 */
		public static const XMPP_DISCONNECT:String = "xmppDisconnect";
		/**
		 * Constant defining the name of the event fired when the XMPP socket connection has failed.
		 * @see XMPPConnection
		 */
		public static const XMPP_CONNECT_FAIL:String = "xmppConnectFail";
		
		/**
		 * Creates a new <code>RealTimeEvent</code> object.
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function RealTimeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
