package royalshield.utils
{
    [Inline]
    public function isNullOrEmpty(object:Object):Boolean
    {
        return (object == null || (object.hasOwnProperty("length") && object.length == 0));
    }
}
