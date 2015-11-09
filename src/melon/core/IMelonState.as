package melon.core {
import citrus.core.IState;

/**
 * IMelonState add some feature to IState
 *
 * Comitting state: purpose is calling postInitialization on all existing IMelonObject.
 *
 */
public interface IMelonState extends IState {

    function postInitializeAllObjects() : void;
}
}
