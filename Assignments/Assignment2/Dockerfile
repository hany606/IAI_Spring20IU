# set the base image
FROM ubuntu:18.04

# author
MAINTAINER Hany Hamed

# extra metadata
LABEL version="0.1"
LABEL description="Assignment 2 IAI course Spring20: Genetic algorithm to reproduce image"

# update sources list
RUN apt-get update -y

# Install the required dependencies
RUN apt-get install -qy git nano python python3-pip
RUN apt-get install -qy screen
RUN pip3 install numpy
RUN pip3 install tqdm
RUN pip3 install Pillow

RUN mkdir -p /home/HanyHamed \
    cd /home/HanyHamed

WORKDIR /home/HanyHamed

# Copy the folders and files to that place

COPY . .

CMD ["python3 assets/CIFAR_dataset/cifar_imgs_github"]
CMD ["./assets/CIFAR_dataset/prepare.sh"]


# -v /home/HanyHamed/output:./output