package melon.message {
import citrus.system.IEntity;

/**
 * Robert Penner's Signal message wrapper for all messaging use case in melon engine (and ideally in your project)
 *
 * @author ffalcy
 */
public class SignalObject implements ISignalObject, ISignalObject {
    public function SignalObject(source : IEntity, ID : String, extra : Object = null)
    {
        _dispatcher = source;
        _signalID = ID;
        _extra = extra;
    }

    /**
     * Entity on which belong the ASignalDispatcher instance which
     * have dispatch signal
     */
    private var _dispatcher : IEntity;

    public function get dispatcher() : IEntity
    {
        return _dispatcher;
    }

    private var _signalID : String;

    public function get signalID() : String
    {
        return _signalID;
    }

    private var _extra : Object;

    public function get extra() : Object
    {
        return _extra;
    }

    public function set extra(value : Object) : void
    {
        _extra = value;
    }

}

}