import numpy as np
from PIL import Image

# VGA Resolution
WIDTH = 640  # Adjust based on your VGA module
HEIGHT = 480

# Initialize image buffer
image = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)

# Read pixel data
with open("./bin/vga_output.txt", "r") as f:
    for line in f:
        x, y, r, g, b = map(int, line.split())
        if 0 <= x < WIDTH and 0 <= y < HEIGHT:
            image[y, x] = [r, g, b]  # Set pixel color

# Save the image
img = Image.fromarray(image, "RGB")
img.save("vga_output.png")
img.show()  # Open the generated image
