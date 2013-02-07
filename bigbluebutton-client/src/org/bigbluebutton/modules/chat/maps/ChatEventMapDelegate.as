/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
* 
* Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 3.0 of the License, or (at your option) any later
* version.
* 
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
*
*/
package org.bigbluebutton.modules.chat.maps {
	import com.asfusion.mate.events.Dispatcher;
	
	import flash.events.IEventDispatcher;
	
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.events.CloseWindowEvent;
	import org.bigbluebutton.common.events.OpenWindowEvent;
	import org.bigbluebutton.core.BBB;
	import org.bigbluebutton.main.events.ModuleStartedEvent;
	import org.bigbluebutton.modules.chat.events.ChatOptionsEvent;
	import org.bigbluebutton.modules.chat.events.StartChatModuleEvent;
	import org.bigbluebutton.modules.chat.model.ChatOptions;
	import org.bigbluebutton.modules.chat.views.ChatWindow;
	import org.bigbluebutton.util.i18n.ResourceUtil;
	
	public class ChatEventMapDelegate {
		private var dispatcher:IEventDispatcher;

		private var _chatWindow:ChatWindow;
		private var _chatWindowOpen:Boolean = false;
		private var globalDispatcher:Dispatcher;
		
		private var translationEnabled:Boolean;
		private var translationOn:Boolean;
		private var chatOptions:ChatOptions;
		
    private static const MODULE_NAME:String = "ChatModule";
    
		public function ChatEventMapDelegate() {
			this.dispatcher = dispatcher;
			_chatWindow = new ChatWindow();
			globalDispatcher = new Dispatcher();
      openChatWindow();
		}

		private function getChatOptions():void {
			chatOptions = new ChatOptions();
		}
		
		public function openChatWindow():void {	
			getChatOptions();
			_chatWindow.chatOptions = chatOptions;
		   	_chatWindow.title = ResourceUtil.getInstance().getString("bbb.chat.title");
		   	_chatWindow.showCloseButton = false;
		   	
		   	// Use the GLobal Dispatcher so that this message will be heard by the
		   	// main application.		   	
			var event:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
			event.window = _chatWindow; 
			globalDispatcher.dispatchEvent(event);		   	
		   	_chatWindowOpen = true;			
			dispatchTranslationOptions();			
		}
		
		public function closeChatWindow():void {
			var event:CloseWindowEvent = new CloseWindowEvent(CloseWindowEvent.CLOSE_WINDOW_EVENT);
			event.window = _chatWindow;
			globalDispatcher.dispatchEvent(event);
		   	
		   	_chatWindowOpen = false;
		}
		
		public function setTranslationOptions(e:StartChatModuleEvent):void{
			translationEnabled = e.translationEnabled;
			translationOn = e.translationOn;
		}
    
    public function sendChatModuleReadyEvent():void {
       
      var event:ModuleStartedEvent = new ModuleStartedEvent();
      event.moduleName = MODULE_NAME;
      event.started = true;
      
      trace("***** Sending module started event for [" + MODULE_NAME + "]");
      
      globalDispatcher.dispatchEvent(event);
    }
		
		private function dispatchTranslationOptions():void{
			var enableEvent:ChatOptionsEvent = new ChatOptionsEvent(ChatOptionsEvent.TRANSLATION_OPTION_ENABLED);
			enableEvent.translationEnabled = translationEnabled;
			enableEvent.translateOn = translationOn;
			globalDispatcher.dispatchEvent(enableEvent);
		}
	}
}