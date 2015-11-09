/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.message {
import citrus.system.IEntity;

public interface ISignalObject {
    /**
     * Entity on which belong the ASignalDispatcher instance which
     * have dispatch signal
     */
    function get dispatcher() : IEntity;

    function get signalID() : String;

    function get extra() : Object;

    function set extra(value : Object) : void;
}
}
