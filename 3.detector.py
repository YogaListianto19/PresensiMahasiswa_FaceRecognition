import os

import cv2
import numpy as np
from PIL import Image
from flask import Flask, render_template, Response
from urllib.request import urlopen
import mysql.connector

conn = mysql.connector.connect(host="localhost", user="root", passwd="", database="db_absensi")
cursor = conn.cursor()


faceDetect= cv2.CascadeClassifier('C:/OpenCV/opencv/sources/data/haarcascades/haarcascade_frontalface_alt.xml');
eye_cascade = cv2.CascadeClassifier('C:/OpenCV/opencv/sources/data/haarcascades/haarcascade_eye.xml');
cam = cv2.VideoCapture(0);
rec=cv2.face.LBPHFaceRecognizer_create();
rec.read("recognizer\\trainningData1.yml")
Id = 0
fontface = cv2.FONT_HERSHEY_SIMPLEX
fontscale = 1
fontcolor = (0,255,0)
cam.set(cv2.CAP_PROP_FRAME_HEIGHT,1000)
cam.set(cv2.CAP_PROP_FRAME_WIDTH,500)

while(True):
    ret,img=cam.read()
    gray= cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = faceDetect.detectMultiScale(gray, 1.2, minNeighbors=5, minSize=(100, 100));

    for (x,y,w,h) in faces:
        cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
        #batas
        roi_gray = gray[y:y+h, x:x+w]
        roi_color = img[y:y+h, x:x+w]

        eyes = eye_cascade.detectMultiScale(roi_gray)
        for (ex,ey,ew,eh) in eyes:
            cv2.rectangle(roi_color,(ex,ey),(ex+ew,ey+eh),(0,255,0),2)
        #batas
        Id,conf=rec.predict(gray[y:y+h,x:x+w])
        
        if(conf<50):
            sql = "UPDATE ms_mhs SET bol_jk=%s WHERE str_npm=%s"
            value = ("1", Id)
            cursor.execute(sql,value)
            conn.commit()
        else:
            Id="Unknown"
        
        
        
        cv2.putText(img,str(Id),(x,y+h),fontface,fontscale,fontcolor,2);
    cv2.imshow("Face", img);
    if(cv2.waitKey(10) & 0xFF==ord('q')):
        break;
cam.release()
cv2.destroyAllWindows()
