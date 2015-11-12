/**
 * Created by Florent on 12/11/2015.
 */
package melon.command {
import melon.core.IMelonObject;
import melon.core.MelonObject;

public class MelonCommandInvoker extends MelonObject implements IMelonCommandInvoker {

    private var _commandsStack : Vector.<ICommand>;

    public function MelonCommandInvoker(name : String, params : Object = null)
    {
        super(name, params);
    }

    public function executeCommand(cmd : ICommand) : void
    {
    }

    public function cancelLastCommands(howMany : uint = 1) : void
    {
    }


    override public function initialize(poolObjectParams : Object = null) : void
    {
        super.initialize(poolObjectParams);
    }

    override public function destroy() : void
    {
        super.destroy();
    }
}
}
