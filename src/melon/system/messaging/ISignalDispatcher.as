package melon.system.messaging {

/**
 * ...
 * @author
 */
public interface ISignalDispatcher {
    function get registeredSignals() : Array;

    function set registeredSignals(value : Array) : void;

    /**
     * Suscribing to a specific signal
     * @param    signalID
     */
    function listenFor(signalID : String, callBack : Function) : void;

    function stopListenFor(signalID : String, callBack : Function) : void;

}

}