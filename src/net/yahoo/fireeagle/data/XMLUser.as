/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.IFireEagleLocation;
	import net.yahoo.fireeagle.IFireEagleUser;
	
	/**
	 * Wrapper class for XML parsed Fire Eagle user objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class XMLUser extends XMLObject implements IFireEagleUser
	{
		/**
		 * The date/time of the user's location update.
		 */
		protected var _locatedAt:Date;
		/**
		 * An array of <code>XMLLocation</code> object if parsed from the user location_hierarchy.
		 */
		protected var _locations:Array;
		
		/**
		 * Creates a new <code>XMLUser</code> object.
		 * @param xml		XML object to parse
		 */
		public function XMLUser(xml:XML)
		{
			super(xml);
		}
		
		/**
		 * The user-specific token for this application.
		 * @return		the token
		 */
		public function get token():String
		{
			return xml.@token;
		}
		
		/**
		 * The date/time of the user's location update.
		 * @return		the date time
		 */
		public function get locatedAt():Date
		{
			if (_locatedAt == null) {
				_locatedAt = ParseHelpers.parseToDate(xml.@["located-at"]);
			}
			return _locatedAt;
		}
		
		/**
		 * The timezone.
		 * @return		the timezone
		 */
		public function get timezone():String
		{
			var locH:XML = xml["location-hierarchy"][0];
			if (locH != null) {
				return locH.@timezone;
			}
			return null;
		}
		
		/**
		 * The hierarchy string.
		 * @return		the hierarchy string
		 */
		public function get hierarchyString():String
		{
			var locH:XML = xml["location-hierarchy"][0];
			if (locH != null) {
				return locH.@string;
			}
			return null;
		}
		
		/**
		 * Fire Eagle's "best guess" form this User's Location. This best guess is derived as the most accurate
		 * level of the hierarchy with a timestamp in the last half an hour <b>or</b> as the most accurate
		 * level of the hierarchy with the most recent timestamp.
		 * @return		The <code>IFireEagleLocation</code> that is the best guess, or <code>null</code> if none present
		 */
		public function get bestGuess():IFireEagleLocation
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
		 * @return		An array of <code>IFireEagleLocation</code> objects
		 */
		public function get locations():Array
		{
			if (_locations == null) {
				_locations = parseToArray(xml["location-hierarchy"].location, XMLLocation);
			}
			return _locations;
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "XMLUser{token:"+token+
			", locatedAt:"+locatedAt+
			", timezone:"+timezone+
			", hierarchyString:"+hierarchyString+
			", bestGuess:"+bestGuess+
			", locations:"+locations+
			"}";
		}
	}
}
