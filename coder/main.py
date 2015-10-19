#! /usr/bin/env python

from coder import *

cod = coder("foreman", 288, 352, 1.0/8,"../videos/" )
cod.coderJPEG()
cod.calcBitRate()
cod.deleteVideoFiles()