package melon.service.math {
/**
 * Math operation utils
 * @author
 */
public class MelonMathUtils {

    /**
     * Convert an angle express between PI & -PI (ie vector rotation in nape)
     * to a angle express in clockwise angle
     * @param    angle
     * @return Number
     */
    public static function vectorAngleToClockwiseRadian(angle : Number) : Number
    {
        if (angle < -Math.PI) {
            angle += (Math.PI * 2);
            angle = -angle;
        } else if (angle > Math.PI) {
            angle -= (Math.PI * 2);
            angle = -angle;
        }


        return angle;
    }

    /**
     * Clamp a value between min and max
     * @return Number
     **/
    public static function clamp(value : Number, min : Number, max : Number) : Number
    {
        if (value < min) {
            value = min;
        } else if (value > max) {
            value = max;
        }

        return value;
    }

    public static function roundDecimal(num : Number, precision : int) : Number
    {

        var decimal : Number = Math.pow(10, precision);

        return Math.round(decimal * num) / decimal;

    }

    /**
     * Custom modulo implementation where result have same sign
     * than divisor
     *
     * http://stackoverflow.com/questions/1878907/the-smallest-difference-between-2-angles
     *
     **/
    public static function modulo(dividend : Number, divisor : Number) : Number
    {
        return (dividend % divisor + divisor) % divisor;
    }

    /**
     * .Net Math Truncate implementation
     * truncate(-0.75) => 0
     * truncate(0.75) => 0
     * truncate(-1.75) => -1
     * truncate(1.75) => 1
     * */
    public static function truncate(value : Number) : Number
    {
        if (value <= 0) {
            return Math.ceil(value);
        } else {
            return Math.floor(value);
        }
    }

    /**
     * Nape physic body rotation value convertion to Vec2 rotation value
     *
     * Nape physic body rotation is set according North
     * rotation 0 => North
     * rotation 90 => East
     * rotation -90 => West
     *
     * Dragon Bones armature rotation is set according North
     * rotation 0 => North
     * rotation 90 => East
     * rotation -90 => West
     *
     * ----------------------
     *
     * Vector rotation is set according East
     * rotation 0 => East
     * rotation 90 => South
     * rotation -90 => North
     *
     * DisplayObject rotation is set according East
     * rotation 0 => East
     * rotation 90 => South
     * rotation -90 => North
     *
     *
     * @param    radAngle        A Nape's body rotation value
     * @return                    A Vec2 rotation value
     */
    public static function napeBodyAngle2Vec2Angle(radAngle : Number) : Number
    {
        return radAngle - Math.PI / 2;
    }

    /**
     * Vec2 rotation value convertion to Nape physic body rotation value
     *
     * @param    radAngle        A Vec2 rotation value
     * @return                    A Nape's body rotation value
     */
    public static function vec2Angle2NapeBodyAngle(radAngle : Number) : Number
    {
        return radAngle + Math.PI / 2;
    }

    /**
     * Process an angle rotation to obtain a clamped [Math.PI, -Math.PI] value
     *
     * Use case: angle substraction can lead to angle over 180 or under - 180 degre
     * but we need angle substraction that match [180, -180]
     *
     * @param    radRotation        Radian rotation value
     * @return    clamped [Math.PI, -Math.PI] radian angle
     */
    public static function fixAngleDeltaValue(radRotation : Number) : Number
    {
        radRotation = clampAngle(radRotation);

        if (radRotation < -Math.PI) {
            radRotation += (Math.PI * 2);
        } else if (radRotation > Math.PI) {
            radRotation -= (Math.PI * 2);
        }

        return radRotation;
    }

    /**
     * Clamp a radian angle to [0, Math.PI * 2] value
     *
     * @param    radRotation
     * @return    [0, Math.PI * 2] value
     */
    public static function clampAngle(radRotation : Number) : Number
    {
        return modulo(radRotation, (Math.PI * 2));
    }

    public function MelonMathUtils()
    {

    }
}

}