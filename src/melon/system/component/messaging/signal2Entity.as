package melon.system.component.messaging {

import flash.utils.Dictionary;

import melon.message.SignalObject;
import melon.system.IMelonEntity;

/**
 * ASignalSuscriber's implementation where signal are listen for and transmitted directly to
 * entity onSignal method
 *
 * Note that unlike as  ASignalSuscriber, Signal2Entity listen for a source signal, but map it to
 * another signal ID. this one is a signal ID handle by the Signal2Entity instance's entity
 *
 * Example:
 * A Door use a signal2Entity to listen at a Base EVENT_BASE_REACHED signal ID, but EVENT_BASE_REACHED signal ID(which is not handle by
 * Door::onSignal() implementation) will be replace by EventEnum.SIGNAL_TOGGLE ID before calling Door::onSignal().
 * See constructor comments for this example's parameters.
 *
 * @author ffalcy
 *
 * @see IMelonEntity
 */
public class signal2Entity extends ASignalSuscriber {

    public static const NAME : String = 'Signal2Entity';

    /**
     *
     * @param    name
     * @param    params    Configuration parameters
     *                    myEntitySignalID property list all signal ID the signal2Entity 's entity (parent entity) handle.
     *                    When user will set a component/entity's signal to listen for , he have to define also to
     *                    which signal ID handle by parent entity, it have to be map.
     *
     *
     *    {
		 * 		'name':'MyComponentNAME';
		 * 		'comp2ListenFor' : [
		 * 				{name : 'MyComp A', listenedSignalID : 'mySignalID', listenedSignalIDMapping : 'myEntityHandleSignalID'},
		 * 				{name : 'MyComp B', listenedSignalID : 'mySignalID', listenedSignalIDMapping : 'myEntityHandleSignalID'},
		 * 				{name : 'MyComp C', listenedSignalID : 'mySignalID', listenedSignalIDMapping : 'myEntityHandleSignalID'}
		 * 			],
		 * 		'entity2ListenFor' : [
		 * 				{name : 'My Base', listenedSignalID : 'EVENT_BASE_REACHED', listenedSignalIDMapping : 'SIGNAL_TOGGLE'},
		 * 				{name : 'My Entity B', listenedSignalID : 'mySignalID', listenedSignalIDMapping : 'myEntityHandleSignalID'},
		 * 				{name : 'My Entity C', listenedSignalID : 'mySignalID', listenedSignalIDMapping : 'myEntityHandleSignalID'}
		 * 			],
		 * 		'myEntitySignalID':[
		 * 			'SIGNAL_TOGGLE',
		 * 			...
		 * 		]
		 *	}
     */
    public function signal2Entity(name : String, params : Object = null)
    {
        super(name, params);
        _signalIDMapping = new Dictionary();
    }

    private var _signalIDMapping : Dictionary;

    /**
     * Map external signal ID define by params constructor to an element of _myEntitySignalID property
     * */
    private var _myEntitySignalID : Array;

    public function get myEntitySignalID() : Array
    {
        return _myEntitySignalID;
    }

    /**
     * Define on which signal IDs a dispatcher signal ID can be map on
     *
     * Before doing affection, we check if new signal IDs can handle
     * existing listening settings (comp2ListenFor && entity2ListenFor properties) to avoid
     * regression in listening handling
     *
     */
    public function set myEntitySignalID(value : Array) : void
    {
        _myEntitySignalID = value;
    }

    override public function initialize(poolObjectParams : Object = null) : void
    {
        _signalIDMapping = new Dictionary();
        _compListenForCallBack = listenerCallBack;
        _entityListenForCallBack = listenerCallBack;

        super.initialize(poolObjectParams);
    }

    /**
     *
     * Override default behavior to create signalId mapping
     *
     * @param    poolObjectParams
     */
    override public function postInitialize(poolObjectParams : Object = null) : void
    {
        var obj : Object;
        //Listen for components
        for each(obj in comp2ListenFor) {
            if (_signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)] != null) {
                throw(new Error('Signal mapping conflict: ' + createSignalSignature(obj.name, obj.listenedSignalID) + ' is already map to ' + _signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)]));
            }
            _signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)] = obj.listenedSignalIDMapping;
        }

        //Listen for entities
        for each(obj in entity2ListenFor) {
            if (_signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)] != null) {
                throw(new Error('Signal mapping conflict: ' + createSignalSignature(obj.name, obj.listenedSignalID) + ' is already map to ' + _signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)]));
            }
            _signalIDMapping[createSignalSignature(obj.name, obj.listenedSignalID)] = obj.listenedSignalIDMapping;
        }

        super.postInitialize(poolObjectParams);
    }

    override public function destroy() : void
    {
        _signalIDMapping = null;
        _myEntitySignalID = null;
        super.destroy();
    }

    private function listenerCallBack(data : SignalObject) : void
    {
        IMelonEntity(parent).onSignal(mapToNewSignalObject(data));
    }

    /**
     * Process an existing signalObject to produce a new one
     * by applying signal ID mapping
     *
     **/
    private function mapToNewSignalObject(data : SignalObject) : SignalObject
    {
        return new SignalObject(data.dispatcher, _signalIDMapping[createSignalSignature(data.dispatcher.name, data.signalID)], data.extra);
    }

    private function createSignalSignature(dispatcherName : String, signalID : String) : String
    {
        return dispatcherName + '__' + signalID;
    }

}

}