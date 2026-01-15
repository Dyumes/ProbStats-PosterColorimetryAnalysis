using Colors, CSV, DataFrames, StatsBase, Plots
module ColorUtils

export getColor, getLightness, colors_list, colors_map

# https://medium.com/@dijdomv01/a-beginners-guide-to-understand-the-color-models-rgb-and-hsv-244226e4b3e3
# https://learn.leighcotnoir.com/artspeak/elements-color/hue-value-saturation/

"""Defines the color ranges that are returned by `getColor` function"""
hue_colors = Dict(
    "red"           => [(-1, 15), (360 - 15, 361)],
    "orange"        => (15, 45),
    "yellow"        => (45, 75),
    "light_green"   => (75, 105),
    "green"         => (105, 135),
    "cyan_green"    => (135, 165),
    "cyan"          => (165, 195),
    "light_blue"    => (195, 225),
    "blue"          => (225, 255),
    "purple"        => (255, 285),
    "magenta"       => (285, 315),
    "pink"          => (315, 345)
    # grey
    # black
    # white
)

"""
Returns the color name based on its HSV values.  
`h` = Hue (0° to 360°)  
`s` = Saturation (0 to 1)  
`v` = Value (0 to 1)  
"""
function getColor(h::Number, s::Number, v::Number)::String
    grey_sat_threshold = 0.05 # If saturation is lower than this, consider it as gray
    grey_val_threshold = 0.65 # If value is lower than this, consider it as gray

    black_val = 0.1           # If value is lower (<=) than this, consider it as black

    white_val = 0.8           # If value is higher (>=) than this, consider it as white
    white_sat = 0.05          # If saturation is lower (<=) than this, consider it as white

    # 
    found_color = "None"
    if (v <= black_val)
        return "black"
    elseif (s <= white_sat && v >= white_val)
        return "white"
    end

    # Check if color is gray
    if (s <= grey_sat_threshold && v <= grey_val_threshold)
        return "grey"
    end
    
    # Find closest color
    for (name, hue_range) in hue_colors
        # Verify if color has multiple ranges (if is array, has multiple color ranges)
        if (hue_range isa Array)
            for hr in hue_range
                if (h > hr[1] && h <= hr[2])
                    found_color = name
                end
            end
        elseif (h > hue_range[1] && h <= hue_range[2])
            found_color = name
        end
    end

    if (found_color == "None")
        error("Color not found for H: $h, S: $s, V: $v")
    end
    
    return found_color
end

function getLightness(h::Number, s::Number, v::Number)::String
    THRESHOLD = 0.5

    if (v > THRESHOLD)
        return "light"
    else
        return "dark"
    end
end

"""
Test function to test module functions
"""
function testColors()
    # Black and White tests
    @assert getColor(125, 0, 0) == "black"
    @assert getColor(125, 0, 0) != "white"
    @assert getColor(165, 0, 1) == "white"
    @assert getColor(165, 0, 0.9) == "white"
    
    # Gray tests
    @assert getColor(225, 0.05, 0.40) == "grey"
    @assert getColor(45, 0.02, 0.42) == "grey"
    @assert getColor(225, 0, 0.80) == "white"

    # Full colors tests
    @assert getColor(360, 1, 1) == "red"
    @assert getColor(12, 1, 1) == "red"
    @assert getColor(17, 1, 1) == "orange"
    @assert getColor(160, 1, 1) == "cyan_green"
    @assert getColor(225, 1, 1) != "blue"
    @assert getColor(224.24, 1, 1) != "blue"

    # Light Dark colors
    @assert getLightness(255, 0, 0) == "dark"
    @assert getLightness(255, 0, 1) == "light"

    println("All tests passed!")
end

# println(getColor(270, 1, 0))

# testColors()

"""Colors names orderd for plotting visual"""
colors_list = ["yellow","orange","red","pink","magenta","purple","blue","light_blue","cyan","cyan_green","green","light_green","black","grey","white"]
"""Give a color to the color name for plotting visual"""
colors_map = Dict(
        "yellow" => "#FFFF00",    
        "orange" => "#FF8000",     
        "red" => "#FF0000",        
        "pink" => "#FF0080",  
        "magenta" => "#FF00FF",
        "purple" => "#8000FF",
        "blue" => "#0000FF",
        "light_blue" => "#0080FF", 
        "cyan" => "#00FFFF",  
        "cyan_green" => "#00FF80", 
        "green" => "#00FF00",
        "light_green" => "#80FF00", 
        "black" => "#000000",     
        "grey" => "#808080",      
        "white" => "#FFFFFF"      
    )




end # end module ColorUtils