/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	/**
	 * A class of static parse helper functions.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class ParseHelpers
	{
		/**
		 * Parses a string date/time object to a <code>Date</code>.
		 * @param obj				The string to parse from
		 * @return 					A new <code>Date</code>, or null if the parse failed
		 * 
		 */
		public static function parseToDate(date:String):Date
		{
			if (date != null) {
				var utc:String = date.replace(/(.*)-(.*)-(.*)T(.*)-(.*):(.*)/, "$1/$2/$3 $4 UTC-$5$6");
				var val:Number = Date.parse(utc);
				if (!isNaN(val)) {
					return new Date(val);
				}
			}
			return null;
		}
	}
}
