package royalshield.display
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class GameCanvas extends BitmapData
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var useAlphaBitmapData:Boolean;
        
        private var m_rect:Rectangle;
        private var m_point:Point;
        private var m_fillRect:Rectangle;
        private var m_alphaBitmapData:BitmapData;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameCanvas(width:int, height:int)
        {
            super(width, height, true, 0);
            
            m_rect = new Rectangle();
            m_point = new Point();
            m_fillRect = new Rectangle(0, 0, width, height);
            m_alphaBitmapData = new BitmapData(64, 64, true, 0x5FFFFFFF);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function render(source:BitmapData, rx:int, ry:int, rw:int, rh:int, px:int, py:int):void
        {
            m_rect.setTo(rx, ry, rw, rh);
            m_point.setTo(px, py);
            copyPixels(source, m_rect, m_point, useAlphaBitmapData ? m_alphaBitmapData : null, null, true);
        }
        
        public function erase(color:uint = 0xFF000000):void
        {
            fillRect(m_fillRect, color);
        }
    }
}
