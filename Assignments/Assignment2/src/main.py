from EA import EA
import utils
import numpy as np

input_dir = "../input/"
output_dir = "../output/"
assets_dir = "../assets/mnist_png/mnist_png/testing/All_resized8x8/"
inp_img_path = input_dir+"input.jpg"
out_img_path = output_dir+"output.jpg"
out_gif_path = output_dir+"output.git"

# --------------- Testing ------------------

# img = utils.read_img(assets_dir+"0.png")
# img_np = utils.to_numpy(img)
# print(img_np[2])
# print(img_np.shape)

imgs = []
for i in range(10000):
    img = utils.read_img(assets_dir+"{:}.png".format(i))
    img_np = utils.to_numpy(img)
    imgs.append(img_np)

print("--------------------")
indexes = []
for i in range(64):
    indexes.append([np.random.randint(10000) for i in range(64)])

imgt = utils.Image(imgs=imgs, index=indexes)

img = imgt.construct_img()

img = utils.to_img(img)

print(img.size)
utils.preview_img(img)




# ------------------------------------------

# img = utils.read_img(inp_img_path)
# utils.preview_img(img)
# utils.write_img(out_img_path, img)

# algo = EA(img)

# progress_imgs, out_img = algo.train()

# utils.preview_img(out_img)
# utils.create_gif(out_gif_path, progress_imgs)
# utils.write_img(out_img_path, out_img)