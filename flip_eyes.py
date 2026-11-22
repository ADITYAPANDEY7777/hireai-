from PIL import Image

im = Image.open("frontend/public/character/red_eyes.png")
im_flipped = im.transpose(Image.FLIP_LEFT_RIGHT)
im_flipped.save("frontend/public/character/red_eyes_flipped.png")
print("Saved red_eyes_flipped.png:", im_flipped.size)
