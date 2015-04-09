package royalshield.utils
{
    public function isNullOrEmpty(object:*):Boolean
    {
        if (object == null || object == undefined)
            return true;
        
        if (object is Number)
            return isNaN(object);
        
        return (object.hasOwnProperty("length") && object.length == 0);
    }
}
