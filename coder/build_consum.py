info = ['','','','','']


fp = open('akiyo_original_1_1.html')
while 1:
    line = fp.readline()
    info[4] = info[3]
    info[3] = info[2]
    info[2] = info[1]
    info[1] = info[0]
    info[0] = line
    if not line:
        break
    if line.find('ffmpeg') > 0:
        info[4]= info[4].replace('<','X')
        info[4]= info[4].replace('>','X')
        str1 = info[4].split('X')
        print str1[2]

