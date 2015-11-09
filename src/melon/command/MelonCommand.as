/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.command {
public class MelonCommand extends AbstractMelonCommand {

    public function MelonCommand(name : String, params : Object = null)
    {
        super(name, params);
    }


    override public function execute() : void
    {
        //do some stuff...

        //Command is done
        done();
    }

    /**
     * Cancel override should always call super.cancel() !!!
     */
    override public function cancel() : void
    {
        super.cancel();
    }
}
}
