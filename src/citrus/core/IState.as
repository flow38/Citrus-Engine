package citrus.core {

	import citrus.system.IEntity;
	import citrus.view.ACitrusView;

	/**
	 * Take a look on the 2 respective states to have some information on the functions.
	 */
	public interface IState {
		
		function destroy():void;
		
		function get view():ACitrusView;
		
		function initialize():void;
		
		function update(timeDelta:Number):void;
		
		function add(object:ICitrusObject):ICitrusObject;
		
		function addEntity(entity:IEntity):IEntity;
		
		function remove(object:ICitrusObject):void;
		
		function removeImmediately(object:ICitrusObject):void;
		
		function getObjectByName(name:String):ICitrusObject;
		
		function getFirstObjectByType(type:Class):ICitrusObject;
		
		function getObjectsByType(type:Class):Vector.<ICitrusObject>;
	}
}
