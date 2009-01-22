/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import net.yahoo.fireeagle.util.JSONObject;
	/**
	 * Wrapper class for JSON parsed Fire Eagle user objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class FireEagleUser extends JSONObject
	{
		/**
		 * The date/time of the user's location update.
		 */
		protected var _locatedAt:Date;
		/**
		 * An array of <code>FireEagleLocation</code> object if parsed from the user location_hierarchy.
		 */
		protected var _locations:Array;
		
		/**
		 * Creates a new <code>FireEagleUser</code> object.
		 * @param obj		JSON object to parse
		 */
		public function FireEagleUser(obj:Object)
		{
			super(obj);
			
		}
		
		/**
		 * The user-specific token for this application.
		 * @return		the token
		 */
		public function get token():String
		{
			return data["token"];
		}
		
		/**
		 * The date/time of the user's location update.
		 * @return		the date time
		 */
		public function get locatedAt():Date
		{
			if (_locatedAt == null) {
				_locatedAt = parseToDate(data["located_at"]);
			}
			return _locatedAt;
		}
		
		/**
		 * The timezone.
		 * @return		the timezone
		 */
		public function get timezone():String
		{
			return data["timezone"];
		}
		
		/**
		 * The hierarchy string.
		 * @return		the hierarchy string
		 */
		public function get hierarchyString():String
		{
			return data["hierarchy_string"];
		}
		
		/**
		 * FireEagle's "best guess" form this User's Location. This best guess is derived as the most accurate
		 * level of the hierarchy with a timestamp in the last half an hour <b>or</b> as the most accurate
		 * level of the hierarchy with the most recent timestamp.
		 * @return		The <code>FireEagleLocation</code> that is the best guess, or <code>null</code> if none present
		 */
		public function get bestGuess():FireEagleLocation
		{
			for (var i:int = 0; i < locations.length; i++) {
				if (locations[i].bestGuess) {
					return locations[i];
				}
			}
			return null;
		}
		
		/**
		 * An Array containing all Location granularity that the Client has been allowed to
		 * see for the User. The Location elements returned are arranged in hierarchy order consisting of: 
		 * Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code and exact location.
		 * The Application should therefore be prepared to receive a response that may consist of (1) only
		 * country, or (2) country & state or (3) country, state & county and so forth.
		 * @return		An array of <code>FireEagleLocation</code> objects
		 */
		public function get locations():Array
		{
			if (_locations == null) {
				_locations = parseToArray(data, "location_hierarchy", FireEagleLocation);
			}
			return _locations;
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "User{token:"+token+
			", locatedAt:"+locatedAt+
			", timezone:"+timezone+
			", hierarchyString:"+hierarchyString+
			", bestGuess:"+bestGuess+
			", locations:"+locations+
			"}";
		}
	}
}
