using CSV, Colors

module RGB_to_HSV
    export RGBtoHSV

    """Returns the HSV values (Hue = [0,255], Saturation = [0,1], Value = [0,1])"""
    function RGBtoHSV(r::Number, g::Number, b::Number)
        r /= 255
        g /= 255
        b /= 255
        maxRGB = max(r, g, b)
        minRGB = min(r, g, b)

        value = maxRGB    # V = Value
        hue = 0.0         # H = Hue
        saturation = 0.0  # S = Saturation, If the value is 0, saturation is 0
        if (value != 0)
            saturation = (maxRGB - minRGB) / maxRGB
        end

        if (maxRGB != 0)
            if (maxRGB == r)
                hue = 60 * 0 + (g - b) / (maxRGB / minRGB)
            elseif (maxRGB == g)
                hue = 60 * 2 + (b - r) / (maxRGB / minRGB)
            else # (maxRGB == b)
                hue = 60 * 4 + (r - b) / (maxRGB / minRGB)
            end
        end

        if (hue < 0)
            hue += 360
        end 

        return (hue, saturation, value)
    end


    # print("HSV value:")
    # print(RGBtoHSV(255, 255, 255))
    # print("\n")

    # print("HSV value:")
    # print(RGBtoHSV(0, 0, 0))
    # print("\n")
end