# Source: https://www.geeksforgeeks.org/python-pil-image-resize-method/ & https://stackoverflow.com/questions/273946/how-do-i-resize-an-image-using-pil-and-maintain-its-aspect-ratio
import utils
from PIL import Image

size = (512, 512)
input_dir = "../input/"
output_dir = "../input/"
inp_img_path = input_dir+"input_org.jpg"
out_img_path = output_dir+"input.jpg"

try:
    im = Image.open(inp_img_path)
    print(im.size)
    # im.thumbnail(size, Image.ANTIALIAS)
    im_new = im.resize(size)
    im_new.save(out_img_path, "JPEG")
    print(im_new.size)
except IOError:
    print("cannot create thumbnail for '{:}'".format(inp_img_path))