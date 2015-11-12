/**
 * Created by Florent on 12/11/2015.
 */
package melon.command {
import melon.core.IMelonObject;

public interface IMelonCommandInvoker extends IMelonObject {
    function executeCommand(cmd : ICommand) : void;

    function cancelLastCommands(howMany : uint = 1) : void;
}
}
