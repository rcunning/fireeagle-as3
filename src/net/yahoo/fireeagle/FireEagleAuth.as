/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import flash.net.URLVariables;
	
	/**
	 * Dispatched when a <code>newRequestToken</code> request succeeds.
	 */	
	[Event(name="requestTokenSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>newRequestToken</code> request fails.
	 */	
	[Event(name="requestTokenFailure", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>convertToAccessToken</code> request succeeds.
	 */	
	[Event(name="accessTokenSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>convertToAccessToken</code> request fails.
	 */	
	[Event(name="accessTokenFailure", type="FireEagleEvent")]
	
	/**
	 * A utility class for working with Fire Eagle API authorization:
	 * <ul>
	 * <li>getting a new request token (<code>newRequestToken</code>)
	 * <li>getting auth url (either <code>getMobileAuthorizationUrl</code>, <code>authorizationUrl</code>)
	 * <li>or converting that request token to an access token (<code>convertToAccessToken</code>)
	 * </ul>
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 * @example 
	 * <listing version="3.0">
	 *	var fea:FireEagleAuth = new FireEagleAuth(consumerKey, consumerSecret);
	 * 
	 *	// Note, no error handling shown
	 *	fea.addEventListener(FireEagleEvent.REQUEST_TOKEN_SUCCESS, handleNewRequestTokenSuccess);
	 *	fea.newRequestToken();
	 *	
	 *	function handleNewRequestTokenSuccess(e:FireEagleEvent):void
	 *	{
	 *		trace("Received new request token");
	 *		// prompt user for app authorization using fea.authorizationUrl
	 *	}
	 *	
	 *	function onUserDoneAuthorizingApp():void
	 *	{
	 *		fea.addEventListener(FireEagleEvent.ACCESS_TOKEN_SUCCESS, handleConvertAccessTokenSuccess);
	 *		fea.convertToAccessToken();
	 *	}
	 *	
	 *	function handleConvertAccessTokenSuccess(e:FireEagleEvent):void
	 *	{
	 *		// use new fea.accessKey and fea.accessSecret to update user's location
	 *		var fe:FireEagleMethod = new FireEagleMethod(consumerKey, consumerSecret, fea.accessKey, fea.accessSecret);
	 *		fa.update({postal:"94107"});
	 *	}
	 * 
	 * </listing>
	 */	
	public class FireEagleAuth extends FireEagleMethod
	{
		/**
		 * @protected
		 */
		protected static const OAUTH_TOKEN_PARAM:String = "oauth_token";
		/**
		 * @protected
		 */
		protected static const OAUTH_TOKEN_SECRET_PARAM:String = "oauth_token_secret";
		 
		/**
		 * @protected
		 */
		protected var _requestKey:String;
		/**
		 * @protected
		 */
		protected var _requestSecret:String;
		/**
		 * @protected
		 */
		protected var _accessKey:String;
		/**
		 * @protected
		 */
		protected var _accessSecret:String;
		
		/**
		 * Class constructor.
		 * Creates a new FireEagleAuth object for the provided credentials. 
		 * 
		 * @param consumerKey		The OAuth consumer key string to use for this connection.
		 * @param consumerSecret	The OAuth consumer secret string to use for this connection.
		 * 
		 */
		public function FireEagleAuth(consumerKey:String, consumerSecret:String)
		{
			super(consumerKey, consumerSecret, null, null);
			parseResult = false; // we will parse our own results
			// add our event listeners
			addEventListener(FireEagleEvent.REQUEST_TOKEN_SUCCESS, requestTokenSuccess);
			addEventListener(FireEagleEvent.ACCESS_TOKEN_SUCCESS, accessTokenSuccess);
		}
		
		/**
		 * Gets a new request token from the auth server. Success or failure returns asynchronously 
		 * via <code>FireEagleEvent</code>.
		 * @return
		 * 
		 */
		public function newRequestToken():void
		{	// uses consumer to generate a new request token
			_connection.updateToken();
			getRequest(FireEagleConfig.AUTH_SERVER + FireEagleConfig.REQUEST_TOKEN_PATH, FireEagleConfig.REQUEST_TOKEN_NAME);
		}
		
		/**
		 * Gets a mobile authorization url for the <code>appId</code> app
		 * @param appId				The application id of the application you wish the user to authorize
		 * @return 					The url for the user to hit to authorize the app usage
		 * 
		 */
		public function getMobileAuthorizationUrl(appId:String):String
		{
			return FireEagleConfig.AUTH_SERVER + FireEagleConfig.MOBILE_AUTH_PATH + appId;
		}
		
		/**
		 * Gets a authorization url for the current request key. <code>newRequestToken</code> must be called 
		 * and had a successful result event prior to calling.
		 * @return 					The url for the user to hit to authorize the app usage
		 * 
		 */
		public function get authorizationUrl():String
		{
			return FireEagleConfig.AUTH_SERVER + FireEagleConfig.AUTHORIZATION_PATH + '?' + OAUTH_TOKEN_PARAM + '=' + encodeURIComponent(_requestKey);
		}
		
		/**
		 * Gets the request key from the result of a call to <code>newRequestToken</code>.
		 * @return 					The request key
		 * 
		 */
		public function get requestKey():String
		{
			return _requestKey;
		}
		
		/**
		 * Gets the request secret from the result of a call to <code>newRequestToken</code>.
		 * @return 					The request secret
		 * 
		 */
		public function get requestSecret():String
		{
			return _requestSecret;
		}
		
		/**
		 * Converts the currect request key + secret to an access key + secret. The user must have authorized the 
		 * application using one of the authorization urls. Success or failure returns asynchronously 
		 * via <code>FireEagleEvent</code>.
		 * @return
		 * 
		 */
		public function convertToAccessToken():void
		{	// uses consumer to generate call convert
			_connection.updateToken(_requestKey, _requestSecret);
			getRequest(FireEagleConfig.AUTH_SERVER + FireEagleConfig.ACCESS_TOKEN_PATH, FireEagleConfig.ACCESS_TOKEN_NAME);	
		}
		
		/**
		 * Gets the access key from the result of a call to <code>convertToAccessToken</code>.
		 * @return 					The access key
		 * 
		 */
		public function get accessKey():String
		{
			return _accessKey;
		}
		
		/**
		 * Gets the access secret from the result of a call to <code>convertToAccessToken</code>.
		 * @return 					The access secret
		 * 
		 */
		public function get accessSecret():String
		{
			return _accessSecret;
		}
		
		//
		// Protected
		//
		
		/**
		 * @protected
		 */
		protected function requestTokenSuccess(e:FireEagleEvent):void 
		{	// parse and save results
			var u:URLVariables = new URLVariables(e.data.toString());
			_requestKey = u[OAUTH_TOKEN_PARAM];
			_requestSecret = u[OAUTH_TOKEN_SECRET_PARAM]; 
		}
		
		/**
		 * @protected
		 */
		protected function accessTokenSuccess(e:FireEagleEvent):void 
		{	// parse and save results
			var u:URLVariables = new URLVariables(e.data.toString());
			_accessKey = u[OAUTH_TOKEN_PARAM];
			_accessSecret = u[OAUTH_TOKEN_SECRET_PARAM]; 
		}
	}
}
