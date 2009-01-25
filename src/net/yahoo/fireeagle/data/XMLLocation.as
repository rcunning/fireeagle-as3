/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.IFireEagleLocation;
	import net.yahoo.fireeagle.location.BoundingBox;
	import net.yahoo.fireeagle.location.LatLon;
	
	/**
	 * Wrapper class for XML parsed Fire Eagle location objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class XMLLocation extends XMLObject implements IFireEagleLocation
	{
		/**
		 * The date/time of the location update.
		 */
		protected var _locatedAt:Date;
		
		/**
		 * The point for the location.
		 */
		protected var _point:LatLon;
		
		/**
		 * The georss namespace.
		 */
		protected var _georss:Namespace = new Namespace("http://www.georss.org/georss");
		
		/**
		 * The bounding box for the location.
		 */
		protected var _boundingBox:BoundingBox;
		
		/**
		 * Creates a new <code>XMLLocation</code> object.
		 * @param xml		XML object to parse
		 */
		public function XMLLocation(xml:XML)
		{
			super(xml);
		}
		
		/**
		 * Location label?
		 * @return		the label
		 */
		public function get label():String
		{
			return xml.label;
		}
		
		/**
		 * The level number of the location (0-6).
		 * @return		the level number
		 */
		public function get level():Number
		{
			return parseInt(xml.level);
		}
		
		/**
		 * Name of the level of the location 
		 * (Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code or exact location).
		 * @return		the level name
		 */
		public function get levelName():String
		{
			return xml["level-name"];
		}
		
		/**
		 * Human-readable name for the location.
		 * @return		the name
		 */
		public function get name():String
		{
			return xml.name;
		}
		
		/**
		 * The placeid of the location, same as on Flickr.
		 * @return		the date time
		 */
		public function get placeId():String
		{
			return xml["place-id"];
		}
		
		/**
		 * The woeid of the location.
		 * @return		the woeid
		 */
		public function get woeid():uint
		{
			return xml.woeid;
		}
		
		/**
		 * The date/time of the location update.
		 * @return		the date time
		 */
		public function get locatedAt():Date
		{
			if (_locatedAt == null) {
				_locatedAt = ParseHelpers.parseToDate(xml["located-at"]);
			}
			return _locatedAt;
		}
		
		/**
		 * Gets the point of the location if available.
		 * @return		the point of the location, null if not available
		 */
		public function get point():LatLon
		{
			if (_point == null) {
				_point = parseToLatLon(xml._georss::point[0]);
			}
			return _point;
		}
		
		/**
		 * Gets the bounding box of the location if available.
		 * @return		the bounding box of the location, null if not available
		 */
		public function get boundingBox():BoundingBox
		{
			if (_boundingBox == null) {
				_boundingBox = parseToBoundingBox(xml._georss::box[0]);
			}
			return _boundingBox;
		}
		
		/**
		 * Is this location Fire Eagle's best guess?
		 * @return		<code>true</code> if the location is Fire Eagle's best guess
		 */
		public function get bestGuess():Boolean
		{
			return xml.@["best-guess"] == "true";
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "XMLLocation{label:"+label+
			", level:"+level+
			", levelName:"+levelName+
			", name:"+name+
			", placeId:"+placeId+
			", woeid:"+woeid+
			", locatedAt:"+locatedAt+
			", point:"+point+
			", boundingBox:"+boundingBox+
			", bestGuess:"+bestGuess+
			"}";
		}
	}
}
