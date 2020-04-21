#!/bin/bash
find cifar_imgs_github/train/ -name '*.*' | xargs cp --target-directory=imgs/imgs_original

# mv cifar_imgs_github/train/* imgs/
# mv cifar_imgs_github/test/* imgs/
