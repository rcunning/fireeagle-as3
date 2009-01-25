/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import net.yahoo.fireeagle.location.LatLon;
	import net.yahoo.fireeagle.location.BoundingBox;
	
	/**
	 * Wrapper interface for parsed Fire Eagle location objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public interface IFireEagleLocation
	{
		/**
		 * Location label?
		 * @return		the label
		 */
		function get label():String;
		/**
		 * The level number of the location (0-6).
		 * @return		the level number
		 */
		function get level():Number;
		/**
		 * Name of the level of the location 
		 * (Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code or exact location).
		 * @return		the level name
		 */
		function get levelName():String;
		/**
		 * Human-readable name for the location.
		 * @return		the name
		 */
		function get name():String;
		/**
		 * The placeid of the location, same as on Flickr.
		 * @return		the date time
		 */
		function get placeId():String;
		/**
		 * The woeid of the location.
		 * @return		the woeid
		 */
		function get woeid():uint;
		/**
		 * The date/time of the location update.
		 * @return		the date time
		 */
		function get locatedAt():Date
		/**
		 * Gets the point of the location if available.
		 * @return		the point of the location, null if not available
		 */
		function get point():LatLon;
		/**
		 * Gets the bounding box of the location if available.
		 * @return		the bounding box of the location, null if not available
		 */
		function get boundingBox():BoundingBox;
		/**
		 * Is this location Fire Eagle's best guess?
		 * @return		<code>true</code> if the location is Fire Eagle's best guess
		 */
		function get bestGuess():Boolean;
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		function toString():String;
	}
}
