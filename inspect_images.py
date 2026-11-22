import os
from PIL import Image

char_dir = "frontend/public/character"
for f in os.listdir(char_dir):
    if f.startswith("red_"):
        im = Image.open(os.path.join(char_dir, f))
        print(f, im.size, im.mode)
