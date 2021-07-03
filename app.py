from flask import Flask, render_template, Response
from flask import Flask, render_template, json, request, redirect, session
from flaskext.mysql import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
from flask import flash
import cv2
import numpy as np
from PIL import Image
# from trainner import
import os
from urllib.request import urlopen
from datetime import datetime

from datetime import date
import time
import json

app = Flask(__name__)
mysql = MySQL()
app.secret_key = 'why would I tell you my secret key?'


# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'db_absensi'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


# OpenCv Configur
faceDetect = cv2.CascadeClassifier(
    'C:/OpenCV/opencv/sources/data/haarcascades/haarcascade_frontalface_alt.xml')
eye_cascade = cv2.CascadeClassifier(
    'C:/OpenCV/opencv/sources/data/haarcascades/haarcascade_eye.xml')
video = cv2.VideoCapture(0)
rec = cv2.face.LBPHFaceRecognizer_create()
rec.read("recognizer\\trainningData1.yml")
#path = "dataSet"
Id = 0
fontface = cv2.FONT_HERSHEY_SIMPLEX
fontscale = 1
fontcolor = (0, 255, 0)
video.set(cv2.CAP_PROP_FRAME_HEIGHT, 1000)
video.set(cv2.CAP_PROP_FRAME_WIDTH, 500)
height = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT) + 0.5)
width = int(video.get(cv2.CAP_PROP_FRAME_WIDTH) + 0.5)
ukuran = (width, height)
fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter("outpuyt.avi", fourcc, 20.0, ukuran)


@app.route('/')
def index():
    return render_template('login.html')


@app.route('/validateLogin', methods=['POST'])
def validateLogin():
    try:
        _email = request.form['username']
        _pw = request.form['password']

        # connect to muysql
        con = mysql.connect()
        cursor = con.cursor()
        cursor.callproc('spValidateLogin', (_email,))
        data = cursor.fetchall()

        if len(data) > 0:
            if check_password_hash(str(data[0][5]), _pw):
                session['user'] = data[0][4]
                return redirect('/dashboard')
            else:
                flash("Salah email atau password.")
                return render_template('error.html', error='Salah email atau password.')
        else:
            flash("Salah email atau password.")
            return render_template('error.html', error='Salah email atau password.')
    except Exception as e:
        return render_template('error.html', error=str(e))
    finally:
        cursor.close()
        con.close()

# Pemanggil Form


@app.route('/dashboard')
def dashboard():
    con = mysql.connect()
    jadwal = con.cursor()
    jadwal.execute('''SELECT jadwal_perkuliahan.kode_perkuliahan, jadwal_perkuliahan.str_kd_mk, jadwal_perkuliahan.jam_kuliah_mulai,
        jadwal_perkuliahan.hari, ms_mkuliah.str_nm_mk, jadwal_perkuliahan.jam_kuliah_selesai, jadwal_perkuliahan.kode_kelas, ms_mkuliah.str_kd_mk
        from jadwal_perkuliahan
        INNER JOIN ms_mkuliah
        ON jadwal_perkuliahan.str_kd_mk = ms_mkuliah.str_kd_mk''')
    data2 = jadwal.fetchall()
    if session.get('user') == "yoga":
        return render_template('dashboard.html', aa=session['user'], rv=data2)
    else:
        return render_template('dashboard.html', aa=session['user'], rv=data2)


@app.route('/KelolaUser')
def KelolaUser():
    con = mysql.connect()
    cursor = con.cursor()
    cursor.execute('''SELECT * from ms_user''')
    rv = cursor.fetchall()
    return render_template('Admin/kelolaUser.html', value=rv)


@app.route('/KelolaPerwalian/<per>', methods=['GET'])
def KelolaPerwalian(per):
    con = mysql.connect()
    cursor = con.cursor()
    cursor2 = con.cursor()
    cursor3 = con.cursor()
    cursor.execute('''SELECT ms_perwalian.id, ms_perwalian.str_npm, ms_perwalian.str_semester,
        ms_perwalian.kd_thn_ajaran, ms_perwalian.int_id_konsentrasi, ms_perwalian.st_disetujui,
        ms_perwalian.st_aktif, ms_mhs.str_nm_mhs
        from ms_perwalian
        INNER JOIN ms_mhs
        ON ms_perwalian.str_npm=ms_mhs.str_npm''')
    cursor2.execute('''SELECT * from ms_mhs ''')
    cursor3.execute(
        '''SELECT * from ms_mkuliah_take where id_perwalian = %s''', (per))
    rv2 = cursor2.fetchall()
    rv = cursor.fetchall()
    return render_template('Admin/kelolaPerwalian.html', mhs=rv, va=rv2)


@app.route('/tambahMatkul/<id>/<thn>/<sem>/<npm>', methods=['GET'])
def tambahMatkul(id, thn, sem, npm):
    con = mysql.connect()
    mkuliah = con.cursor()
    mkuliah.execute('''SELECT ms_kurikulum.id, ms_kurikulum.str_kd_mk, ms_kurikulum.str_thn_ajaran, ms_kurikulum.str_semester,
        ms_mkuliah.str_nm_mk, ms_mkuliah.str_jml_sks
        from ms_kurikulum
        INNER JOIN ms_mkuliah ON ms_kurikulum.str_kd_mk = ms_mkuliah.str_kd_mk
        where ms_kurikulum.str_thn_ajaran = %s and ms_kurikulum.str_semester=%s''', (thn, sem))
    rv = mkuliah.fetchall()
    return render_template('Admin/tambah_matkul.html', mk=rv, npm=npm, id=id)


@app.route('/tambahWajah/<npm>', methods=['GET'])
def tambahWajah(npm):
    return render_template('Admin/tambah_wajah.html', npm=npm)


@app.route('/KelolaMahasiswa')
def KelolaMahasiswa():
    con = mysql.connect()
    cursor = con.cursor()
    cursor.execute('''SELECT * from ms_mhs''')
    rv = cursor.fetchall()
    return render_template('Admin/KelolaMahasiswa.html', value=rv)


@app.route('/presensiMahasiswa3', methods=['POST'])
def presensiMahasiswa3():
    p_hari = request.form['hari']
    current = datetime.now()
    kd_perkuliahan = request.form['kd_kuliah']
    p_tgl = current.strftime('%d %B %Y')
    v_tanggal = current.strftime('%Y-%m-%d')
    str_jam = request.form['jam']
    p_matkul = request.form['matkul']
    p_kelas = request.form['kelas']
    con = mysql.connect()
    cursor = con.cursor()
    cursor.execute('''SELECT * from ms_mhs''')
    kelas = cursor.fetchall()
    for row in kelas:
        saveAbsen = con.cursor()
        saveAbsen.callproc('sp_absen', (kd_perkuliahan, row[1], v_tanggal))
        con.commit()
        # saveAbsen.close()
    session['tanggal'] = p_tgl
    session['tgl'] = v_tanggal
    session['kd_perkuliahan'] = kd_perkuliahan
    session['hari'] = p_hari
    session['matakuliah'] = p_matkul
    return redirect('/callPresensi')


@app.route('/callPresensi')
def callPresensi():
    con = mysql.connect()
    cursor2 = con.cursor()
    cursor2.execute('''SELECT ms_absensi.id, ms_absensi.kode_perkuliahan, ms_absensi.str_npm, ms_absensi.st_hadir, 
        ms_absensi.pertemuan, ms_absensi.tanggal, ms_mhs.str_nm_mhs
        from ms_absensi
        INNER JOIN ms_mhs ON ms_absensi.str_npm = ms_mhs.str_npm
        where ms_absensi.tanggal=%s AND ms_absensi.kode_perkuliahan=%s''', (session['tgl'], session['kd_perkuliahan']))
    absen = cursor2.fetchall()
    return render_template('Admin/coba.html', tgl=session['tanggal'], daftar=absen, hari=session['hari'], matkul=session['matakuliah'])


@app.route('/FaceDetection')
def FaceDetection():
    return render_template('Admin/facedetection.html')


@app.route('/DataRecognizer')
def DataRecognizer():
    return render_template('Admin/dataRecognizer.html')


@app.route('/FaceDetection2')
def FaceDetection2():
    return render_template('Admin/facedetection.html', value='on')


@app.route('/video_feed')
def video_feed():
    """Video streaming route. Put this in the src attribute of an img tag."""
    return Response(face(), mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route('/video_feed2')
def video_feed2():
    """Video streaming route. Put this in the src attribute of an img tag."""
    return Response(facerecog2(), mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route('/image_feed', methods=['POST', 'GET'])
def image_feed():
    return Response(imageset(nama1), mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route('/panggilDataset', methods=['POST', 'GET'])
def panggilDataset():
    npm = request.form['p_npm']
    # path = request.form['kelas']
    return Response(dataset(npm))


# Perintah Simpan
@app.route('/saveMahasiswa', methods=['POST', 'GET'])
def saveMahasiswa():
    try:
        p_npm = request.form['p_npm']
        p_nama = request.form['p_nama']
        p_tgl = request.form['p_tgl']
        p_tempat = request.form['p_tempat']
        p_telp = request.form['p_telp']

        # validate the received values
        if p_npm and p_nama and p_tgl and p_tempat and p_telp:
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_CreateMahasiswa',
                            (p_npm, p_nama, p_tgl, p_tempat, p_telp))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return redirect('/KelolaMahasiswa')
                # return json.dumps({'message':'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
            # else:
            # return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/saveTambahMatkul', methods=['POST', 'GET'])
def saveTambahMatkul():
    try:
        p_perwalian = request.form['id']
        p_kuri = request.form['matkul']
        p_sks = request.form['sks']
        p_kelas = '28'
        p_st = '1'

        # validate the received values
        if p_perwalian and p_kuri and p_sks:
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_CreateMKTake', (p_perwalian,
                                                p_kuri, p_sks, p_kelas, p_st))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return redirect('/kelolaPerwalian')
                # return json.dumps({'message':'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
        # else:
            # return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/saveTambahKelas', methods=['POST', 'GET'])
def saveTambahKelas():
    try:
        p_npm = request.form['npm']
        p_kelas = request.form['kelas']

        # validate the received values
        if p_npm and p_kelas:
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(
                'UPDATE ms_mhs set str_kd_kelas = %s WHERE str_npm = %s', (p_kelas, p_npm))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return redirect('/KelolaMahasiswa')
                # return json.dumps({'message':'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
        # else:
            # return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/savePerwalian', methods=['POST', 'GET'])
def savePerwalian():
    try:
        p_npm = request.form['p_npm']
        p_semester = request.form['p_semester']
        thn_ajaran = request.form['thn_ajaran']
        p_konsentrasi = request.form['p_konsentrasi']

        # validate the received values
        if p_npm and p_semester and thn_ajaran and p_konsentrasi:
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_CreatePerwalian',
                            (p_npm, p_semester, thn_ajaran, p_konsentrasi))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return redirect('/KelolaPerwalian')
                # return json.dumps({'message':'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
        # else:
            # return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/saveUser', methods=['POST', 'GET'])
def saveUser():
    try:
        p_reff = request.form['p_reff']
        p_key = request.form['p_key']
        p_email = request.form['p_email']
        p_username = request.form['p_username']
        p_password = request.form['p_password']

        # validate the received values
        if p_reff and p_key and p_email and p_username and p_password:
            conn = mysql.connect()
            cursor = conn.cursor()
            hashed_password = generate_password_hash(p_password)
            cursor.callproc('sp_CreateUser', (p_reff, p_key,
                                              p_email, p_username, hashed_password))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return json.dumps({'message': 'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
            # else:
            # return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()

# Perintah Delete


@app.route('/deleteMahasiswa/<id>', methods=['GET'])
def deleteMahasiswa(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('Delete from ms_mhs where oid=%s', (id,))
    conn.commit()
    return redirect('/KelolaMahasiswa')


@app.route('/deleteUser/<id>', methods=['GET'])
def deleteUser(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('Delete from ms_user where oid=%s', (id,))
    conn.commit()
    return redirect('/KelolaUser')


# Perintah Update
@app.route('/updateMahasiswa', methods=['POST'])
def updateMahasiswa():
    p_npm = request.form['p_npm']
    p_nama = request.form['p_nama']
    p_tgl = request.form['p_tgl']
    p_tempat = request.form['p_tempat']
    p_telp = request.form['p_telp']
    p_id = request.form['p_id']
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.callproc('sp_UpdateMahasiswa',
                    (p_npm, p_nama, p_tgl, p_tempat, p_telp, p_id))
    conn.commit()
    return redirect('/KelolaMahasiswa')


# Coding OpenCv
@app.route('/trainDS')
def trainDS():
    path = 'dataset'
    imagePaths = [os.path.join(path, f) for f in os.listdir(path)]
    # i=0
    # while i < len(imagePaths):
    images, labels = getImageWithId(path)
    # i += 1
    cv2.imshow('test', images[0])
    cv2.waitKey(1)
    rec.train(images, np.array(labels))
    rec.save('recognizer/trainningData1.yml')
    cv2.destroyAllWindows()
    return json.dumps({'message': 'Train face created successfully !'})


def getImageWithId(path):
    imagePaths = [os.path.join(path, f) for f in os.listdir(path)]
    images = []
    labels = []
    i = 0
    while i < len(imagePaths):
        faceImg = Image.open(imagePaths[i]).convert('L')
        faceNp = np.array(faceImg, 'uint8')
        nbr = int(os.path.split(imagePaths[i])[
                  1].split(".")[0].replace("face-", ""))
        print(nbr)
        faces = faceDetect.detectMultiScale(faceNp)
        for (x, y, w, h) in faces:
            images.append(faceNp[y: y + h, x: x + w])
            labels.append(nbr)
            cv2.imshow("Training", faceNp[y: y + h, x: x + w])
            cv2.waitKey(10)
        i += 1
    return np.array(images), np.array(labels)


def facerecog():
    while True:
        rval, frame = video.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = faceDetect.detectMultiScale(
            gray, 1.2, minNeighbors=5, minSize=(100, 100))
        for (x, y, w, h) in faces:
            cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2)
            Id, conf = rec.predict(gray[y:y+h, x:x+w])
            #sql = "UPDATE ms_mhs SET bol_jk=%s WHERE str_npm=%s"
            #value = ("1", Id)
            # kursor.execute(sql,value)
            # koneksi.commit()
            cv2.putText(frame, str(Id), (x, y+h),
                        fontface, fontscale, fontcolor, 2)
            cv2.imwrite('t.jpg', frame)
            # save ke database
            imgcode = cv2.imencode('.jpg', frame)[1]
            stringData = imgcode.tostring()
            # simpan data ke json
            with open('templates/Admin/absen.json', 'w') as json_file:
                json.dump({"name": Id}, json_file)
            yield (b'--frame\r\n'
                   b'Content-Type: text/plain\r\n\r\n' + stringData + b'\r\n')


def facerecog2():  # hanya menampilkan gambar
    while True:

        rval, frame = video.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = faceDetect.detectMultiScale(
            gray, 1.2, minNeighbors=5, minSize=(100, 100))
        current = datetime.now()
        v_tanggal = current.strftime('%Y-%m-%d')
        for (x, y, w, h) in faces:
            cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2)
            Id, conf = rec.predict(gray[y:y+h, x:x+w])
            sql = "UPDATE ms_absensi SET st_hadir=%s WHERE str_npm=%s AND tanggal=%s"
            value = ("1", Id, v_tanggal)
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(sql, value)
            conn.commit()
            cv2.putText(frame, str(Id), (x, y+h),
                        fontface, fontscale, fontcolor, 2)
            # cv2.imwrite('t.jpg', frame)
            cv2.imshow('Face', frame)
            out.write(frame)

            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + open('t.jpg', 'rb').read() + b'\r\n')
            out.release()


def dataset(npm):

    i = 0
    offset = 50
    while True:
        rval, frame = video.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = faceDetect.detectMultiScale(
            gray, 1.2, minNeighbors=5, minSize=(100, 100))
        # url = 'dataset/%s/' % (path)
        url = 'dataset/'
        for(x, y, w, h) in faces:
            i = i+1
            cv2.rectangle(frame, (x-50, y-50),
                          (x+w+50, y+h+50), (225, 0, 0), 2)
            cv2.imwrite(url+"face-"+npm + '.' + str(i) + ".jpg",
                        gray[y-offset:y+h+offset, x-offset:x+w+offset])

        if i > 9:
            # video.release()
            # cv2.destroyAllWindows()
            # alert("Sukses")
            con = mysql.connect()
            cursor = con.cursor()
            cursor.execute('''SELECT * from ms_mhs''')
            rv = cursor.fetchall()
            return render_template('Admin/KelolaMahasiswa.html', value=rv)
            # return render_template('Admin/KelolaMahasiswa.html', value='on', value2='%sface-%s.1.jpg' %(url,npm))
            return redirect('/KelolaMahasiswa')
            break


def face():
    while True:
        rval, frame = video.read()

        cv2.imwrite('b.jpg', frame)
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + open('b.jpg', 'rb').read() + b'\r\n')


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, threaded=True)
