import numpy as np

# Hue ranges
red_lower1 = 106
red_upper1 = 150
red_lower2 = 106
red_upper2 = 150
green_lower = 106
green_upper = 150
blue_lower = 106
blue_upper = 150

# Saturation ranges
lower_saturation = 107
upper_saturation = 255

# Value (brightness) ranges
lower_value = 64
upper_value = 255

# Masks
# Red 1
lower_red1 = np.array([red_lower1, lower_saturation, lower_value])
upper_red1 = np.array([red_upper1, upper_saturation, upper_value])
# Red 2
lower_red2 = np.array([red_lower2, lower_saturation, lower_value])
upper_red2 = np.array([red_upper2, upper_saturation, upper_value])
# Green
lower_green = np.array([green_lower, lower_saturation, lower_value])
upper_green = np.array([green_upper, upper_saturation, upper_value])
# Blue
lower_blue = np.array([blue_lower, lower_saturation, lower_value])
upper_blue = np.array([blue_upper, upper_saturation, upper_value])

square_variance = 0.3
