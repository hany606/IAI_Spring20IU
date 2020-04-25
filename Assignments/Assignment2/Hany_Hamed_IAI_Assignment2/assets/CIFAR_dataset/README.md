# CIFAR Dataset

* For our purpose to prepare the images, I have used a script that has been already written from here: https://github.com/microsoft/CNTK/tree/master/Examples/Image/DataSets/CIFAR-10


## How to prepare the data?

0. ```cd cifar_imgs_github``` 

0.5. Comment or uncomment the part related if you have version of the dataset locally or not inside (Search on this "Comment" and follow the internal instruction)	

1. To download the dataset and construct the images ```python3 install_cifar10.py```

2. To make the script that will move the images to the required position executable ```chmod +x prepare.sh```

3. To execute the script to move the images ```./prepare.sh```
