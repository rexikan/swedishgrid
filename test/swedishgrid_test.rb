require "test_helper"

class TestSwedishGrid < Test::Unit::TestCase

  LAT_LNG_TOLERANCE = 1.0e-7
  GRID_TOLERANCE = 0.001

  def setup
    # Points from dokument "Kontrollpunkter" at lantmateritet.se
    # http://www.lantmateriet.se/upload/filer/kartor/geodesi_gps_och_detaljmatning/Transformationer/SWEREF99_RT90_Samband/kontrollpunkter.pdf
    # http://latlong.mellifica.se/
    # WGS 84 and SWEREF 99 are, in principle, interchangeable
    
    @rt90 =       [ [7453389.762, 1727060.905],  
                    [7047738.415, 1522128.637],  
                    [6671665.273, 1441843.186],  
                    [6249111.351, 1380573.079] ]

    @sweref99tm = [ [7454204.638, 761811.242], 
                    [7046077.605, 562140.337],
                    [6669189.376, 486557.055],
                    [6246136.458, 430374.835] ]

    @lat_lng =    [ [67 +  5/60.0 + 26.452769/3600, 21 +  2/60.0 +  5.101575/3600],
                    [63 + 32/60.0 + 14.761735/3600, 16 + 14/60.0 + 59.594626/3600],
                    [60 +  9/60.0 + 33.882413/3600, 14 + 45/60.0 + 28.167152/3600], 
                    [56 + 21/60.0 + 17.199245/3600, 13 + 52/60.0 + 23.754022/3600] ]
                    
  end


  def test_rt90_grid_to_geodetic
    grid = SwedishGrid.new(:rt90)
    (0..3).each do |i|
      coord = grid.grid_to_geodetic(*@rt90[i])
      assert (coord[0] - @lat_lng[i][0]).abs < LAT_LNG_TOLERANCE
      assert (coord[1] - @lat_lng[i][1]).abs < LAT_LNG_TOLERANCE
    end
  end
  
  def test_rt90_geodetic_to_grid
    grid = SwedishGrid.new(:rt90)
    (0..3).each do |i|
      coord = grid.geodetic_to_grid(*@lat_lng[i])
      assert (coord[0] - @rt90[i][0]).abs < GRID_TOLERANCE
      assert (coord[1] - @rt90[i][1]).abs < GRID_TOLERANCE
    end
  end
  
  def test_sweref99tm_grid_to_geodetic
    grid = SwedishGrid.new(:sweref99tm)
    (0..3).each do |i|
      coord = grid.grid_to_geodetic(*@sweref99tm[i])
      assert (coord[0] - @lat_lng[i][0]).abs < LAT_LNG_TOLERANCE
      assert (coord[1] - @lat_lng[i][1]).abs < LAT_LNG_TOLERANCE
    end
  end

  def test_sweref99tm_geodetic_to_grid
    grid = SwedishGrid.new(:sweref99tm)
    (0..3).each do |i|
      coord = grid.geodetic_to_grid(*@lat_lng[i])
      assert (coord[0] - @sweref99tm[i][0]).abs < GRID_TOLERANCE
      assert (coord[1] - @sweref99tm[i][1]).abs < GRID_TOLERANCE
    end
  end
end
