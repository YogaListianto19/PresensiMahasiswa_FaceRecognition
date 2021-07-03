import os
import cv2
import numpy as np
from PIL import Image

faceDetect= cv2.CascadeClassifier('C:/OpenCV/opencv/sources/data/haarcascades/haarcascade_frontalface_alt.xml');
recognizer = cv2.face.LBPHFaceRecognizer_create();
path='dataSet'

def getImageWithId(path):
    imagePaths=[os.path.join(path,f) for f in os.listdir(path)]
    images=[]
    labels=[]
    for imagePath in imagePaths:
        faceImg=Image.open(imagePath).convert('L');
        faceNp=np.array(faceImg, 'uint8')
        nbr = int(os.path.split(imagePath)[1].split(".")[0].replace("face-", ""))
        print (nbr)
        faces = faceDetect.detectMultiScale(faceNp)
        for (x, y, w, h) in faces:
            images.append(faceNp[y: y + h, x: x + w])
            labels.append(nbr)
            cv2.imshow("Training", faceNp[y: y + h, x: x + w])
            cv2.waitKey(10)
    return np.array(images), np.array(labels)

images, labels = getImageWithId(path)
cv2.imshow('test', images[0])
cv2.waitKey(1)

recognizer.train(images, np.array(labels))
recognizer.save('recognizer/trainningData2.yml')
cv2.destroyAllWindows()
