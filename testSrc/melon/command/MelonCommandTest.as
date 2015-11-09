/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.command {
public class MelonCommandTest {
    public function MelonCommandTest()
    {
    }

    [Before]
    public function setUp() : void
    {
        trace('setUp');
    }

    [After]
    public function tearDown() : void
    {
        trace('tearDown');
    }

    [Test]
    public function testCancel() : void
    {
        trace('testCancel');
    }

    [Test]
    public function testExecute() : void
    {
        trace('testExecute');
    }
}
}
