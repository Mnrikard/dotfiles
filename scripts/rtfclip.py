import win32clipboard
import sys

CF_RTF = win32clipboard.RegisterClipboardFormat("Rich Text Format")

rawrtf = ""
for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    rawrtf += line

rtf = bytearray(rawrtf, 'utf8')

win32clipboard.OpenClipboard(0)
win32clipboard.EmptyClipboard()
win32clipboard.SetClipboardData(CF_RTF, rtf)
win32clipboard.CloseClipboard()
# pandoc --standalone --from=gfm --to=rtf --output=- $1 | /mnt/c/Python38/python.exe c:\\runbox\\rtfclip.py