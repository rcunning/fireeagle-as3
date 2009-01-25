/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.location.BoundingBox;
	import net.yahoo.fireeagle.location.LatLon;
	/**
	 * Wrapper base class for JSON parsed objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class JSONObject
	{
		/**
		 * The JSON data object.
		 */
		protected var _data:Object;
		
		/**
		 * Creates a new <code>JSONObject</code> object.
		 * @param obj
		 */
		public function JSONObject(obj:Object)
		{
			_data = obj;
		}
		
		/**
		 * The raw data object.
		 * @return 
		 * 
		 */	
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * Parses a JSON object with numeric properties to a typed <code>Array</code>.
		 * @param obj				The JSON object to parse from
		 * @param propertyName		The name of the property on <code>obj</code> that contains the numeric properties to parse
		 * @param classToContruct	The <code>Class</code> of the returned array item data to contruct from each numeric property
		 * @return 					A new array with all <code>Class</code> typed items, or an empty array if the parse failed
		 * 
		 */
		public static function parseToArray(obj:Object, propertyName:String, classToConstruct:Class):Array
		{
			var a:Array = new Array();
			if (obj.hasOwnProperty(propertyName)) {
				for (var i:int = 0; obj[propertyName].hasOwnProperty(i); i++) {
					a.push(new classToConstruct(obj[propertyName][i]));
				}
			}
			return a;
		}
		
		/**
		 * Parses a JSON date/time object to a <code>Date</code>.
		 * @param obj				The JSON object to parse from
		 * @return 					A new <code>Date</code>, or null if the parse failed
		 * 
		 */
		public static function parseToDate(obj:Object):Date
		{
			if (obj != null) {
				return ParseHelpers.parseToDate(obj.toString());
			}
			return null;
		}
		
		/**
		 * Parses a JSON geo point object to a <code>LatLon</code>.
		 * @param obj				The JSON object to parse from
		 * @return 					A new <code>LatLon</code>, or null if the parse failed
		 * 
		 */
		public static function parseToLatLon(obj:Object):LatLon
		{
			if (obj.hasOwnProperty("0") && obj.hasOwnProperty("1")) {
				return new LatLon(obj[1], obj[0]);
			}
			return null;
		}
		
		/**
		 * Parses a JSON geo bounding box object to a <code>BoundingBox</code>.
		 * @param obj				The JSON object to parse from
		 * @return 					A new <code>BoundingBox</code>, or null if the parse failed
		 * 
		 */
		public static function parseToBoundingBox(obj:Object):BoundingBox
		{
			if (obj.hasOwnProperty("0") && obj.hasOwnProperty("1")) {
				return new BoundingBox(parseToLatLon(obj[0]), parseToLatLon(obj[1]));
			}
			return null;
		}
	}
}
