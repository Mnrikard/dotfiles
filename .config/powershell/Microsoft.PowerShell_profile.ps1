#Import-Module PsGet
#Import-Module pscx
#Import-Module posh-git
Import-Module PSReadline

#PSReadLine\Set-PSReadlineOption -EditMode Vi

Set-PSReadlineOption -ShowToolTips -BellStyle Visual

#$global:GitPromptSettings.EnableWindowTitle = $null
$Host.UI.RawUI.WindowTitle = "Powershell"

# load scripts from directory in profile
Get-ChildItem ('~\PoshScripts') | Where { $_.Name -notlike '__*' -and $_.Name -like '*.ps1'} | ForEach { . $_.FullName }

function Refresh-Path()
{
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

function Which-Port($portNum)
{
	Get-Process -Id (Get-NetTCPConnection -LocalPort $portNum).OwningProcess
}

function base64($fileName)
{
	return [Convert]::ToBase64String([IO.File]::ReadAllBytes($fileName))
}

function exhere()
{
	. explorer.exe $PWD
}

function toWord
{
	param(
		[string] $md = (Read-Host "Markdown file")
	)
	& pandoc $md -f markdown -t docx -o "$md.docx"
}

function dnbuild{
	param(
			[string] $p = "AnyCPU",
			[string] $t = "Release"
	);

	$roj = (gci *roj);

	Write-Host "msbuild /t:clean $roj"
	msbuild /t:clean $roj;
	Write-Host "msbuild /p:Platform=$p /p:Configuration=$t /v:q $roj"
	msbuild /p:Platform=$p /p:Configuration=$t /v:q $roj;
}

function SearchDeep($filePattern, $searchString)
{
	if ($filePattern -eq "" -or $searchString -eq "" -or $filePattern -eq $null -or $searchString -eq $null)
	{
		Write-Host "syntax: " -NoNewline -ForegroundColor "red"
			Write-Host "SearchDeep " -NoNewline -ForegroundColor Cyan
			Write-Host "$$filePattern $$searchString" -ForegroundColor Magenta
			Write-Host "example: " -NoNewline -ForegroundColor Red
			Write-Host "SearchDeep *.sql ""update table"""
	}
	else
	{
		Get-ChildItem $filePattern -Recurse |
			Foreach-Object {
				Select-String -Path $_.FullName -Pattern $searchString | Foreach-Object {
					DisplayCapture $_.Line $_.Matches
						Write-Host " $($_.Path):$($_.LineNumber) " -ForegroundColor cyan
				}

			}
	}
}

function DisplayCapture($line, $matches){
	$i=0
		if($matches[0].Value.Length -gt 0 -and ![System.Char]::IsWhiteSpace($matches[0].Value[0])){
			while([System.Char]::IsWhiteSpace($line[$i])){
				$i++
			}
		}

	for($mi=0;$mi -lt $matches.Length;$mi++) {
		$ln = $line.Substring($i,$matches[$mi].Index - $i)
			Write-Host $ln -ForegroundColor Green -NoNewline
			$i = $matches[$mi].Index
			$mch = $line.Substring($i,$matches[$mi].Length)
			Write-Host $mch -ForegroundColor white -BackgroundColor Red -NoNewline
			$i = $i+$matches[$mi].Length
			$mi++
	}

	if($i -lt $line.Length) {
		$ln = $line.Substring($i)
			Write-Host $ln.TrimEnd() -ForegroundColor Green -NoNewline
	}
	Write-Host ""
}

function Execute-SqlFiles($server){
	if($PWD -match "Rollback"){
		gci *.sql | sort -Descending | ForEach-Object { Write-Host $_.Name; Execute-OrVim "$($_.FullName)" $server; }
	} else {
		gci *.sql | sort | ForEach-Object { Write-Host $_.Name; Execute-OrVim "$($_.FullName)" $server; }
	}
}

function Execute-OrVim($file, $server){
	$output = (& sqlcmd -S $server -E -i $file)
	if($output -match "Msg \d+"){
		Write-Host $output -ForegroundColor red

		$doedit = (Read-Host "Edit in Vim? [Y|n]");
		if(!($doedit -match "n")){
			& vim $file;
			Execute-OrVim $file $server
		}
	} else {
		Write-Host $output -ForegroundColor green
	}
}

function gadd {
	& git add -A
}

function gcomm
{
	git commit $args
}

function gstat {
	& git status
}

function gpull {
	$branch = (git rev-parse --abbrev-ref HEAD)
	& git pull origin $branch --rebase
}

function gpush {
	$branch = (git rev-parse --abbrev-ref HEAD)
	& git push origin $branch
	if ([System.Text.RegularExpressions.Regex]::IsMatch((git remote show),"github", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
		& git push github $branch
	}
}

function gfetch {
	git fetch -p
}


$env:home = "~"
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

function promptWrite($txt,$color,$backColor, $nextBack){
	$rightArrow = ([char]0xe0b0)
	Write-Host $txt -ForegroundColor $color -BackgroundColor $backColor -NoNewLine;
	Write-Host $rightArrow -ForegroundColor $backColor -BackgroundColor $nextBack -NoNewLine;
}

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
	$lastStat = $?
	$realLASTEXITCODE = $LASTEXITCODE
	# $? gets reset after each execution, whereas $LASTEXITCODE only gets updated when you run a command (so echo doesn't affect it)
	$time = "$(Get-Date -format HH:mm:ss.fff)"
		promptWrite $time White Cyan White


		$loc = Get-Location
		promptWrite $loc Blue White DarkYellow
		promptWrite " P O W E R S H E L L " Black DarkYellow Black
# Reset color, which can be messed up by Enable-GitColors
#		$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
		Write-VcsStatus
		Write-Host "`n"
		Write-Host "`n"
		if($lastStat){
			$checkMark = ([char]0x221A)
			promptWrite $checkMark Black White Blue
		} else {
			promptWrite "x" Black Red Blue
		}
		promptWrite "PS ${$lastStat}$" White Blue Black
		$global:LASTEXITCODE = $realLASTEXITCODE
		return " "
}

function Compare-Folders ($folder1, $folder2) {
	Get-ChildItem $folder1 | Foreach-Object {
		$name = $_.Name;
		$hash = (Get-FileHash $_.FullName).Hash;
		$fold2file = "$folder2/$name";
		$hash2 = (Get-FileHash $fold2file).Hash;
		if($hash -ne $hash2) {
			Write-Host "$name mismatch";
		}
	}
}

#& 'C:\repos\recovery\poshSSH.ps1'

Pop-Location
#Start-SshAgent -Quiet

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


# SIG # Begin signature block
# MIIEMwYJKoZIhvcNAQcCoIIEJDCCBCACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXR3s2MpdpYBdHfCipNBfesE+
# hSSgggI9MIICOTCCAaagAwIBAgIQb4iuFUkVc5xCoJQA8NLFNzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMjEyMTcyMjAwMDhaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA1E/2pdjG2HJY
# 4HOuPnCqOoub0kMFEIpKTfWbsYzT9GJJGX4MU4jT2a2ozWrJ5kIGfzPmk97pJPP7
# ZwfsZn1xRsZ7Dro2NtYcGxvSDI8XN/AnyQz/fkaPEkpA0DIi1Wb0w62cLXIJo8gE
# uxdO0WDrtbTLG31Bm++ZyRxfH9r1N1UCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQr709DQSHXmRCsODTJYKzAKEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQHw+IBCkw+phPiKw3
# Id2VbDAJBgUrDgMCHQUAA4GBAFKexoTnCZpP1MCRzvs/HXdTuGKVhiReu12C1LoT
# 5ikxr3A2VZ88t4jRp/Pvh7+bYoqlagWfNh56DUbR4Xxa/YpLDfeE8wFUgoiSQs4u
# jo/9ZYCXjRELEl7Nv+rY4Cevtpujhi5Q25QDD25Y6lS2UUkPMOoZ6Gl2ohQjtEDK
# fl89MYIBYDCCAVwCAQEwQDAsMSowKAYDVQQDEyFQb3dlclNoZWxsIExvY2FsIENl
# cnRpZmljYXRlIFJvb3QCEG+IrhVJFXOcQqCUAPDSxTcwCQYFKw4DAhoFAKB4MBgG
# CisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcC
# AQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYE
# FHEYBQyf+jBE3+faPoqATXUuwqTxMA0GCSqGSIb3DQEBAQUABIGAJN1XRdtlJiBj
# ROYoF2ZhnaTEkcdXn5uobpFNdAD7TNBQcdm5ZyhYKGqjtfld4psgulozHILd/tAA
# aNFuswT+5Psr2/dRNWiK77Xhq7tTc4n/x4LCpeZTuIji3AQIh80GT1TtzyMo97FB
# /1Y7Vzvai5XyQVFGJV8GWpcAJOLKYIo=
# SIG # End signature block


