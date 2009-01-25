/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle.data
{
	import net.yahoo.fireeagle.location.LatLon;
	import net.yahoo.fireeagle.location.BoundingBox;
	/**
	 * Wrapper base class for XML parsed objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public class XMLObject
	{
		/**
		 * The xml data object.
		 */
		protected var _xml:XML;
		
		/**
		 * Creates a new <code>XMLObject</code> object.
		 * @param obj
		 */
		public function XMLObject(xml:XML)
		{
			_xml = xml;
		}
		
		/**
		 * The raw XML object.
		 * @return 
		 * 
		 */	
		public function get xml():XML
		{
			return _xml;
		}
		
		/**
		 * Parses an XMLList object to a typed <code>Array</code>.
		 * @param xmlList			The list of XML object to parse
		 * @param classToContruct	The <code>Class</code> of the returned array item data to contruct from each XML item
		 * @return 					A new array with all <code>Class</code> typed items, or an empty array if the parse failed
		 * 
		 */
		static public function parseToArray(xmlList:XMLList, classToConstruct:Class):Array 
		{
			var a:Array = new Array();
			for each (var xmlItem:XML in xmlList) {
				a.push(new classToConstruct(xmlItem));
			}
			return a;
		}
		
		/**
		 * Parses a georss:point string to a <code>LatLon</code>.
		 * @param s					The string to parse from
		 * @return 					A new <code>LatLon</code>, or null if the parse failed
		 * 
		 */
		public static function parseToLatLon(s:String):LatLon
		{
			if (s != null && s.length) {
				var a:Array = s.split(" ");
				if (a.length == 2) {
					return new LatLon(a[0], a[1]);
				}
			}
			return null;
		}
		
		/**
		 * Parses a georss:box bounding box string to a <code>BoundingBox</code>.
		 * @param s					The string to parse from
		 * @return 					A new <code>BoundingBox</code>, or null if the parse failed
		 * 
		 */
		public static function parseToBoundingBox(s:String):BoundingBox
		{
			if (s != null && s.length) {
				var a:Array = s.split(" ");
				if (a.length == 4) {
					return new BoundingBox(parseToLatLon(a.slice(0,2).join(" ")), parseToLatLon(a.slice(2,4).join(" ")));
				}
			}
			return null;
		}
	}
}
