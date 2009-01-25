/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.realtime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import net.yahoo.fireeagle.FireEagleConfig;
	import net.yahoo.fireeagle.FireEagleEvent;
	import net.yahoo.fireeagle.FireEagleMethod;
	import net.yahoo.fireeagle.IFireEagleSubscribe;
	import net.yahoo.fireeagle.IFireEagleUser;
	
	/**
	 * Dispatched when a <code>user</code> request succeeds.
	 */	
	[Event(name="userSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>user</code> request fails.
	 */	
	[Event(name="userFailure", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>recent</code> request fails.
	 */	
	[Event(name="recentFailure", type="FireEagleEvent")]

	/**
	 * A class for polling the Fire Eagle <code>recent</code>. After receiving recent 
	 * location updates, it gets each user's location and dispatches a <code>FireEagleEvent.USER_SUCCESS</code> 
	 * event for each user.  
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 * @example 
	 * <listing version="3.0">
	 *	var realtime:IFireEagleSubscribe = new RecentPoller(consumerKey, consumerSecret, generalToken, generalSecret);
	 * 
	 *	// Note, no error handling shown
	 *	realtime.addEventListener(FireEagleEvent.USER_SUCCESS, handleUserSuccess);
	 *	realtime.subscribe(userAccessToken, userAccessSecret);
	 *	realtime.start();
	 * 
	 *	function handleUserSuccess(e:FireEagleEvent):void
	 *	{
	 * 		trace("Received user update, user timezone = " + e.data.timezone);
	 *	}
	 * 
	 * </listing>
	 */
	public class RecentPoller extends EventDispatcher implements IFireEagleSubscribe
	{
		/**
		 * @protected
		 */
		protected static const COOKIE_NAME:String = "FireEagleRecentPoller";
		
		/**
		 * @protected
		 */
		protected var _feRecentMethod:FireEagleMethod;
		/**
		 * @protected
		 */
		protected var _feUserMethod:FireEagleMethod;
		/**
		 * @protected
		 */
		protected var _timer:Timer;
		/**
		 * @protected
		 */
		protected var _nextCall:Date;
		/**
		 * @protected
		 */
		protected var _cookie:SharedObject;
		/**
		 * @protected
		 */ 
		protected var _perPage:Number = 100;
		/**
		 * @protected
		 */
		protected var _currentPage:Number = 1;
		
		/**
		 * Class constructor.
		 * Creates a new <code>RecentPoller</code> object for the provided credentials. 
		 * 
		 * @param consumerKey		The OAuth consumer key string to use for this connection.
		 * @param consumerSecret	The OAuth consumer secret string to use for this connection.
		 * @param generalKey		The OAuth general token key string to use for this connection. 
		 * @param generalSecret		The OAuth general token secret string to use for this connection.
		 * @param delayMs			The number of milliseconds between polls, defaults to 30 seconds (30000 ms).
		 * @param format			Either <code>FireEagleConfig.FORMAT_JSON</code> or <code>FireEagleConfig.FORMAT_XML</code> (default), 
		 * 							specifies the API result data type.
		 * 
		 * @return					A new <code>RecentPoller</code> object
		 * 
		 */
		public function RecentPoller(consumerKey:String, consumerSecret:String, 
									generalTokenKey:String, generalTokenSecret:String, 
									delayMs:Number = 30000, format:String = FireEagleConfig.FORMAT_XML)
		{
			super(null);
			
			_feRecentMethod = new FireEagleMethod(consumerKey, consumerSecret, generalTokenKey, generalTokenSecret, format);
			_feRecentMethod.addEventListener(FireEagleEvent.RECENT_SUCCESS, onRecentSuccess);
			_feRecentMethod.addEventListener(FireEagleEvent.RECENT_FAILURE, onForward);
			_feRecentMethod.addEventListener(FireEagleEvent.SECURITY_ERROR, onForward);
			
			_feUserMethod = new FireEagleMethod(consumerKey, consumerSecret, null, null);
			_feUserMethod.addEventListener(FireEagleEvent.USER_SUCCESS, onForward);
			_feUserMethod.addEventListener(FireEagleEvent.USER_FAILURE, onForward);
			_feUserMethod.addEventListener(FireEagleEvent.SECURITY_ERROR, onForward);
			
			_timer = new Timer(delayMs);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			_cookie = SharedObject.getLocal(COOKIE_NAME, "/");
			// TODO: handle when SO creation fails, for now let the exceptions fly
		}
		
		/**
		 * Start polling for subscriber updates.
		 * @return 
		 * 
		 */
		public function start():void
		{
			stop();
			// don't receive any updates that happened before now
			_nextCall = new Date();
			_timer.start();
		}
		
		/**
		 * Stop polling for subscriber updates.
		 * @return 
		 * 
		 */
		public function stop():void
		{
			_timer.stop();
		}
		
		/**
		 * Is polling for update.
		 * @return 		<code>true</code> if polling for updates, <code>false</code> otherwise
		 * 
		 */
		public function get running():Boolean
		{
			return _timer.running;
		}
		
		/**
		 * Subscribe to a user's location updates.
		 * @param tokenKey		User's access token key
		 * @param tokenSecret	User's access token secret
		 * 
		 * @return 
		 * 
		 */
		public function subscribe(tokenKey:String, tokenSecret:String):void
		{
			_cookie.data[tokenKey] = tokenSecret;
			_cookie.flush();
		}
		
		/**
		 * Unsubscribe to a user's location updates.
		 * @param tokenKey		User's access token key
		 * @param tokenSecret	User's access token secret
		 * @return 
		 * 
		 */
		public function unSubscribe(tokenKey:String, tokenSecret:String):void
		{
			delete _cookie.data[tokenKey];
			_cookie.flush();
		}
		
		/**
		 * Hit the <code>recent</code> Fire Eagle method now to receive any user location updates.
		 * Call <code>checkNow</code> before <code>start</code> to force all all recent updates to be
		 * processed.
		 * @return 
		 * 
		 */
		public function checkNow():void
		{
			// build args
			var args:Object = new Object();
			args.per_page = _perPage;
			args.page = _currentPage;
			if (_nextCall != null) {
				args.time = _nextCall.toString();
			}
			// fire the recent method
			_feRecentMethod.recent(args);
		}
		
		/**
		 * Handle timer event to implement poll.
		 * @return 
		 * 
		 */
		protected function onTimer(e:TimerEvent):void
		{
			checkNow();
		}
		
		/**
		 * Handle the <code>FireEagleEvent.RECENT_SUCCESS</code> Fire Eagle method to process which
		 * users have updated location since the last call.
		 * @return 
		 * 
		 */
		protected function onRecentSuccess(e:FireEagleEvent):void
		{
			for each (var u:IFireEagleUser in e.response.users) {
				if (_cookie.data[u.token] != null) {
					_feUserMethod.connection.updateToken(u.token, _cookie.data[u.token]);
					_feUserMethod.user();
				}
				if (u.locatedAt > _nextCall) {
					// server time may be out of sync with our time, adjust by using latest update timestamp
					_nextCall = new Date(u.locatedAt.time + 1000); // add 1 sec to it to avoid getting that same result back next call
					// TODO: remove +1 sec hack once FE is fixed to be time exclusive
				}
			}
			// TODO: implement pagination calls here if we had more than _perPage users
		}
		
		/**
		 * Forward events being listened to dispatch on this.
		 * @return 
		 * 
		 */
		protected function onForward(e:Event):void
		{
			dispatchEvent(e.clone());
		}
		
	}
}

