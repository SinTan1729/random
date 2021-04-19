// ==UserScript==
// @name Firefox local auto-redirection fix
// @namespace Local
// @description A script for fixing the auto-redirection defined in local files in firefox
// @match file:///*
// @grant none
// @author SinTan
// @version 1.1
// ==/UserScript==
window.location.href=document.getElementsByTagName("a")[0].href