#Import-Module PsGet
#Import-Module pscx
Import-Module posh-git
Import-Module posh-sshell
Import-Module PSReadline

Start-SSHAgent

#PSReadLine\Set-PSReadlineOption -EditMode Vi

Set-Alias -Name ~ -Value $env:UserProfile
Set-Alias -Name cd -Value pushd -Option AllScope
Set-Alias -Name which -Value Get-Command
#Set-Alias -Name pandoc -Value "C:\Program Files\Pandoc\pandoc.exe"

Set-PSReadlineOption -ShowToolTips -BellStyle Visual
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# load scripts from directory in profile
Get-ChildItem ('c:\cs\tools\PoshScripts') | Where { $_.Name -notlike '__*' -and $_.Name -like '*.ps1'} | ForEach { . $_.FullName }

function Refresh-Path()
{
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

function Which-Port($portNum)
{
	Get-Process -Id (Get-NetTCPConnection -LocalPort $portNum).OwningProcess
}

function Open($app)
{
    switch ($app.ToLower())
    {
        "vs" { & "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe" }
        "iis" { & "c:\Windows\system32\inetsrv\InetMgr.exe" }
        "vi" { & "C:\tools\neovim\nvim-win64\bin\nvim-qt.exe" }
        "ssrs" { & "C:\Program Files\Microsoft SQL Server Reporting Services\Shared Tools\RSConfigTool.exe" }
    }
}

function lst()
{
	list.exe
	$tmpListDir = Get-ItemProperty hkcu:\Environment | ForEach-Object {Get-ItemProperty $_.pspath} | where-object {$_.tempListDir} | Foreach-Object {$_.tempListDir}
	cd $tmpListDir
	cls
}

function trace-listener { & C:\Projects\Realm\Tools\TraceListener\TraceListenerCore\bin\Debug\net5.0\TraceListenerCore.exe }

function base64($fileName)
{
	return [Convert]::ToBase64String([IO.File]::ReadAllBytes($fileName))
}

function wwebpack
{
    & webpack --watch --mode=development
}

function cfg($set) {
	if ($set -eq "set") {
		. $PROFILE
	} else {
		nvim $PROFILE
	}
}

function exhere()
{
	. explorer.exe $PWD
}

function gittobase()
{
    Write-Host "git reset --hard HEAD" -ForegroundColor Cyan
    git reset --hard HEAD
    Write-Host "git clean -df" -ForegroundColor Cyan
    git clean -df
    Write-Host "git fetch -p" -ForegroundColor Cyan
    git fetch -p
    Write-Host "headbranch=`$(git remote show origin | select-string 'HEAD branch').replace('.*: ','')"
    $headbranch=$(git remote show origin | select-string 'HEAD branch').ToString().replace('HEAD branch: ', '').Trim()
    Write-Host "git checkout $headbranch" -ForegroundColor Cyan
    git checkout $headbranch
    Write-Host "git pull origin $headbranch" -ForegroundColor Cyan
    git pull origin $headbranch
    Write-Host "git si" -ForegroundColor Cyan
    git si
}


function SSL-Toggle
{
	$onoff = if((git config --global http.sslVerify) -eq "true") {"false"} else {"true"};
	& npm config -g set strict-ssl $onoff
	& git config --global http.sslVerify $onoff
	$security = if($onoff -eq "true"){"secure"}else{"INSECURE"};
	Write-Host "Setting SSL to $security"
}

function toWord
{
	param(
		[string] $md = (Read-Host "Markdown file")
	)
	& pandoc $md -f markdown -t docx -o "$md.docx"
}

function msbuild {
& "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe" $args
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

function tl {
	& 'c:\cs\tools\tl.ps1'
}


function mklink ($link, $target){
	cmd /c mklink $link $target
}


$env:home = "c:\Users\mattr\"
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)


function Compare-Folders ($folder1, $folder2) {
	Get-ChildItem $folder1 -Recurse | Foreach-Object {
		if($_.PSIsContainer) {
			return
		}
		$hash = (Get-FileHash $_.FullName).Hash;
		$fold2file = $_.FullName.replace($folder1,$folder2);
		if ((Test-Path -Path $fold2file -PathType Leaf) -eq $False) {
			Write-Host "$fold2file does not exist" -ForegroundColor Red
			return
		}
		$hash2 = (Get-FileHash $fold2file).Hash;
		if($hash -ne $hash2) {
			Write-Host "$($_.FullName) does not match $fold2file" -ForegroundColor Red
		} else {
			Write-Host "$($_.FullName) matches $fold2file" -ForegroundColor Cyan
		}
	}

	Get-ChildItem $folder2 -Recurse | Foreach-Object {
		if($_.PSIsContainer) {
			return
		}
		$fold2file = $_.FullName.replace($folder2,$folder1);
		if ((Test-Path -Path $fold2file -PathType Leaf) -eq $False) {
			Write-Host "$fold2file does not exist" -ForegroundColor Red
		}
	}
}

function promptWriteArrow($txt,$color,$backColor, $nextBack){
	$rightArrow = ([char]0xe0b0)
	Write-Host $txt -ForegroundColor $color -BackgroundColor $backColor -NoNewLine;
	Write-Host $rightArrow -ForegroundColor $backColor -BackgroundColor $nextBack -NoNewLine;
}

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
	$lastStat = $?
	$realLASTEXITCODE = $LASTEXITCODE

	$prompt = ""
	$prompt += Write-Prompt "`n╭─$(Get-Date -format HH:mm:ss) " -ForegroundColor White
	$prompt += Write-Prompt $(Get-Location) -ForegroundColor 0xFFA500
	$prompt += Write-VcsStatus
	$prompt += Write-Prompt "`n╰─"
	if ($lastStat) {
		$prompt += Write-Prompt 😎️
	} else {
		$prompt += Write-Prompt 💀
	}

	$prompt += Write-Prompt " >" -ForegroundColor Cyan
	$global:LASTEXITCODE = $realLASTEXITCODE
	return $prompt
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression

Pop-Location
#Start-SshAgent -Quiet

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

figlet -f smslant MP


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



