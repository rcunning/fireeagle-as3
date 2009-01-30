/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.IFireEagleResponse;

	/**
	 * Wrapper class for XML parsed Fire Eagle response objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class XMLResponse extends XMLObject implements IFireEagleResponse
	{
		/**
		 * An array of <code>XMLUser</code> object if parsed from the response.
		 */
		protected var _users:Array;
		/**
		 * An array of <code>XMLLocation</code> object if parsed from the response.
		 */
		protected var _locations:Array;
		
		/**
		 * Creates a new <code>XMLResponse</code> object.
		 * @param responseString	The response string
		 */
		public function XMLResponse(responseString:String)
		{
			super(new XML(responseString));
		}
		
		/**
		 * <code>Object</code> that is the XML data type of the response.
		 * @returns Object
		 */
		public function get data():Object
		{
			return xml;
		}
		
		/**
		 * Gets the whether or not the response was successful.
		 * @return 					<code>true</code> if successful, <code>false</code> otherwise
		 * 
		 */
		public function get success():Boolean
		{
			return xml.@stat == "ok";
		}
		
		/**
		 * Gets any <code>XMLUser</user> objects parsed from the response.
		 * @return 					array of <code>XMLUser</user>
		 * 
		 */
		public function get users():Array
		{
			if (_users == null) {
				//var n:Namespace = xml.namespace();
				//_users = parseToArray(xml.n::user, XMLUser);
				_users = parseToArray(xml.user, XMLUser);
				if (_users.length == 0 && xml.users != null) {
					_users = parseToArray(xml.users.user, XMLUser);
				}
			}
			return _users;
		}
		
		/**
		 * Gets any <code>XMLLocation</user> objects parsed from the response.
		 * @return 					array of <code>XMLLocation</user>
		 * 
		 */
		public function get locations():Array
		{
			if (_locations == null && xml.locations != null) {
				_locations = parseToArray(xml.locations.location, XMLLocation);
			}
			return _locations;
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "XMLResponse{success:"+success+
			", users:"+users+
			", locations:"+locations+
			"}";
		}
	}
}