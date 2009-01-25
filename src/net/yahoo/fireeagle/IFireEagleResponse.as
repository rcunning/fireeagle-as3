/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	/**
	 * Wrapper interface parsed Fire Eagle response objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public interface IFireEagleResponse
	{
		/**
		 * Gets the whether or not the response was successful.
		 * @return 					<code>true</code> if successful, <code>false</code> otherwise
		 * 
		 */
		function get success():Boolean;
		/**
		 * Gets any <code>IFireEagleUser</user> objects parsed from the response.
		 * @return 					array of <code>IFireEagleUser</user>
		 * 
		 */
		function get users():Array;
		/**
		 * Gets any <code>IFireEagleLocation</user> objects parsed from the response.
		 * @return 					array of <code>IFireEagleLocation</user>
		 * 
		 */
		function get locations():Array;
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		function toString():String;
	}
}
