/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	/**
	 * Wrapper interface for parsed Fire Eagle user objects.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */
	public interface IFireEagleUser
	{
		/**
		 * The user-specific token for this application.
		 * @return		the token
		 */
		function get token():String;
		/**
		 * The date/time of the user's location update.
		 * @return		the date time
		 */
		function get locatedAt():Date;
		/**
		 * The timezone.
		 * @return		the timezone
		 */
		function get timezone():String;
		/**
		 * The hierarchy string.
		 * @return		the hierarchy string
		 */
		function get hierarchyString():String;
		/**
		 * Fire Eagle's "best guess" form this User's Location. This best guess is derived as the most accurate
		 * level of the hierarchy with a timestamp in the last half an hour <b>or</b> as the most accurate
		 * level of the hierarchy with the most recent timestamp.
		 * @return		The <code>IFireEagleLocation</code> that is the best guess, or <code>null</code> if none present
		 */
		function get bestGuess():IFireEagleLocation;
		/**
		 * An Array containing all Location granularity that the Client has been allowed to
		 * see for the User. The Location elements returned are arranged in hierarchy order consisting of: 
		 * Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code and exact location.
		 * The Application should therefore be prepared to receive a response that may consist of (1) only
		 * country, or (2) country & state or (3) country, state & county and so forth.
		 * @return		An array of <code>IFireEagleLocation</code> objects
		 */
		function get locations():Array;
		/**
		 * <code>String</code> representation.
		 * @returns String
		 */
		function toString():String;
	}
}
