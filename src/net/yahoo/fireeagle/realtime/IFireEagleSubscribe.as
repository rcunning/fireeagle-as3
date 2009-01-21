/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.realtime
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatched when a <code>user</code> location update is received.
	 */	
	[Event(name="userSuccess", type="FireEagleEvent")]
	
	/**
	 * An interface for listening to user location updates. 
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public interface IFireEagleSubscribe extends IEventDispatcher
	{
		/**
		 * Start listening for subscriber updates.
		 * @return 
		 * 
		 */
		function start():void;
		
		/**
		 * Stop listening for subscriber updates.
		 * @return 
		 * 
		 */
		function stop():void;
		
		/**
		 * Is listening for update.
		 * @return 		<code>true</code> if listening for updates, <code>false</code> otherwise
		 * 
		 */
		function get running():Boolean;
		
		/**
		 * Subscribe to a user's location updates.
		 * @param tokenKey		User's access token key
		 * @param tokenSecret	User's access token secret
		 * 
		 * @return 
		 * 
		 */
		function subscribe(tokenKey:String, tokenSecret:String):void;
		
		/**
		 * Unsubscribe to a user's location updates.
		 * @param tokenKey		User's access token key
		 * 
		 * @return 
		 * 
		 */
		function unSubscribe(tokenKey:String):void;
		
	}
}
