/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.IFireEagleLocation;
	import net.yahoo.fireeagle.location.LatLon;
	import net.yahoo.fireeagle.location.BoundingBox;
	
	/**
	 * Wrapper class for JSON parsed Fire Eagle location objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class JSONLocation extends JSONObject implements IFireEagleLocation
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
		 * The bounding box for the location.
		 */
		protected var _boundingBox:BoundingBox;
		
				/**
		 * Creates a new <code>FireEagleLocation</code> object.
		 * @param obj		JSON object to parse
		 */
		public function JSONLocation(obj:Object)
		{
			super(obj);
		}
		
		/**
		 * Location label?
		 * @return		the label
		 */
		public function get label():String
		{
			return data["label"];
		}
		
		/**
		 * The level number of the location (0-6).
		 * @return		the level number
		 */
		public function get level():Number
		{
			return parseInt(data["level"]);
		}
		
		/**
		 * Name of the level of the location 
		 * (Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code or exact location).
		 * @return		the level name
		 */
		public function get levelName():String
		{
			return data["level_name"];
		}
		
		/**
		 * Human-readable name for the location.
		 * @return		the name
		 */
		public function get name():String
		{
			return data["name"];
		}
		
		/**
		 * The placeid of the location, same as on Flickr.
		 * @return		the date time
		 */
		public function get placeId():String
		{
			return data["place_id"];
		}
		
		/**
		 * The woeid of the location.
		 * @return		the woeid
		 */
		public function get woeid():uint
		{
			return data["woeid"];
		}
		
		/**
		 * The date/time of the location update.
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
		 * Gets the point of the location if available.
		 * @return		the point of the location, null if not available
		 */
		public function get point():LatLon
		{
			if (_point == null && data.hasOwnProperty("geometry") && 
				data.geometry.hasOwnProperty("coordinates") &&
				data.geometry.hasOwnProperty("type") && data.geometry.type == "Point") {
				_point = parseToLatLon(data.geometry.coordinates);
			}
			return _point;
		}
		
		/**
		 * Gets the bounding box of the location if available.
		 * @return		the bounding box of the location, null if not available
		 */
		public function get boundingBox():BoundingBox
		{
			if (_boundingBox == null && data.hasOwnProperty("geometry") && 
				data.geometry.hasOwnProperty("bbox")) {
				_boundingBox = parseToBoundingBox(data.geometry.bbox);
			}
			return _boundingBox;
		}
		
		/**
		 * Is this location Fire Eagle's best guess?
		 * @return		<code>true</code> if the location is Fire Eagle's best guess
		 */
		public function get bestGuess():Boolean
		{
			return data["best_guess"] == "true";
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return "JSONLocation{label:"+label+
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
