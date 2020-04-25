# This file include the utilities functions required for the code
from PIL import Image as PImage
import numpy as np

def preview_img(img, title=None):
    if(title is not None):
        img.show(title=title)
    else:
        img.show()

def read_img(img_path):
    img = PImage.open(img_path)
    return img

def to_numpy(img):
    np_img = np.array(img)
    return np_img

def to_img(np_img):
    img = PImage.fromarray(np.uint8(np_img))
    return img
    
def write_img(img_path, img):
    img.save(img_path, "PNG")

def create_gif(gif_path, imgs):
    init_img = imgs[0]
    init_img.save(gif_path, save_all=True, append_images=imgs[1:], duration=40,loop=0)

def read_small_imgs(assets_dir="../../assets/mnist_png/mnist_png/testing/All_resized8x8/", num=10000, format_str=None):
    imgs = []
    for i in range(num):
        if(format_str is None):
            img = read_img(assets_dir+"{:}.png".format(i))
        else:
            img = read_img(assets_dir+format_str.format(i))            
        img_np = to_numpy(img)
        imgs.append(img_np)
    return imgs
    print("--------- Finished reading all the small imgs -----------")


class Image:
    # index and rotation are 64x64 = (512/8 x 512/8) matrix that have the indices of the small images for each
    def __init__(self, imgs, src_path="../../assets/mnist_png/mnist_png/testing/All_resized8x8/",
                index=None, size = (512,512,3), imgs_shape=(8,8,3)):
        self.index = index
        self.src_path = src_path
        self.size = size
        self.imgs_shape = imgs_shape
        self.imgs = imgs
        self.img = np.empty(size)

    def set_index(self,index):
        self.index = index

    def get_index(self):
        return self.index

    def construct_img(self):
        num_rows_small = self.imgs_shape[0]
        num_cols_small = self.imgs_shape[1]
        num_rows = self.size[0]//num_rows_small
        num_cols = self.size[1]//num_cols_small
        for r in range(num_rows):
            r_idx = r*num_rows_small
            r_idx_lim = r_idx + num_rows_small
            for c in range(num_cols):
                c_idx = c*num_cols_small
                c_idx_lim = c_idx + num_cols_small
                # print(r_idx, r_idx_lim)
                # print(c_idx, c_idx_lim)
                # print(r,c)
                img = self.imgs[self.index[r][c]]
                self.img[r_idx:r_idx_lim, c_idx:c_idx_lim,:] = img
        return np.array(self.img)



if __name__ == "__main__":
    pass    