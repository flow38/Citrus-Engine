/**
 * Created by Florent on 12/11/2015.
 */
package melon.command {
import flash.events.Event;

import mockolate.partial;

import mockolate.prepare;
import mockolate.received;

import org.flexunit.assertThat;

import org.flexunit.async.Async;

public class MelonCommandInvokerTest {

    private var _invoker : MelonCommandInvoker;
    public function MelonCommandInvokerTest()
    {
    }

    [Before(async, timeout=5000, order=1)]
    public function setUp() : void
    {
        Async.proceedOnEvent(this,
                prepare(MelonCommand),
                Event.COMPLETE);

    }

    [Before(order=2)]
    public function setup() : void
    {
        _invoker = new MelonCommandInvoker('fooCommandInvoker');
    }

    [After]
    public function tearDown() : void
    {

    }

    [Test]
    /**
     * All invoker commands must be destroy when resetting invoker
     */
    public function testReset() : void
    {
        var cmd1 : MelonCommand = partial(MelonCommand, null, ['cmd1']);
        var cmd2 : MelonCommand = partial(MelonCommand, null, ['cmd2']);
        var cmd3 : MelonCommand = partial(MelonCommand, null, ['cmd3']);
        var cmd4 : MelonCommand = partial(MelonCommand, null, ['cmd4']);

        _invoker.executeCommand(cmd1);
        _invoker.executeCommand(cmd2);
        _invoker.executeCommand(cmd3);
        _invoker.executeCommand(cmd4);

        _invoker.reset();
        assertThat(cmd1, received().once().method('destroy'));
        assertThat(cmd2, received().once().method('destroy'));
        assertThat(cmd3, received().once().method('destroy'));
        assertThat(cmd4, received().once().method('destroy'));
    }

    [Test]
    public function testExecuteCommand() : void
    {
        var cmd1 : MelonCommand = partial(MelonCommand, null, ['cmd1']);
        var cmd2 : MelonCommand = partial(MelonCommand, null, ['cmd2']);
        var cmd3 : MelonCommand = partial(MelonCommand, null, ['cmd3']);

        _invoker.executeCommand(cmd1);
        _invoker.executeCommand(cmd2);
        _invoker.executeCommand(cmd3);

        assertThat(cmd1, received().once().method('execute'));
        assertThat(cmd2, received().once().method('execute'));
        assertThat(cmd3, received().once().method('execute'));
    }

    [Test]
    public function testCancelLastCommands() : void
    {
        var cmd1 : MelonCommand = partial(MelonCommand, null, ['cmd1']);
        var cmd2 : MelonCommand = partial(MelonCommand, null, ['cmd2']);
        var cmd3 : MelonCommand = partial(MelonCommand, null, ['cmd3']);
        var cmd4 : MelonCommand = partial(MelonCommand, null, ['cmd4']);

        _invoker.executeCommand(cmd1);
        _invoker.executeCommand(cmd2);
        _invoker.executeCommand(cmd3);
        _invoker.executeCommand(cmd4);

        //cancel cmd4
        _invoker.cancelLastCommands();
        //cancel cmd3 & cmd2
        _invoker.cancelLastCommands(2);

        assertThat(cmd1, received().never().method('cancel'));
        assertThat(cmd2, received().once().method('cancel'));
        assertThat(cmd3, received().once().method('cancel'));
        assertThat(cmd4, received().once().method('cancel'));
    }
}
}
