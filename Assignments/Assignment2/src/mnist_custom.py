# Source: https://www.geeksforgeeks.org/python-pil-image-resize-method/ & https://stackoverflow.com/questions/273946/how-do-i-resize-an-image-using-pil-and-maintain-its-aspect-ratio
import utils
from PIL import Image
import numpy as np

def resize():
    size = (8, 8)
    # input_dir = "../input/"
    input_dir = "../assets/mnist_png/mnist_png/testing/All/"
    output_dir = "../assets/mnist_png/mnist_png/testing/All_resized8x8/"
    for i in range(10000):
        inp_img_path = input_dir+"{:}.png".format(i)
        img = Image.open(inp_img_path)
        # print(img.size)
        img_new = img.resize(size)
        out_img_path = output_dir+"{:}.png".format(i)
        img_new.save(out_img_path, "PNG")
        # print(img_new.size)

# change some of the pictures to only black
def changer():
    input_dir = "../assets/mnist_png/mnist_png/testing/All_resized8x8/"
    output_dir = "../assets/mnist_png/mnist_png/testing/All_resized8x8/"
    for _ in range(100):
        idx = np.random.randint(10000)
        inp_img_path = input_dir+"{:}.png".format(idx)
        img = Image.open(inp_img_path)
        img_np = utils.to_numpy(img)
        img_np[:,:] = 0
        img_new = utils.to_img(img_np)
        out_img_path = output_dir+"{:}.png".format(idx)
        img_new.save(out_img_path, "PNG")
        # print(im_new.size)




if __name__ == "__main__":
    # changer()
    pass