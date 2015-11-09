/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.system {
import citrus.system.IEntity;

import melon.message.ISignalObject;

public interface IMelonEntity extends IMelonComponent, IEntity {

    /**
     * Process a signal transmitted via a signal2Entity component
     * Must be implemented in child class
     *
     * To change method behavior, you can test data.signalID or/and use data.dispatcher.entity
     * to define if signal source is an internal or external(component of another entity) component
     *
     * @param    data
     *
     * @see Signal2Entity
     * @see ISignalDispatcher
     * @see AbstractSignalSuscriber
     * @see ASignalDispatcher
     */
    function onSignal(data : ISignalObject) : void;
}
}
