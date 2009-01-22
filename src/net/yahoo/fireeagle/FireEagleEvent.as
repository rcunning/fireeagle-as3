/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package net.yahoo.fireeagle
{
	import flash.events.Event;

	/**
	 * Event class for Fire Eagle web service responses.
	 * @author Ryan Cunningham (rcunning@yahoo-inc.com)
	 * 
	 */	
	public class FireEagleEvent extends Event
	{
		/**
		 * Constant used to indicate success of a request, appented to specific api method names.
		 */	
		public static const SUCCESS:String = "Success";
		/**
		 * Constant used to indicate failure of a request, appented to specific api method names.
		 */	
		public static const FAILURE:String = "Failure";
		
		/**
		 * Constant defining the name of the event fired when the <code>user</code> request completes successfully.
		 * @see FireEagleMethod
		 */	
		public static const USER_SUCCESS:String = FireEagleConfig.USER_API_METHOD+SUCCESS;
		/**
		 * Constant defining the name of the event fired when the <code>lookup</code> request completes successfully.
		 * @see FireEagleMethod
		 */	
		public static const LOOKUP_SUCCESS:String = FireEagleConfig.LOOKUP_API_METHOD+SUCCESS;
		/**
		 * Constant defining the name of the event fired when the <code>update</code> request completes successfully.
		 * @see FireEagleMethod
		 */	
		public static const UPDATE_SUCCESS:String = FireEagleConfig.UPDATE_API_METHOD+SUCCESS;
		/**
		 * Constant defining the name of the event fired when the <code>recent</code> request completes successfully.
		 * @see FireEagleMethod
		 */	
		public static const RECENT_SUCCESS:String = FireEagleConfig.RECENT_API_METHOD+SUCCESS;
		/**
		 * Constant defining the name of the event fired when the <code>within</code> request completes successfully.
		 * @see FireEagleMethod
		 */	
		public static const WITHIN_SUCCESS:String = FireEagleConfig.WITHIN_API_METHOD+SUCCESS;
		
		/**
		 * Constant defining the name of the event fired when the <code>newRequestToken</code> completes successfully.
		 * @see FireEagleAuth
		 */	
		public static const REQUEST_TOKEN_SUCCESS:String = FireEagleConfig.REQUEST_TOKEN_NAME+SUCCESS;
		/**
		 * Constant defining the name of the event fired when the <code>converToAccessToken</code> completes successfully.
		 * @see FireEagleAuth
		 */	
		public static const ACCESS_TOKEN_SUCCESS:String = FireEagleConfig.ACCESS_TOKEN_NAME+SUCCESS;
		
		/**
		 * Constant defining the name of the event fired when the <code>user</code> request fails.
		 * @see FireEagleMethod
		 */	
		public static const USER_FAILURE:String = FireEagleConfig.USER_API_METHOD+FAILURE;
		/**
		 * Constant defining the name of the event fired when the <code>lookup</code> request fails.
		 * @see FireEagleMethod
		 */	
		public static const LOOKUP_FAILURE:String = FireEagleConfig.LOOKUP_API_METHOD+FAILURE;
		/**
		 * Constant defining the name of the event fired when the <code>update</code> request fails.
		 * @see FireEagleMethod
		 */	
		public static const UPDATE_FAILURE:String = FireEagleConfig.UPDATE_API_METHOD+FAILURE;
		/**
		 * Constant defining the name of the event fired when the <code>recent</code> request fails.
		 * @see FireEagleMethod
		 */	
		public static const RECENT_FAILURE:String = FireEagleConfig.RECENT_API_METHOD+FAILURE;
		/**
		 * Constant defining the name of the event fired when the <code>within</code> request fails.
		 * @see FireEagleMethod
		 */	
		public static const WITHIN_FAILURE:String = FireEagleConfig.WITHIN_API_METHOD+FAILURE;
		
		/**
		 * Constant defining the name of the event fired when the <code>newRequestToken</code> request fails.
		 * @see FireEagleAuth
		 */	
		public static const REQUEST_TOKEN_FAILURE:String = FireEagleConfig.REQUEST_TOKEN_NAME+FAILURE;
		/**
		 * Constant defining the name of the event fired when the <code>converToAccessToken</code> request fails.
		 * @see FireEagleAuth
		 */	
		public static const ACCESS_TOKEN_FAILURE:String = FireEagleConfig.ACCESS_TOKEN_NAME+FAILURE;
		
		/**
		 * Constant defining the name of the event fired when a security error in encountered while attempting a request.
		 * @see SecurityErrorEvent
		 */	
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * The event data object.
		 */	
		protected var _data:Object;
		
		/**
		 * The event <code>FireEagleResponse</code> object.
		 */	
		protected var _response:FireEagleResponse;
		
		/**
		 * Creates a new <code>FireEagleEvent</code> object.
		 * @param type
		 * @param data
		 * @param response
		 * @param bubbles
		 * @param cancelable
		 * 
		 */	
		public function FireEagleEvent(type:String, data:Object=null, response:FireEagleResponse=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
			_response = response;
		}
		
		/**
		 * The event data object.
		 * @return 
		 * 
		 */	
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * The event <code>FireEagleResponse</code> object.
		 * @return 
		 * 
		 */	
		public function get response():FireEagleResponse
		{
			return _response;
		}
		
		/**
		 * Create a new <code>FireEagleEvent</code> object with the same properties as this one.
		 * @return 		<code>FireEagleEvent</code>
		 * 
		 */	
		public override function clone():Event
		{
			return duplicate();
		}
		
		/**
		 * Create a new <code>FireEagleEvent</code> object with the same properties as this one.
		 * (Note, not named "clone" because of incompatible override return types)
		 * @return 		<code>FireEagleEvent</code>
		 * 
		 */	
		public function duplicate():FireEagleEvent
		{
			return new FireEagleEvent(type, data, response, bubbles, cancelable);
		}
	}
}
