package royalshield.combat
{
    public class MatrixArea
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_centerX:uint;
        private var m_centerY:uint;
        private var m_columns:uint;
        private var m_rows:uint;
        private var m_data:Vector.<Vector.<Boolean>>;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get centerX():uint { return m_centerX; }
        public function get centerY():uint { return m_centerY; }
        public function get columns():uint { return m_columns; }
        public function get rows():uint { return m_rows; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MatrixArea(columns:uint, rows:uint)
        {
            m_columns = columns;
            m_rows = rows;
            m_data = new Vector.<Vector.<Boolean>>(m_rows, true);
            
            for (var i:uint = 0; i < m_rows; i++)
                m_data[i] = new Vector.<Boolean>(m_columns, true);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function getValue(column:uint, row:uint):Boolean
        {
            return m_data[row][column];
        }
        
        public function setValue(column:uint, row:uint, value:Boolean):void
        {
            m_data[row][column] = value;
        }
        
        public function setCenter(x:uint, y:uint):void
        {
            m_centerX = x;
            m_centerY = y;
        }
    }
}
