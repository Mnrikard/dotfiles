function Archive-Sql()
{
	GCI C:\SQL\EveryDay\ | Where-Object {
		$_.LastWriteTime -lt (Get-Date).AddDays(-90)
	} | ForEach-Object {
		if (!(Test-Path "c:\SQL\EveryDay\$($_.LastWriteTime.Year)" -PathType Container))
		{
			New-Item -ItemType Directory "c:\SQL\EveryDay\$($_.LastWriteTime.Year)";
		}
		Move-Item "$($_.FullName)" "c:\SQL\EveryDay\$($_.LastWriteTime.Year)\$_";
	}
}

Archive-Sql

Write-Host "Name this file: " -NoNewLine -ForegroundColor Green
$fname = (Read-Host)
$fullname = "c:\SQL\EveryDay\$fname.sql"
if (!(Test-Path $fullname))
{
	$content = "if 1=1 begin; print 'do not execute an entire file, select a portion and execute that'; end else begin;`r`n`r`nselect 1`r`n`r`nend;"

	New-Item -ItemType File $fullname
	Set-Content -Path $fullname -Value $content -Encoding UTF8
}

explorer.exe $fullname
