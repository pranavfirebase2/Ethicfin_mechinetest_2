from PIL import Image, ImageDraw, ImageFont
import os

# Create a 512x512 black image
img = Image.new('RGB', (512, 512), color='black')
draw = ImageDraw.Draw(img)

# We will just draw simple shapes if fonts aren't perfectly aligned
# Better yet, let's draw text "TOD" and a red circle with a checkmark
# We will use default font or basic shapes

try:
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 100)
except:
    font = ImageFont.load_default()

# TO
draw.text((70, 200), "TO", fill="white", font=font)
# D
draw.text((220, 200), "D", fill=(249, 91, 86), font=font)

# Circle
draw.ellipse((320, 200, 420, 300), fill=(249, 91, 86))

# Checkmark in circle
draw.line((340, 250, 360, 270), fill="black", width=10)
draw.line((360, 270, 400, 220), fill="black", width=10)

img.save('assets/logo.png')
print("Logo generated at assets/logo.png")
