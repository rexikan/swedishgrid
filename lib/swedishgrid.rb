class SwedishGrid
  
  def initialize(grid)
    case grid
    when :rt90
      # rt90_2.5_gon_v
      @axis = 6378137.0
      @flattening = 1.0 / 298.257222101
      @central_meridian = 15.806284529
      @lat_of_origin = 0.0
      @scale = 1.00000561024
      @false_northing = -667.711
      @false_easting = 1500064.274 
    when :sweref99tm
      @axis = 6378137.0
      @flattening = 1.0 / 298.257222101
      @central_meridian = 15.00 
      @lat_of_origin = 0.0
      @scale = 0.9996
      @false_northing = 0.0
      @false_easting = 500000.0
    else
      raise "Unknown grid"
    end
  end

  # Conversion from grid coordinates to geodetic coordinates.
  def grid_to_geodetic(x, y)
    # Prepare ellipsoid-based stuff.
    e2 = @flattening * (2.0 - @flattening)
    n = @flattening / (2.0 - @flattening)
    a_roof = @axis / (1.0 + n) * (1.0 + n*n/4.0 + n*n*n*n/64.0)
    delta1 = n/2.0 - 2.0*n*n/3.0 + 37.0*n*n*n/96.0 - n*n*n*n/360.0
    delta2 = n*n/48.0 + n*n*n/15.0 - 437.0*n*n*n*n/1440.0
    delta3 = 17.0*n*n*n/480.0 - 37*n*n*n*n/840.0  
    delta4 = 4397.0*n*n*n*n/161280.0

    astar = e2 + e2*e2 + e2*e2*e2 + e2*e2*e2*e2
    bstar = -(7.0*e2*e2 + 17.0*e2*e2*e2 + 30.0*e2*e2*e2*e2) / 6.0
    cstar = (224.0*e2*e2*e2 + 889.0*e2*e2*e2*e2) / 120.0
    dstar = -(4279.0*e2*e2*e2*e2) / 1260.0

    # Convert.
    deg_to_rad = Math::PI / 180  
    lambda_zero = @central_meridian * deg_to_rad
    xi = (x - @false_northing) / (@scale * a_roof)
    eta = (y - @false_easting) / (@scale * a_roof)
    xi_prim = xi - 
            delta1*Math.sin(2.0*xi) * Math.cosh(2.0*eta) - 
            delta2*Math.sin(4.0*xi) * Math.cosh(4.0*eta) - 
            delta3*Math.sin(6.0*xi) * Math.cosh(6.0*eta) - 
            delta4*Math.sin(8.0*xi) * Math.cosh(8.0*eta)  
    eta_prim = eta - 
            delta1*Math.cos(2.0*xi) * Math.sinh(2.0*eta) - 
            delta2*Math.cos(4.0*xi) * Math.sinh(4.0*eta) - 
            delta3*Math.cos(6.0*xi) * Math.sinh(6.0*eta) - 
            delta4*Math.cos(8.0*xi) * Math.sinh(8.0*eta)  
    phi_star = Math.asin(Math.sin(xi_prim) / Math.cosh(eta_prim))  
    delta_lambda = Math.atan(Math.sinh(eta_prim) / Math.cos(xi_prim))
    lng_radian = lambda_zero + delta_lambda  
    lat_radian = phi_star + Math.sin(phi_star) * Math.cos(phi_star) *
            (astar + 
             bstar*(Math.sin(phi_star) ** 2) + 
             cstar*(Math.sin(phi_star) ** 4) + 
             dstar*(Math.sin(phi_star) ** 6))
    return [lat_radian * 180.0 / Math::PI, lng_radian * 180.0 / Math::PI]
  end

  # Conversion from geodetic coordinates to grid coordinates.
  def geodetic_to_grid(latitude, longitude)
    # Prepare ellipsoid-based stuff.
    e2 = @flattening * (2.0 - @flattening)
    n = @flattening / (2.0 - @flattening)
    a_roof = @axis / (1.0 + n) * (1.0 + n*n/4.0 + n*n*n*n/64.0)
    a = e2
    b = (5.0*e2*e2 - e2*e2*e2) / 6.0
    c = (104.0*e2*e2*e2 - 45.0*e2*e2*e2*e2) / 120.0
    d = (1237.0*e2*e2*e2*e2) / 1260.0
    beta1 = n/2.0 - 2.0*n*n/3.0 + 5.0*n*n*n/16.0 + 41.0*n*n*n*n/180.0
    beta2 = 13.0*n*n/48.0 - 3.0*n*n*n/5.0 + 557.0*n*n*n*n/1440.0
    beta3 = 61.0*n*n*n/240.0 - 103.0*n*n*n*n/140.0
    beta4 = 49561.0*n*n*n*n/161280.0

    # Convert.
    deg_to_rad = Math::PI / 180.0
    phi = latitude * deg_to_rad
    lambda = longitude * deg_to_rad
    lambda_zero = @central_meridian * deg_to_rad

    phi_star = phi - Math.sin(phi) * Math.cos(phi) * (a + 
            b*(Math.sin(phi) ** 2) +
            c*(Math.sin(phi) ** 4) +
            d*(Math.sin(phi) ** 6))
    delta_lambda = lambda - lambda_zero
    xi_prim = Math.atan(Math.tan(phi_star) / Math.cos(delta_lambda))
    eta_prim = Math.atanh(Math.cos(phi_star) * Math.sin(delta_lambda))
    x = @scale * a_roof * (xi_prim +
            beta1 * Math.sin(2.0*xi_prim) * Math.cosh(2.0*eta_prim) +
            beta2 * Math.sin(4.0*xi_prim) * Math.cosh(4.0*eta_prim) +
            beta3 * Math.sin(6.0*xi_prim) * Math.cosh(6.0*eta_prim) +
            beta4 * Math.sin(8.0*xi_prim) * Math.cosh(8.0*eta_prim)) +
            @false_northing
    y = @scale * a_roof * (eta_prim +
            beta1 * Math.cos(2.0*xi_prim) * Math.sinh(2.0*eta_prim) +
            beta2 * Math.cos(4.0*xi_prim) * Math.sinh(4.0*eta_prim) +
            beta3 * Math.cos(6.0*xi_prim) * Math.sinh(6.0*eta_prim) +
            beta4 * Math.cos(8.0*xi_prim) * Math.sinh(8.0*eta_prim)) +
            @false_easting
    return [(x * 1000.0).round / 1000.0, (y * 1000.0).round / 1000.0]
  end
  
end
