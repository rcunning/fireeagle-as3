/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.location
{
	/**
	 * Data helper class for a geographic bounding box 
	 * (bottom left Latitude and Longitude, and top right).
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class BoundingBox
	{
		/**
		 * The bottom left geo point of the box.
		 */
		protected var _bottomLeft:LatLon;
		/**
		 * The top right geo point of the box.
		 */
		protected var _topRight:LatLon;
		
		/**
		 * Creates a new <code>BoundingBox</code> object.
		 * @param bottomLeft	the bottom left geo point of the box
		 * @param topRight		the top right geo point of the box
		 */
		public function BoundingBox(bottomLeft:LatLon, topRight:LatLon)
		{
			_bottomLeft = bottomLeft;
			_topRight = topRight;
			validate();
		}
		
		/**
		 * The bottom left geo point of the box.
		 * @return		the bottom left geo point
		 */
		public function get bottomLeft():LatLon
		{
			return _bottomLeft;
		}
		
		/**
		 * Sets the bottom left geo point of the box.
		 * @param latlon	the bottom left geo point
		 */
		public function set bottomLeft(latlon:LatLon):void
		{
			_bottomLeft = latlon;
			validate();
		}
		
		/**
		 * The top right geo point of the box.
		 * @return		the top right geo point
		 */
		public function get topRight():LatLon
		{
			return _topRight;
		}
		
		/**
		 * Sets the top right geo point of the box.
		 * @param latlon	the top right geo point
		 */
		public function set topRight(latlon:LatLon):void
		{
			_topRight = latlon;
			validate();
		}
		
		/**
		 * Validates the bottom left is less than the top right
		 * and that the LatLons are also valid.
		 * @throws Error
		 */
		public function validate():void
		{
			bottomLeft.validate();
			topRight.validate();
			if (bottomLeft.lat > topRight.lat || bottomLeft.lon > topRight.lon) {
				throw new Error("Bottom Left LatLon is greater than Top Right LatLon");
			}
		}
		
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		public function toString():String
		{
			return String(bottomLeft.toString() + "," + topRight.toString());
		}
	}
}
