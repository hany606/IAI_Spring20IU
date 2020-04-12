import utils
from PIL import Image

def resize():
    size = (512, 512)
    input_dir = "../input/"
    output_dir = "../input/"
    inp_img_path = input_dir+"input2_org.jpg"
    out_img_path = output_dir+"input2.png"

    img = Image.open(inp_img_path)
    print(img.size)
    img_new = img.resize(size)
    utils.write_img(out_img_path, img_new)
    print(img_new.size)

def to_bw():
    input_dir = "../input/"
    output_dir = "../input/"
    inp_img_path = input_dir+"input2.png"
    out_img_path = output_dir+"input2_bw.png"

    img = Image.open(inp_img_path)
    # img_np = utils.to_numpy(img)
    # print(img_np[0])
    img_bw = img.convert('1')
    utils.write_img(out_img_path, img_bw)
    utils.preview_img(img_bw)
    # img_np = utils.to_numpy(img_bw)
    # print(img_np[0])


if __name__ == "__main__":
    to_bw()