/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.command {
import melon.core.IMelonObject;

public interface ICommand extends IMelonObject {

    function get isCancelable() : Boolean;

    function set isCancelable(value : Boolean) : void;

    function execute() : void;

    function cancel() : void;

    /**
     * Add a command to execute after completing this one
     *
     * @param    next
     * @return
     */
    function chain(next : ICommand) : ICommand

    /**
     * Define a callback function to be execute when command ending
     * @param    value    End command execution callback
     */
    function onComplete(value : Function) : ICommand;


    /**
     * Define a callback function to be execute when command's cancelling is done
     * @param    value    End command execution callback
     */
    function onCancel(value : Function) : ICommand;

    /**
     * Define a callback function to be execute when command ending or cancelling
     * Basically a shortcut when you wanna same callback function to be call
     * when command is complete or is canceled
     *
     * @param    value    End command execution callback
     */
    function onCompleteOrCancel(callback : Function) : ICommand;
}
}
