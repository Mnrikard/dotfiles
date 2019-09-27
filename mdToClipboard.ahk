filename := ""
for n, param in A_Args
{
	filename = %filename% %param%
}

;Run, "C:\Program Files\Pandoc\pandoc.exe" --standalone --from=markdown --to=rtf --output=%A_Temp%\copyRtf.rtf "%filename%"
Run, "C:\Program Files\Pandoc\pandoc.exe" --standalone --highlight-style=haddock --to=html5 --from=markdown --metadata pagetitle=copy --output=%A_Temp%\copyRtf.html "%filename%"

WinWait "pandoc.exe",,0
WinWaitClose "pandoc.exe",,0

Run, "%A_Temp%\copyRtf.html"

