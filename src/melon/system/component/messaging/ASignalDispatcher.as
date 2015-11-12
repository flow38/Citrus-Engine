package melon.system.component.messaging {
import flash.utils.Dictionary;

import melon.message.SignalObject;
import melon.system.MelonComponent;

import org.osflash.signals.Signal;

/**
 * A component specialized in dispatching events (aka signal)
 *
 *
 * @author ffalcy
 */
public class ASignalDispatcher extends MelonComponent implements ISignalDispatcher {
    public static const NAME : String = 'signalDisptacherComponent';

    /**
     *
     * @param    name    MelonComponent name
     * @param    params    Use this parameter to give a list of signal that must
     *                    be instanciated
     */
    public function ASignalDispatcher(name : String = NAME, params : Object = null)
    {
        _signals = new Dictionary();
        super(name, params);
    }

    private var _signals : Dictionary;

    /**
     *  Signals name list you want to register via initialize method
     *
     **/
    public function get registeredSignals() : Array
    {
        var registeredSignals : Array = new Array();
        for (var signalID : * in _signals) {
            registeredSignals.push(signalID);
        }

        return registeredSignals;
    }

    public function set registeredSignals(value : Array) : void
    {
        //Delete all existing registered signals
        unregisterAllSignals();
        //Register new signal
        for each(var signalID : String in value) {
            registerSignal(signalID);
        }
    }

    override public function initialize(poolObjectParams : Object = null) : void
    {
        super.initialize(poolObjectParams);
    }

    override protected function clean() : void
    {
        unregisterAllSignals();
        _signals = null;
        super.clean();
    }

    /**
     * Register a new Signal instance giving a unique ID
     *
     * Is public to allow signal registering staticly
     * (vs dynamicly using params.registeredSignals property in constructor)
     *
     * Beware of not call this method in parent entity constructor!! Because initialization workflow
     * will clear _signal Dictionnary when registeredSignals sette will be call in CitrusObject::setParams()
     *
     * @param    ID        Signal ID
     * @return
     */
    public function registerSignal(ID : String) : Boolean
    {
        if (_signals[ID] == null) {
            _signals[ID] = new Signal(SignalObject);
        } else {
            throw('Signal named ' + ID + 'already registered !');
        }

        return true;
    }

    /**
     * Unregister a Signal instance giving a unique ID
     *
     * @param    ID
     * @return
     */
    public function unregisterSignal(ID : String) : Boolean
    {
        var res : Boolean = false;
        var signal : Signal = _signals[ID];
        if (signal !== null) {
            signal.removeAll();
            delete _signals[ID];
            res = true;
        }

        return res;
    }

    /**
     * Unregister all existing Signal instances
     *
     * All listeners are removed
     *
     * @return
     */
    public function unregisterAllSignals() : void
    {
        for (var index : * in _signals) {
            unregisterSignal(index);
        }
    }

    public function dispatchSignal(ID : String, extraData : Object = null) : void
    {
        var data : SignalObject = new SignalObject(parent, ID, extraData);
        getSignal(ID).dispatch(data);
    }

    public function listenFor(ID : String, callBack : Function) : void
    {
        var signal : Signal = _signals[ID];
        if (signal == null) {
            throw new Error('"' + ID + '" ID is unknown !! Please check your signalID parameter !');
        }

        signal.add(callBack);
    }

    public function stopListenFor(ID : String, callBack : Function) : void
    {
        var signal : Signal = _signals[ID];
        if (signal == null) {
            throw new Error('"' + ID + '" ID is unknown !! Please check your signalID parameter !');
        }

        signal.remove(callBack);
    }

    private function getSignal(ID : String) : Signal
    {
        try {
            return Signal(_signals[ID]);
        } catch (e : Error) {
            throw('Signal named ' + ID + ' cannot be resolved : ' + e.message);
        }
        return null;
    }

}

}