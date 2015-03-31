package royalshield.textures
{
    import flash.display.BitmapData;
    
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.geom.Rect;
    import royalshield.utils.isNullOrEmpty;
    
    public class SpriteSheet extends BitmapData
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_rectList:Vector.<Rect>;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get rectList():Vector.<Rect> { return m_rectList; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function SpriteSheet(width:int, height:int, rectList:Vector.<Rect>)
        {
            super(width, height, true, 0x00000000);
            
            if (isNullOrEmpty(rectList))
                throw new NullOrEmptyArgumentError("rectList");
            
            m_rectList = rectList;
        }
    }
}
