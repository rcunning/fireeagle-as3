/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import net.yahoo.fireeagle.util.JSONObject;
	/**
	 * Wrapper class for JSON parsed Fire Eagle response objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class FireEagleResponse extends JSONObject
	{
		/**
		 * An array of <code>FireEagleUser</code> object if parsed from the response.
		 */
		protected var _users:Array;
		/**
		 * An array of <code>FireEagleLocation</code> object if parsed from the response.
		 */
		protected var _locations:Array;
		
		/**
		 * Creates a new <code>FireEagleResponse</code> object.
		 * @param obj
		 */
		public function FireEagleResponse(obj:Object)
		{
			super(obj);
		}
		
		/**
		 * Gets the whether or not the response was successful.
		 * @return 					<code>true</code> if successful, <code>false</code> otherwise
		 * 
		 */
		public function get success():Boolean
		{
			return data.hasOwnProperty("stat") && data.stat == "ok";
		}
		
		/**
		 * Gets any <code>FireEagleUser</user> objects parsed from the response.
		 * @return 					array of <code>FireEagleUser</user>
		 * 
		 */
		public function get users():Array
		{
			if (_users == null) {
				if (data.hasOwnProperty("user")) {
					_users = new Array(new FireEagleUser(data.user));
				} else {
					_users = parseToArray(data, "users", FireEagleUser);
				}
			}
			return _users;
		}
		
		/**
		 * Gets any <code>FireEagleLocation</user> objects parsed from the response.
		 * @return 					array of <code>FireEagleLocation</user>
		 * 
		 */
		public function get locations():Array
		{
			if (_locations == null) {
				_locations = parseToArray(data, "locations", FireEagleLocation);
			}
			return _locations;
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "FireEagleResponse{success:"+success+
			", users:"+users+
			", locations:"+locations+
			"}";
		}
	}
}
