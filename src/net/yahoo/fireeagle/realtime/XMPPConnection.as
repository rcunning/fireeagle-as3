/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.realtime
{
	import com.hurlant.crypto.tls.TLSEvent;
	import com.hurlant.crypto.tls.TLSConfig;
	import com.hurlant.crypto.tls.TLSEngine;
	import com.hurlant.crypto.tls.TLSSocket;
	import com.seesmic.twhix.StreamEvent;
	import com.seesmic.twhix.XMPP;
	import com.seesmic.twhix.XMPPEvent;
	import com.seesmic.twhix.xep.publish_subscribe.PubSubEvent;
	import com.seesmic.twhix.xep.publish_subscribe.PublishSubscribe;
	
	import flash.events.EventDispatcher;
	
	import net.yahoo.fireeagle.FireEagleEvent;
	import net.yahoo.fireeagle.IFireEagleSubscribe;
	import net.yahoo.fireeagle.data.XMLResponse;
	
	/**
	 * Dispatched when a user location update has been received.
	 */	
	[Event(name="userSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when when the XMPP session has been established successfully.
	 */	
	[Event(name="xmppSession", type="RealTimeEvent")]
	/**
	 * Dispatched when a secure XMPP connection is established.
	 */	
	[Event(name="xmppSecure", type="RealTimeEvent")]
	/**
	 * Dispatched when XMPP authorization has succeeded.
	 */	
	[Event(name="xmppAuthSuccess", type="RealTimeEvent")]
	/**
	 * Dispatched when XMPP authorization has failed..
	 */	
	[Event(name="xmppAuthFail", type="RealTimeEvent")]
	/**
	 * Dispatched when the XMPP socket has been connected.
	 */	
	[Event(name="xmppConnect", type="RealTimeEvent")]
	/**
	 * Dispatched when the XMPP socket has been disconnected.
	 */	
	[Event(name="xmppDisconnect", type="RealTimeEvent")]
	/**
	 * Dispatched when the XMPP socket connection has failed.
	 */	
	[Event(name="xmppConnectFail", type="RealTimeEvent")]
	
	/**
	 * A class for connecting to an XMPP server to subscribe and listen for the Fire Eagle user location updates. 
	 * A <code>FireEagleEvent.USER_SUCCESS</code> is dispatched for each subscribed user location update.
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 * @example 
	 * <listing version="3.0">
	 *	var realtime:IFireEagleSubscribe = new XMPPConnection("soandso@jabber.org", "password", null, consumerKey, consumerSecret);
	 * 
	 *	// Note, no error handling shown
	 *	realtime.addEventListener(FireEagleEvent.USER_SUCCESS, handleUserSuccess);
	 *	realtime.start();
	 * 
	 *	function handleUserSuccess(e:FireEagleEvent):void
	 *	{
	 * 		trace("Received user update, user timezone = " + e.data.timezone);
	 *	}
	 * 
	 * </listing>
	 */
	public class XMPPConnection extends EventDispatcher implements IFireEagleSubscribe
	{
		/**
		 * @protected
		 */
		protected var _consumerKey:String;
		/**
		 * @protected
		 */
		protected var _consumerSecret:String;
		/**
		 * @protected
		 */
		protected var _connection:XMPP;
		
		/**
		 * Class constructor.
		 * Creates a new <code>XMPPConnection</code> object for the provided credentials. 
		 * 
		 * @param jid				The jid to use for XMPP connection, may include the @server.
		 * @param password			The password to use for XMPP connection.
		 * @param server			The server to use for XMPP connection, optional.
		 * @param consumerKey		The OAuth consumer key string to use for subscribe/unSubscribe, optional. (NOT USED)
		 * @param consumerSecret	The OAuth consumer secret string to use for subscribe/unSubscribe, optional. (NOT USED)
		 * 
		 * @return					A new <code>XMPPConnection</code> object
		 * 
		 */
		public function XMPPConnection(jid:String, password:String, server:String=null, consumerKey:String=null, consumerSecret:String=null)
		{
			super(null);
			_consumerKey = consumerKey;
			_consumerSecret = consumerSecret;
			_connection = new XMPP();
			// required to call setServer before .socket is created...yuck
			_connection.setJID(jid).setPassword(password).setServer(server);
			
			_connection.addEventListener(XMPPEvent.SESSION, onSession);
			_connection.addEventListener(XMPPEvent.SECURE, onSecure);
			_connection.addEventListener(XMPPEvent.AUTH_SUCCEEDED, onAuthSucceeded);
			_connection.addEventListener(XMPPEvent.AUTH_FAILED, onAuthFailed);
			_connection.socket.addEventListener(StreamEvent.DISCONNECTED, onDisconnected);
			_connection.socket.addEventListener(StreamEvent.CONNECT_FAILED, onConnectFailed);
			_connection.socket.addEventListener(StreamEvent.CONNECTED, onConnected);
			
			_connection.addPlugin(new PublishSubscribe());
			
			_connection.plugin['pubsub'].addEventListener(PubSubEvent.ITEM, onPubSubItem);
			
			// This is weird, pass in the tlc classes so twhix does not have to depend on them (directly)
			_connection.setupTLS(TLSEvent, TLSConfig, TLSEngine, TLSSocket);
		}
		
		/**
		 * Connect to the xmpp server.
		 * @return 
		 * 
		 */
		public function start():void
		{
			_connection.connect();
		}
		
		/**
		 * Disconnect from the xmpp server.
		 * @return 
		 * 
		 */
		public function stop():void
		{
			_connection.disconnect();
		}
		
		/**
		 * Is connected.
		 * @return 		<code>true</code> if connected, <code>false</code> otherwise
		 * 
		 */
		public function get running():Boolean
		{
			return _connection.state['connected'];
		}
		
		/**
		 * Subscribe to a user's location updates. (NOT IMPLEMENTED)
		 * @param tokenKey		User's access token key
		 * @param tokenSecret	User's access token secret
		 * 
		 * @return 
		 * 
		 */
		public function subscribe(tokenKey:String, tokenSecret:String):void
		{
			// TODO: implement oauth + stanza subscribe, no impl in twhix yet
		}
		
		/**
		 * Unsubscribe to a user's location updates. (NOT IMPLEMENTED)
		 * @param tokenKey		User's access token key
		 * @param tokenSecret	User's access token secret
		 * @return 
		 * 
		 */
		public function unSubscribe(tokenKey:String, tokenSecret:String):void
		{
			// TODO: implement oauth + stanza unsubscribe, no impl in twhix yet
		}
		
		/**
		 * Handle the XMPP pubsub event to, parse and convert it to a <code>FireEagleEvent.USER_SUCCESS</code> event.
		 * @return 
		 * 
		 */
		protected function onPubSubItem(e:PubSubEvent):void
		{
			// hack out the namespaces to make it more friendly..this is not all that pretty
			var xmlString:String = e.stanza.xml.toString();
			xmlString = xmlString.replace(/\n/g, ""); // remove newlines so match will work
			var a:Array = xmlString.match(/<rsp.*<\/rsp>/g);
			var rsp:XML= new XML(a.length > 0 ? a[0] : ""); // parse back to XML
			
			// dispatch it like it was just a /user response
			dispatchEvent(new FireEagleEvent(FireEagleEvent.USER_SUCCESS, rsp, new XMLResponse(rsp)));
		}
		
		/**
		 * Handle XMPP session event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onSession(e:XMPPEvent):void
		{
			_connection.sendPresence();
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_SESSION));
		}
		
		/**
		 * Handle XMPP secure event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onSecure(e:XMPPEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_SECURE));
		}
		
		/**
		 * Handle XMPP auth success event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onAuthSucceeded(e:XMPPEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_AUTH_SUCCESS));
		}
		
		/**
		 * Handle XMPP auth fail event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onAuthFailed(e:XMPPEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_AUTH_FAIL));
		}
		
		/**
		 * Handle XMPP disconnect event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onDisconnected(e:StreamEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_DISCONNECT));
		}
		
		/**
		 * Handle XMPP connect event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onConnected(e:StreamEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_CONNECT));
		}
		
		/**
		 * Handle XMPP connection fail event and forward as our typed event.
		 * @return 
		 * 
		 */
		protected function onConnectFailed(e:StreamEvent):void
		{
			dispatchEvent(new RealTimeEvent(RealTimeEvent.XMPP_CONNECT_FAIL));
		}
	}
}
