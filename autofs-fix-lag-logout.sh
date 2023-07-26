#!/bin/sh

# This script is needed to stop autofs at logout so that it's stopped before
# network is down and does not cause delay in shutdown or reboot.
# I run this as a logout script from KDE. We need to make sure that password
# isn't needed to stop autofs. For that, create this file.
# /etc/polkit-1/rules.d/autofs-service.rules
# -------------------------------------------
# polkit.addRule(function(action, subject) {
#     if (action.id == "org.freedesktop.systemd1.manage-units" &&
#         subject.isInGroup("usergroup")) {
#         if (action.lookup("unit") == "autofs.service") {
#             var verb = action.lookup("verb");
#             if (verb == "start" || verb == "stop" || verb == "restart") {
#                 return polkit.Result.YES;
#             }
#         }
#     }
# });

systemctl stop autofs
