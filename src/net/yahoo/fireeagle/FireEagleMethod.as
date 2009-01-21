/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{	
	import com.adobe.serialization.json.JSON;
	import com.yahoo.oauth.IOAuthSignatureMethod;
	
	import flash.events.EventDispatcher;
	
	import net.yahoo.fireeagle.oauth.OAuthConnection;
	
	/**
	 * Dispatched when a <code>user</code> request succeeds.
	 */	
	[Event(name="userSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>user</code> request fails.
	 */	
	[Event(name="userFailure", type="FireEagleEvent")]
	
	/**
	 * Dispatched when a <code>lookup</code> request succeeds.
	 */	
	[Event(name="lookupSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>lookup</code> request fails.
	 */	
	[Event(name="lookupFailure", type="FireEagleEvent")]
	
	/**
	 * Dispatched when a <code>update</code> request succeeds.
	 */	
	[Event(name="updateSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>update</code> request fails.
	 */	
	[Event(name="updateFailure", type="FireEagleEvent")]
	
	/**
	 * Dispatched when a <code>recent</code> request succeeds.
	 */	
	[Event(name="recentSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>recent</code> request fails.
	 */	
	[Event(name="recentFailure", type="FireEagleEvent")]
	
	/**
	 * Dispatched when a <code>within</code> request succeeds.
	 */	
	[Event(name="withinSuccess", type="FireEagleEvent")]
	/**
	 * Dispatched when a <code>within</code> request fails.
	 */	
	[Event(name="withinFailure", type="FireEagleEvent")]
	
	/**
	 * Dispatched when a request fails due to a security error.
	 */	
	[Event(name="securityError", type="SecurityErrorEvent")]
	
	/**
	 * A class for sending requests to the Fire Eagle API and receiving aynchronous responses. 
	 * Once constructed with the correct consumer key + secret and either general key + secret 
	 * or access key + secret, any of the Fire Eagle API methods can be invoked, or valid OAuth 
	 * url + args can be generated.
	 * Note, <code>user, update, lookup</code> require access key + token while 
	 * <code>recent, within</code> require a general key + secret. 
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 * @example 
	 * <listing version="3.0">
	 *	var fe:FireEagleMethod = new FireEagleMethod(consumerKey, consumerSecret, accessToken, accessSecret);
	 * 
	 *	// Note, no error handling shown
	 *	fe.addEventListener(FireEagleEvent.USER_SUCCESS, handleUserSuccess);
	 *	fe.user();
	 * 
	 *	function handleUserSuccess(e:FireEagleEvent):void
	 *	{
	 * 		trace("Received user success, user timezone = " + e.data.timezone);
	 *	}
	 * 
	 * </listing>
	 */
	public class FireEagleMethod extends EventDispatcher
	{
		/**
		 * @protected
		 */
		protected var _connection:OAuthConnection;
		/**
		 * @protected
		 */
		protected var _format:String = FireEagleConfig.FORMAT_JSON;
		/**
		 * @protected
		 */
		protected var _fireRequestAutomatically:Boolean = true;
		/**
		 * @protected
		 */
		protected var _parseResult:Boolean = true;
		
		/**
		 * The OAuthConnection being used.  
		 *  
		 * @return 					the OAuthConnection
		 * 
		 */
		public function get connection():OAuthConnection {
			return _connection;
		}
		
		/**
		 * The REST request result data format.  
		 *  
		 * @return 					String specifying the result format, XML or JSON
		 * 
		 */
		public function get format():String {
			return _format;
		}
		
		/**
		 * The url for the method call, including all url args and OAuth args. These are generated following a call
		 * to a <code>FireEagleMethod</code> class method, e.g. <code>user</code>. 
		 *  
		 * @return 					url for the API method call with all url parameters
		 * 
		 */
		public function get url():String {
			return _connection.url;
		}
		
		/**
		 * The set of http POST args for the method call. These are generated following a call
		 * to a <code>FireEagleMethod</code> class method, e.g. <code>update</code>. 
		 *  
		 * @return 					API method POST args
		 * 
		 */
		public function get args():String {
			return _connection.postArgs;
		}
		
		/**
		 * Whether or not to automatically fire API method requests when calling <code>FireEagleMethod</code> class methods. 
		 * E.g. If <code>user</code> is called with <code>fireRequestAutomatically</code> set to false, 
		 * <code>args</code> and <code>url</code> will be setup, but the request will not be fired until 
		 * <code>asyncRequest</code> is called. If true, the request will be fired when <code>user</code> is called.
		 *  
		 * @return 					true to set requests to fire automatically, false to indicate requests are fired manually with <code>asyncRequest</code>
		 * 
		 */
		public function get fireRequestAutomatically():Boolean {
			return _fireRequestAutomatically;
		}
		
		/**
		 * Set whether or not to automatically fire API method requests when calling <code>FireEagleMethod</code> class methods. 
		 * @param v					true to set requests to fire automatically, false to indicate requests are fired manually with <code>asyncRequest</code>
		 *  
		 * @return 
		 * 
		 */
		public function set fireRequestAutomatically(v:Boolean):void {
			_fireRequestAutomatically = v;
		}
		
		/**
		 * Whether or not method result String is parsed (to an XML object or deserialized JSON AS Object depending on <code>format</code>).
		 *  
		 * @return 					true when method results are parsed, false to indicate a String response
		 * 
		 */
		public function get parseResult():Boolean {
			return _parseResult;
		}
		
		/**
		 * Set whether or not to parse the method result String into an XML object or deserialized JSON AS Object.
		 * @param v					true to set the class to parse method results, false to indicate you want a String response
		 *  
		 * @return 
		 * 
		 */
		public function set parseResult(v:Boolean):void {
			_parseResult = v;
		}
		
		/**
		 * Set OAuth signature method implementation. 
		 * @return 
		 * 
		 */
		public function set signatureMethod(v:IOAuthSignatureMethod):void {
			_connection.signatureMethod = v;
		}
		
		/**
		 * Class constructor.
		 * Creates a new <code>FireEagleMethod</code> object for the provided credentials. 
		 * 
		 * @param consumerKey		The OAuth consumer key string to use for this connection.
		 * @param consumerSecret	The OAuth consumer secret string to use for this connection.
		 * @param tokenKey			The OAuth token key string to use for this connection. 
		 * @param tokenSecret		The OAuth token secret string to use for this connection.
		 * @param format			Either <code>FireEagleConfig.FORMAT_JSON</code> (default) or <code>FireEagleConfig.FORMAT_XML</code>, specifies
		 * 							the API result data type.
		 * 
		 * @return					A new <code>FireEagleMethod</code> object
		 * 
		 */
		public function FireEagleMethod(
			consumerKey:String, consumerSecret:String,
			tokenKey:String, tokenSecret:String, 
			format:String = null)
		{	
			_connection = new OAuthConnection(consumerKey, consumerSecret, tokenKey, tokenSecret);
			
			if (format != null) {
				_format = format;
			}
		}
		
		/**
		 * Setup and potentially fire a Fire Eagle <code>user</code> API method call to retreive the current 
		 * location of the user. Requires the FireEagle access token and secret for the user be used as opposed 
		 * to the app's general key and secret.
		 * @return 
		 * 
		 */
		public function user():void
		{
			getRequest(FireEagleConfig.API_SERVER + FireEagleConfig.USER_API_PATH + "." + format, FireEagleConfig.USER_API_METHOD);
		}
		
		/**
		 * Setup and potentially fire a Fire Eagle <code>lookup</code> API method call to disambiguate potential 
		 * values for update query. Results from lookup can be passed to <code>update</code> to ensure that Fire Eagle 
		 * will understand how to parse the Location. Requires the FireEagle access token and secret for the user be used as opposed 
		 * to the app's general key and secret.
		 * Valid args are:
		 * <br>[<tt>(lat, lon)</tt>]                both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
		 * <br>[<tt>woeid</tt>]                     Where on Earth ID
		 * <br>[<tt>place_id</tt>]                  Place ID
		 * <br>[<tt>address</tt>]                   street address (may contain a full address, but will be combined with postal, city, state, and country when available)
		 * <br>[<tt>(mnc, mcc, lac, cellid)</tt>]   cell tower information, all required (as integers) for a valid tower location
		 * <br>[<tt>postal</tt>]                    a ZIP or postal code (combined with address, city, state, and country when available)
		 * <br>[<tt>city</tt>]                      city (combined with address, postal, state, and country when available)
		 * <br>[<tt>state</tt>]                     state (combined with address, postal, city, and country when available)
		 * <br>[<tt>country</tt>]                   country (combined with address, postal, city, and state when available)
		 * <br>[<tt>q</tt>]                         Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
		 *  
		 * @return 
		 * 
		 */
		public function lookup(args:Object):void
		{
			getRequest(FireEagleConfig.API_SERVER + FireEagleConfig.LOOKUP_API_PATH + "." + format, FireEagleConfig.LOOKUP_API_METHOD, args);
		}
		
		/**
		 * Setup and potentially fire a Fire Eagle <code>update</code> API method call to update the current 
		 * location of the user. Requires the Fire Eagle access token and secret for the user be used as opposed 
		 * to the app's general key and secret.
		 * Valid args are:
		 * <br>[<tt>(lat, lon)</tt>]                both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
		 * <br>[<tt>woeid</tt>]                     Where on Earth ID
		 * <br>[<tt>place_id</tt>]                  Place ID
		 * <br>[<tt>address</tt>]                   street address (may contain a full address, but will be combined with postal, city, state, and country when available)
		 * <br>[<tt>(mnc, mcc, lac, cellid)</tt>]   cell tower information, all required (as integers) for a valid tower location
		 * <br>[<tt>postal</tt>]                    a ZIP or postal code (combined with address, city, state, and country when available)
		 * <br>[<tt>city</tt>]                      city (combined with address, postal, state, and country when available)
		 * <br>[<tt>state</tt>]                     state (combined with address, postal, city, and country when available)
		 * <br>[<tt>country</tt>]                   country (combined with address, postal, city, and state when available)
		 * <br>[<tt>q</tt>]                         Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
		 *  
		 * @param args			The name/value pairs to be used as parameters to this method
		 * 
		 */
		public function update(args:Object):void
		{
			postRequest(FireEagleConfig.API_SERVER + FireEagleConfig.UPDATE_API_PATH + "." + format, FireEagleConfig.UPDATE_API_METHOD, args);
		}
		
		/**
		 * Setup and potentially fire a Fire Eagle <code>recent</code> API method call to retreive recent user updates
		 * for the app. Requires the Fire Eagle app's general key and secret be used as opposed to an access 
		 * token and secret (for user methods).
		 * Valid optional args are:
		 * <br>[<tt>time</tt>]   The time to start looking at recent updates from. Value is flexible, supported forms are 'now', 'yesterday', '12:00', '13:00', '1:00pm' and '2008-03-12 12:34:56'. (default: 'now')
		 * <br>[<tt>count</tt>]  Number of users to return per page. (default: 10)
		 * <br>[<tt>start</tt>]  The page number at which to start returning the list of users.
		 *  
		 * @param args			The name/value pairs to be used as parameters to this method
		 * @return 
		 * 
		 */
		public function recent(args:Object):void
		{
			getRequest(FireEagleConfig.API_SERVER + FireEagleConfig.RECENT_API_PATH + "." + format, FireEagleConfig.RECENT_API_METHOD, args);
		}
		
		/**
		 * Setup and potentially fire a Fire Eagle <code>within</code> API method call to retreive the app users within
		 * given location bounds. Requires the Fire Eagle app's general key and secret be used as opposed to an access 
		 * token and secret (for user methods).
		 * Valid args are:
		 * <br>[<tt>(lat, lon)</tt>]                both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
		 * <br>[<tt>woeid</tt>]                     Where on Earth ID
		 * <br>[<tt>place_id</tt>]                  Place ID
		 * <br>[<tt>address</tt>]                   street address (may contain a full address, but will be combined with postal, city, state, and country when available)
		 * <br>[<tt>(mnc, mcc, lac, cellid)</tt>]   cell tower information, all required (as integers) for a valid tower location
		 * <br>[<tt>postal</tt>]                    a ZIP or postal code (combined with address, city, state, and country when available)
		 * <br>[<tt>city</tt>]                      city (combined with address, postal, state, and country when available)
		 * <br>[<tt>state</tt>]                     state (combined with address, postal, city, and country when available)
		 * <br>[<tt>country</tt>]                   country (combined with address, postal, city, and state when available)
		 * <br>[<tt>q</tt>]                         Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
		 *  
		 * @param args			The name/value pairs to be used as parameters to this method
		 * @return 
		 * 
		 */
		public function within(args:Object):void
		{
			getRequest(FireEagleConfig.API_SERVER + FireEagleConfig.WITHIN_API_PATH + "." + format, FireEagleConfig.WITHIN_API_METHOD, args);
		}
		
		/**
		 * Fire a previously setup Fire Eagle API method. To use, <code>fireRequestAutomatically</code> must be set to 
		 * <code>false</code>, then an API class method is called (e.g. <code>user</code>), <code>url</code> and <code>args</code>
		 * can be inspected, then <code>asyncRequest</code> is called. Note, it can only be called once for each method setup
		 * because OAuth signatures can only be used once. 
		 *  
		 * @return 
		 * 
		 */	
		public function asyncRequest():void
		{
			_connection.asyncRequest();
		}
		
		/**
		 * Create a new <code>FireEagleMethod</code> object with the same properties as this one.. 
		 *  
		 * @return 		<code>FireEagleMethod</code>
		 * 
		 */	
		public function clone():FireEagleMethod
		{
			return new FireEagleMethod(
					_connection.consumer.key, 
					_connection.consumer.secret, 
					_connection.token.key, 
					_connection.token.secret, 
					format);
		}
		
		
		//
		// Protected methods
		//
				
		/**
		 * @protected
		 * Setup and potentially fire a http GET request 
		 *  
		 * @param url			The unsigned url sans url params
		 * @param methodName	The <code>FireEagleConfig</code> method name matching this request, used for result event type resolution
		 * @param args			The name/value pairs to be used as parameters to this method
		 * @param success		An optional success callback function
		 * @param failure		An optional failure callback function
		 * @param secruity		An optional security error callback function
		 * @return 
		 * 
		 */	
		protected function getRequest(url:String, methodName:String, args:Object=null, success:Function=null, failure:Function=null, security:Function=null):void
		{
			// TODO: check token ??
			 
			_connection.setupGet(url, makeCallbackObject(methodName, success, failure, security), args);
			
			// make the call
			if (_fireRequestAutomatically) {
				asyncRequest();
			}
		}
		
		/**
		 * @protected
		 * Setup and potentially fire a http POST request 
		 *  
		 * @param url			The unsigned url sans url params
		 * @param methodName	The <code>FireEagleConfig</code> method name matching this request, used for result event type resolution
		 * @param args			The name/value pairs to be used as parameters to this method
		 * @param success		An optional success callback function
		 * @param failure		An optional failure callback function
		 * @param secruity		An optional security error callback function
		 * @return 
		 * 
		 */	
		protected function postRequest(url:String, methodName:String, args:Object=null, success:Function=null, failure:Function=null, security:Function=null):void
		{
			_connection.setupPost(url, makeCallbackObject(methodName, success, failure, security), args);
			
			// make the call
			if (_fireRequestAutomatically) {
				_connection.asyncRequest();
			}
		}
		
		/**
		 * @protected
		 * Returns true if the status code is 200. (AIR-Only)
		 * 
		 * Will also return true if the code is 0 to bypass the browser not providing an http status code. 
		 *  
		 * @param status
		 * @return 
		 * 
		 */	
		protected function getResponseStatusOk(status:int):Boolean
		{
			return (status == 200 || status == 0);
		}
		
		/**
		 * @protected
		 * Returns a callback object with <code>success</code>, <code>failure</code> and <code>security</code> memebers
		 * implemented. If no callback is specified, a FireEagleEvent will be dispatched to this object instead. For <code>success</code>
		 * the callback will check the response and potentially parse it before dispatching a FireEagleEvent or calling the <code>success</code>
		 * callback.
		 * 
		 * @param methodName		Should match a method name from FireEagleConfig method name const
		 * @param success			An optionaly callback to be fired on success
		 * @param failure			An optionaly callback to be fired on failure
		 * @param secrutiy			An optionaly callback to be fired on secrutiy error
		 * @return					An callback Object with all member functions imlepemented 
		 *  
		 */
		protected function makeCallbackObject(methodName:String, success:Function=null, failure:Function=null, security:Function=null):Object
		{
			// save self
			var self:FireEagleMethod = this;
			
			// setup the response callbacks
			var callback:Object = new Object();
			
			callback.failure = (failure != null ? failure :
				function(response:Object):void {
					self.dispatchEvent(new FireEagleEvent(methodName + FireEagleEvent.FAILURE, response));
				}
			);
			
			callback.security = (security != null ? security :
				function(response:Object):void {
					self.dispatchEvent(new FireEagleEvent(FireEagleEvent.SECURITY_ERROR, response));
				}
			);
			
			callback.success = 
				function(response:Object):void 
				{
					var rsp:String = response.responseText;
					var ret:Object = rsp;
					var feResponse:FireEagleResponse = null;
					if (self.getResponseStatusOk(response.status)) 
					{
						if (_parseResult) {
							if (self.format == FireEagleConfig.FORMAT_JSON) 
							{	// parse the JSON, don't parse if format is XML
								var json:Object = null;
								try {
									json = JSON.decode(rsp);
								} catch (error:Error) {
									// some json parse error
									callback.failure(response);
									return;
								}
								if (json.error) {
									// could not parse json
									callback.failure(response);
									return;
								} else {
									// successfully parsed JSON
									ret = json;
									feResponse = new FireEagleResponse(json);
								}
							} else {
								var xml:XML = null;
								try {
									xml = new XML(rsp);
								} catch (error:Error) {
									// some XML parse error
									callback.failure(response);
									return;
								}
								ret = xml;
							}
						}
						
						if (success != null) {
							// call the user's callback
							success(ret);
						} else { 
							// or just dispatch an event
							self.dispatchEvent(new FireEagleEvent(methodName + FireEagleEvent.SUCCESS, ret, feResponse));
						}
					} else {
						// status not "Ok" failure
						callback.failure(response);
					}
				}
			;
			
			return callback;
		}
	}
}
