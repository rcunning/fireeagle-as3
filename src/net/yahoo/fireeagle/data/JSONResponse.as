/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.IFireEagleResponse;
	
	/**
	 * Wrapper class for JSON parsed Fire Eagle response objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class JSONResponse extends JSONObject implements IFireEagleResponse
	{
		/**
		 * An array of <code>JSONUser</code> object if parsed from the response.
		 */
		protected var _users:Array;
		/**
		 * An array of <code>JSONLocation</code> object if parsed from the response.
		 */
		protected var _locations:Array;
		
		/**
		 * Creates a new <code>JSONResponse</code> object.
		 * @param obj
		 */
		public function JSONResponse(obj:Object)
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
		 * Gets any <code>JSONUser</user> objects parsed from the response.
		 * @return 					array of <code>JSONUser</user>
		 * 
		 */
		public function get users():Array
		{
			if (_users == null) {
				if (data.hasOwnProperty("user")) {
					_users = new Array(new JSONUser(data.user));
				} else {
					_users = parseToArray(data, "users", JSONUser);
				}
			}
			return _users;
		}
		
		/**
		 * Gets any <code>JSONLocation</user> objects parsed from the response.
		 * @return 					array of <code>JSONLocation</user>
		 * 
		 */
		public function get locations():Array
		{
			if (_locations == null) {
				_locations = parseToArray(data, "locations", JSONLocation);
			}
			return _locations;
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "JSONResponse{success:"+success+
			", users:"+users+
			", locations:"+locations+
			"}";
		}
	}
}
