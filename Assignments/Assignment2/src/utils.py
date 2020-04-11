# This file include the utilities functions required for the code
from PIL import Image

def preview_img(img):
    img.show()

def read_img(img_path):
    img = Image.open(img_path)
    return img

def write_img(img_path, img):
    img.save(img_path, "JPEG")

def create_gif(gif_path, imgs):
    init_img = imgs[0]
    init_img.save(gif_path, save_all=True, append_images=imgs[1:])

