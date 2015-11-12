package melon.system.component.messaging {
import citrus.system.IEntity;

import melon.system.MelonComponent;

/**
 * In charge of:
 * - Listen at other components/entities signal dispatching
 * - Handling signal by calling callback(_compListenForCallBack & _entityListenForCallBack)
 *
 * Reponsability of stopping to listen at all listened ISignalDispatcher depend of use cas:
 * - Level/State destroy : responsibility is on ISignalDispatcher instances
 * - ASignalSuscriber live listener setting modification (via levelEditor and its StartListen or StopListen Command for example): responsibility is on
 *   ASignalSuscriber instance via its reset() method!
 *
 * @see Signal2Entity
 * @author ffalcy
 */
public class ASignalSuscriber extends MelonComponent {
    public function ASignalSuscriber(name : String, params : Object = null)
    {
        super(name, params);
        //Abstract class implementation
        if (Object(this).constructor === ASignalSuscriber) {
            throw new Error("AbstractAcrossEntity class must not be directly instantiated");
        }
    }

    protected var _compListenForCallBack : Function;
    protected var _entityListenForCallBack : Function;

    /**
     * Parent components to listen at
     * Each array item is an object: {name : 'MyComp', listenedSignalID : 'mySignalID'}
     */
    private var _comp2ListenFor : Array = new Array();

    public function get comp2ListenFor() : Array
    {
        return _comp2ListenFor;
    }

    public function set comp2ListenFor(value : Array) : void
    {
        _comp2ListenFor = value;
    }

    /**
     * Entity we had to listen For
     * Each array item is an object: {name : 'MySwitcherEntity', listenedSignalID : 'mySignalID'}
     */
    private var _entity2ListenFor : Array = new Array();

    public function get entity2ListenFor() : Array
    {
        return _entity2ListenFor;
    }

    public function set entity2ListenFor(value : Array) : void
    {
        _entity2ListenFor = value;
    }

    override public function postInitialize(poolObjectParams : Object = null) : void
    {
        var obj : Object;
        //Listen for components
        for each(obj in _comp2ListenFor) {
            ISignalDispatcher(parent.lookupComponentByName(obj.name)).listenFor(obj.listenedSignalID, _compListenForCallBack);
        }

        //Listen for entities
        for each(obj in _entity2ListenFor) {
            var _targetEntity : IEntity = injector.state.getObjectByName(obj.name) as IEntity;
            ISignalDispatcher(_targetEntity).listenFor(obj.listenedSignalID, _entityListenForCallBack);
        }

        super.postInitialize(poolObjectParams);
    }

    override protected function clean() : void
    {
        var obj : Object;
        //Stop all Listeners
        for each(obj in _comp2ListenFor) {
            ISignalDispatcher(parent.lookupComponentByName(obj.name)).stopListenFor(obj.listenedSignalID, _compListenForCallBack);
        }

        for each(obj in _entity2ListenFor) {
            var _targetEntity : IEntity = injector.state.getObjectByName(obj.name) as IEntity;
            ISignalDispatcher(_targetEntity).stopListenFor(obj.listenedSignalID, _entityListenForCallBack);
        }
        //reload params object
        super.clean();
    }

}

}