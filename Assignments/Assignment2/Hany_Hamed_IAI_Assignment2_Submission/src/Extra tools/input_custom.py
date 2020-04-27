import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from PIL import Image

def resize(input_dir="../../input/",
           output_dir="../../input/",
           input_img_name="input2_org.jpg",
           output_img_name="input2.png"):
    size = (512, 512)
    input_dir = input_dir
    output_dir = output_dir
    inp_img_path = input_dir+input_img_name
    out_img_path = output_dir+output_img_name

    img = Image.open(inp_img_path)
    print(img.size)
    img_new = img.resize(size)
    utils.write_img(out_img_path, img_new)
    print(img_new.size)

def to_bw(input_dir="../../input/",
           output_dir="../../input/",
           input_img_name="input2.png",
           out_img_name="input2_bw.png"):  
    input_dir = input_dir
    output_dir = output_dir
    inp_img_path = input_dir+input_img_name
    out_img_path = output_dir+out_img_name

    img = Image.open(inp_img_path)
    # img_np = utils.to_numpy(img)
    # print(img_np[0])
    img_bw = img.convert('1')
    utils.write_img(out_img_path, img_bw)
    utils.preview_img(img_bw)
    # img_np = utils.to_numpy(img_bw)
    # print(img_np[0])

def to_png(input_dir="../../input/",
           output_dir="../../input/",
           input_img_name="input.jpg",
           output_img_name="input.png"):

    input_dir = input_dir
    output_dir = output_dir
    inp_img_path = input_dir+input_img_name
    out_img_path = output_dir+output_img_name

    img = Image.open(inp_img_path)
    utils.write_img(out_img_path, img)


if __name__ == "__main__":
    to_png(input_img_name="input2_org.jpg",output_img_name="input2.png")
    resize(input_img_name="input2.png",output_img_name="input2.png")
