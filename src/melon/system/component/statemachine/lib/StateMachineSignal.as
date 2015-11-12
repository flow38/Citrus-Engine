package melon.system.component.statemachine.lib
{
	
	public class StateMachineSignal
	{
		
		private var _fromState : String;
		private var _toState : String;
		private var _currentState : String;
		private var _allowedStates : Object;

		public function StateMachineSignal()
		{
		}

		public function get fromState():String
		{
			return _fromState;
		}

		public function set fromState(value:String):void
		{
			_fromState = value;
		}

		public function get toState():String
		{
			return _toState;
		}

		public function set toState(value:String):void
		{
			_toState = value;
		}

		public function get currentState():String
		{
			return _currentState;
		}

		public function set currentState(value:String):void
		{
			_currentState = value;
		}

		public function get allowedStates():Object
		{
			return _allowedStates;
		}

		public function set allowedStates(value:Object):void
		{
			_allowedStates = value;
		}


	}
}
