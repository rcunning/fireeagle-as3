/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	/**
	 * A class for the strings used to generate Fire Eagle API calls.
	 * You can override most of these strings if you want to point the library to
	 * different servers or uses different paths for method calls. Be sure to 
	 * regenerate derrived <code>*_API_PATH</code> strings if you change <code>API_PATH</code> or
	 * any <code>*_API_METHOD</code> strings.  
	 * 
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 */	
	public class FireEagleConfig
	{
		/**
		 * The OAuth realm for Fire Eagle autorization.
		 */
		public static var OAUTH_REALM:String        = "fireeagle.yahoo.net";
		/**
		 * The protocol and hostname for the Fire Eagle autorization server.
		 */
		public static var AUTH_SERVER:String        = "https://fireeagle.yahoo.net";
		/**
		 * The path used to get a new request token from the authorization server.
		 */
		public static var REQUEST_TOKEN_PATH:String = "/oauth/request_token";
		/**
		 * The path used to convert a request token to an access token (after user authorizes)
		 * from the authorization server.
		 */
		public static var ACCESS_TOKEN_PATH:String  = "/oauth/access_token";
		/**
		 * The path used to generate an authorize url that the user may be presented
		 * to to authorize an app on the authorization server.
		 */
		public static var AUTHORIZATION_PATH:String = "/oauth/authorize";
		/**
		 * The path for mobile used to generate an authorize url that the user may be presented
		 * to to authorize an app on the authorization server.
		 */
		public static var MOBILE_AUTH_PATH:String   = "/oauth/mobile_auth/";
		
		/**
		 * A name for new request token related events, prepended to event strings in <code>FireEagleEvent</code>.
		 * @see FireEagleEvent
		 */
		public static const REQUEST_TOKEN_NAME:String = "requestToken";
		/**
		 * A name for converting a request token to an access token related events, prepended 
		 * to event strings in <code>FireEagleEvent</code>.
		 * * @see FireEagleEvent
		 */
		public static const ACCESS_TOKEN_NAME:String  = "accessToken";
			
		/**
		 * The protocol and hostname for the Fire Eagle API server.
		 */	
		public static var API_SERVER:String         = "https://fireeagle.yahooapis.com";
		/**
		 * The path of the Fire Eagle API methods on the Fire Eagle API server.
		 */
		public static var API_PATH:String           = "/api/0.1/";
		
		/**
		 * The user method name for the Fire Eagle API, and related events prepended in <code>FireEagleEvent</code>.
		 */
		public static var USER_API_METHOD:String    = "user";
		/**
		 * The lookup method name for the Fire Eagle API, and related events prepended in <code>FireEagleEvent</code>.
		 */
		public static var LOOKUP_API_METHOD:String  = "lookup";
		/**
		 * The update method name for the Fire Eagle API, and related events prepended in <code>FireEagleEvent</code>.
		 */
		public static var UPDATE_API_METHOD:String  = "update";
		/**
		 * The recent method name for the Fire Eagle API, and related events prepended in <code>FireEagleEvent</code>.
		 */
		public static var RECENT_API_METHOD:String  = "recent";
		/**
		 * The within method name for the Fire Eagle API, and related events prepended in <code>FireEagleEvent</code>.
		 */
		public static var WITHIN_API_METHOD:String  = "within";
		
		/**
		 * The user method path for the Fire Eagle API server. Be sure to regenerate if you change the
		 * <code>API_PATH</code>.
		 */
		public static var USER_API_PATH:String      = API_PATH + USER_API_METHOD;
		/**
		 * The lookup method path for the Fire Eagle API server. Be sure to regenerate if you change the
		 * <code>API_PATH</code>.
		 */
		public static var LOOKUP_API_PATH:String    = API_PATH + LOOKUP_API_METHOD;
		/**
		 * The update method path for the Fire Eagle API server. Be sure to regenerate if you change the
		 * <code>API_PATH</code>.
		 */
		public static var UPDATE_API_PATH:String    = API_PATH + UPDATE_API_METHOD;
		/**
		 * The recent method path for the Fire Eagle API server. Be sure to regenerate if you change the
		 * <code>API_PATH</code>.
		 */
		public static var RECENT_API_PATH:String    = API_PATH + RECENT_API_METHOD;
		/**
		 * The within method path for the Fire Eagle API server. Be sure to regenerate if you change the
		 * <code>API_PATH</code>.
		 */
		public static var WITHIN_API_PATH:String    = API_PATH + WITHIN_API_METHOD;
		
		/**
		 * The REST response format type string for XML.
		 */
		public static const FORMAT_XML:String       = "xml";
		/**
		 * The REST response format type string for JSON.
		 */
		public static const FORMAT_JSON:String      = "json";
	}
}