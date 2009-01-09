/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.location
{
	import flash.geom.Point;
	
	/**
	 * Data helper class for a geographic point (Latitude and Longitude).
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class LatLon
	{
		/**
		 * The Latitude and Logitude stored in a Point object.
		 */
		protected var _latlon:Point;
		
		/**
		 * Creates a new <code>LatLon</code> object.
		 * @param lat	the latitude value
		 * @param lon	the longitude value
		 */
		public function LatLon(lat:Number, lon:Number)
		{
			_latlon = new Point(lon, lat);
			validate();
		}
		
		/**
		 * The latitude value of the geo point.
		 * @return		the latitude value
		 */
		public function get lat():Number
		{
			return _latlon.y;
		}
		
		/**
		 * Sets the latitude value of the geo point.
		 * @param val		the latitude value
		 */
		public function set lat(val:Number):void
		{
			_latlon.y = val;
			validate();
		}
		
		/**
		 * The longitude value of the geo point.
		 * @return		the longitude value
		 */
		public function get lon():Number
		{
			return _latlon.x;
		}
		
		/**
		 * Sets the longitude value of the geo point.
		 * @param val		the longitude value
		 */
		public function set lon(val:Number):void
		{
			_latlon.x = val;
			validate();
		}
		
		/**
		 * Validates the lat lon position is within valid ranges.
		 * @throws Error		if the lat lon values are out of range
		 */
		public function validate():void
		{
			if (lat < -85 || lat > 85) {
				throw new Error("latitude is out of range");
			}
			if (lon < -180 || lon > 180) {
				throw new Error("longitude is out of range");
			}
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return String(lat + "," + lon);
		}
	}
}
