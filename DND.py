#!/usr/bin/env python3

# Turns on DND 
# Can be used for toggling along with a parent script DNDToggle.sh

def set_procname(Newname):
	newname = bytes(Newname, 'utf-8')
	from ctypes import cdll, byref, create_string_buffer
	libc = cdll.LoadLibrary('libc.so.6')    #Loading a 3rd party library C
	buff = create_string_buffer(len(newname)+1) #Note: One larger than the name (man prctl says that)
	buff.value = newname                 #Null terminated string as it should be
	libc.prctl(15, byref(buff), 0, 0, 0) #Refer to "#define" of "/usr/include/linux/prctl.h" for the misterious value 16 & arg[3..5] are zero as the man page says.

set_procname("DND.py")

from pydbus import SessionBus
import signal

bus = SessionBus()
remote_object = bus.get("org.freedesktop.Notifications", "/org/freedesktop/Notifications")

remote_object.Inhibit("DND.py", "Manual suspend", {})

signal.pause()

