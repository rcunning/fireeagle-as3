/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import com.yahoo.net.Connection;
	import com.yahoo.oauth.IOAuthSignatureMethod;
	import com.yahoo.oauth.OAuthConsumer;
	import com.yahoo.oauth.OAuthRequest;
	import com.yahoo.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import com.yahoo.oauth.OAuthToken;
	
	import flash.net.URLRequestMethod;

	/**
	 * A utility class that is used to create and handle basic OAuth HTTP requests in Flash and AIR.
	 * It uses the OAuth lib and Connection from the 
	 * <a href="http://developer.yahoo.com/flash/yos/">Y!OS AS3 library</a>
	 * 
	 * <p>
	 * Available callback functions are:
	 * <p>
	 * <ul> 
	 * <li><code>security</code></li> 
	 * <li><code>open</code></li>
	 * <li><code>progress</code></li>
	 * <li><code>failure</code></li>
	 * <li><code>success</code></li>
	 * <li><code>httpStatus</code> (Adobe AIR only)</li>
	 * </ul>
	 * </p>
	 * </p>
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 * @example 
	 * <listing version="3.0">
	 *	var args:Object = new Object();
	 *	args.foo = "bar";
	 *	args.format = "xml";
	 * 
	 *	var callback:Object = new Object();
	 *	callback.success = handleSuccess;
	 *	callback.failure = handleFailure;
	 * 
	 *	var connection:OAuthConnection = new OAuthConnection(consumerKey, consumerSecret, accessKey, accessSecret);
	 * 
	 *	connection.setupGet("http://example.com/some_feed.xml", callback, args);
	 * 
	 *	connection.asyncRequest();
	 * 
	 *	function handleSuccess(response:Object):void
	 *	{
	 *		trace(response.responseText);
	 *		var xml:XML = response.responseXML; // grab the parsed xml object.
	 *	}
	 * 
	 *	function handleFailure(response:Object):void
	 *	{
	 *		trace(response.responseText);
	 *	}
	 * </listing>
	 * 
	 * @see com.yahoo.net.Connection
	 */	
	public class OAuthConnection
	{
		/**
		 * @protected
		 */
		protected var _consumer:OAuthConsumer;
		/**
		 * @protected
		 */
		protected var _token:OAuthToken;
		/**
		 * @protected
		 */
		protected var _url:String = "";
		/**
		 * @protected
		 */
		protected var _args:String = "";
		/**
		 * @protected
		 */
		protected var _callback:Object;
		/**
		 * @protected
		 */
		protected var _httpMethod:String = "";
		
		
		/**
		 * Returns the <code>OAuthConsumer</code> for this connection. 
		 * @return 
		 * 
		 */
		public function get consumer():OAuthConsumer {
			return _consumer;
		}
		/**
		 * Returns the <code>OAuthToken</code> for this connection. 
		 * @return 
		 * 
		 */
		public function get token():OAuthToken {
			return _token;
		}
		/**
		 * Returns the signed and encoded url for this connection. 
		 * Valid after a call to <code>setupGet</code> or <code>setupPost</code>.
		 * @return 
		 * 
		 */
		public function get url():String {
			return _url;
		}
		/**
		 * Returns the encoded POST vars for this connection. 
		 * Valid after a call to <code>setupGet</code> or <code>setupPost</code>.
		 * @return 
		 * 
		 */
		public function get args():String {
			return _args;
		}
		/**
		 * Returns the callback object for this connection. 
		 * @return 
		 * 
		 */
		public function get callback():Object {
			return _callback;
		}
		
		/**
		 * Class constructor.
		 * Creates a new OAuthConnection object for the provided credentials. 
		 * 
		 * @param consumerKey		The OAuth consumer key string to use for this connection.
		 * @param consumerSecret	The OAuth consumer secret string to use for this connection.
		 * @param oauthKey			An OAuth general or access key string to use for this connection, optional.
		 * @param oauthSecret		An OAuth general or access secret string to use for this connection, optional.
		 * 
		 * @throws Error Throws an <code>Error</code> if the consumer key or secret is empty.
		 * 
		 */
		public function OAuthConnection(consumerKey:String, consumerSecret:String, oauthKey:String = null, oauthSecret:String = null)
		{
			if (consumerKey != null && consumerKey.length && consumerSecret != null && consumerSecret.length) {
				_consumer = new OAuthConsumer(consumerKey, consumerSecret);
			} else {
				throw new Error("OAuth consumerKey and comsumerSecret required");
			}
			
			if (oauthKey != null && oauthKey.length && oauthSecret != null && oauthSecret.length) {
				_token = new OAuthToken(oauthKey, oauthSecret);
			}
		}
		
		/**
		 * Swaps out the OAuthToken for this connection using the credentials passed in.
		 * If no credentials are passed in, clears the OAuthToken for this connection. 
		 * 
		 * @param oauthKey			An OAuth general or access key string to use for this connection, optional.
		 * @param oauthSecret		An OAuth general or access secret string to use for this connection, optional.
		 * 
		 */
		public function updateToken(oauthKey:String = null, oauthSecret:String = null):void
		{
			if (oauthKey != null && oauthKey.length && oauthSecret != null && oauthSecret.length) {
				_token = new OAuthToken(oauthKey, oauthSecret);
			} else {
				_token = null;
			}
		}
		
		/**
		 * Sets up a HTTP GET request method, url and arg for a signed OAuth request. Call this before accessing
		 * <code>url</code> or <code>args</code>.  
		 * 
		 * @param url			The base url without url parameters to use for this request.
		 * @param callback		The callback object for this request.
		 * @param args			The arguments for this request, as name/value pairs.
		 * 
		 */
		public function setupGet(url:String, callback:Object, args:Object=null):void
		{			
			_httpMethod = URLRequestMethod.GET;
			// get the OAuth args
			var url_args:* = signRequest(_httpMethod, url, encodeVars(args));			
			// format the request url
			_url = url + '?' + makeUrlParams(url_args);
			_args = "";
			_callback = callback;
		}
		
		/**
		 * Sets up a HTTP POST request method, url and arg for a signed OAuth request. Call this before accessing
		 * <code>url</code> or <code>args</code>.  
		 * 
		 * @param url			The base url without url parameters to use for this request.
		 * @param callback		The callback object for this request.
		 * @param args			The arguments for this request, as name/value pairs.
		 * 
		 */
		public function setupPost(url:String, callback:Object, args:Object=null):void
		{
			_httpMethod = URLRequestMethod.POST;
			// get the OAuth args
			var url_args:* = signRequest(_httpMethod, url, encodeVars(args));
			// save the url and post args
			_url = url + '?' + makeUrlParams(filterOAuthParams(url_args, true));
			_args = makeUrlParams(filterOAuthParams(url_args, false));
			_callback = callback;
		}
		
		/**
		 * Sends the HTTP request previously set up with a call to <code>setupGet</code> or <code>setupPost</code>.
		 */
		public function asyncRequest():void
		{
			Connection.asyncRequest(_httpMethod, _url, _callback, _args);
		}
		
		//
		// Protected methods
		//
		
		/**
		 * Signs the request using the method, url, args, OAuthConsumer and OAuthToken. 
		 * 
		 * @param httpMethod		"GET" or "POST": <code>URLRequestMethod.GET</code>, <code>URLRequestMethod.POST</code>. 
		 * @param url				The base url without url parameters to use for this request.
		 * @param args				The arguments for this request, as name/value pairs.
		 * @param requestType		A request type that determines what OAuth signature is returned.
		 * @return					An object whose type is determined by the <code>requestType</code>. 
		 * 
		 * @see com.yahoo.oauth.OAuthRequest
		 * @throws Error Throws an Error if the request cannot be signed.
		 */	
		protected function signRequest(httpMethod:String, url:String, args:Object=null, requestType:String="OAUTH_REQUEST_TYPE_OBJECT"/*OAuthRequest.OAUTH_REQUEST_TYPE_OBJECT*/):*
		{
			// setup OAuth
			var request:OAuthRequest = new OAuthRequest(httpMethod, url, args, consumer, token);
			var signatureMethod:IOAuthSignatureMethod = new OAuthSignatureMethod_HMAC_SHA1();
			
			// sign the request, returning an Object containing all key, value pairs (oauth params not uri encoded)
			var oauth_args:* = request.buildRequest(signatureMethod, requestType);
			
			return oauth_args;
		}
		
		/**
		 * URI encodes the <code>args</code> keys and properties. 
		 * 
		 * @param args				Name/value pairs to be encoded. 
		 * @return					Encoded name/value pairs. 
		 * 
		 * @see encodeURIComponent
		 */
		protected static function encodeVars(args:Object):Object
		{
			var encoded:Object = new Object();
			for (var key:String in args) {
				encoded[encodeURIComponent(key)] = encodeURIComponent(args[key]);
			}
			return encoded;
		}
		
		/**
		 * Filters out either the non-OAuth properties of <code>args</code>, or the OAuth properties. 
		 * 
		 * @param args				Name/value pairs to be filtered.
		 * @param oAuth				Boolean if true returns the OAuth name/value pairs only, false all others.  
		 * @return					Depending on the oAuth param either returns the OAuth name/value pairs or all others. 
		 * 
		 */
		protected static function filterOAuthParams(args:Object, returnOAuthParams:Boolean):Object
		{
			var params:Object = new Object();
			for (var key:String in args) {
				// want XOR
				var isOAuthParam:Boolean = key.substring(0,6) == 'oauth_';
				if ((returnOAuthParams && isOAuthParam) || (!returnOAuthParams && !isOAuthParam)) {
					params[key] = args[key];
				}
			}
			return params;
		}
		
		/**
		 * Converts name/value pair <code>args</code> to a <code>String</code> ready to append as url parameters. 
		 * 
		 * @param args				Name/value pairs to be converted to url param string. 
		 * @return					The url parameter string without a '?'. 
		 * 
		 */
		protected static function makeUrlParams(args:Object):String
		{
			var params:Array = new Array();
			for (var key:String in args) {
				// OAuth lib did not encode the oauth params (need for '+' and '/' in oath nonce and sig), but don't double-encode our params
				params.push(key+'='+(key.substring(0,6) == 'oauth_' ? encodeURIComponent(args[key]) : args[key]));
			}
			params.sort();
			return params.join('&');
		}
	}
}