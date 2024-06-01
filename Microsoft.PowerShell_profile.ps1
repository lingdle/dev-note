
if (Test-Path "C:\Users\Administrator\.jabba\jabba.ps1") { . "C:\Users\Administrator\.jabba\jabba.ps1" }

$PROXY="http://127.0.0.1:7890"

function proxy{
	$env:HTTP_PROXY=$PROXY;
	$env:HTTPS_PROXY=$PROXY;
}

function unproxy{
	$env:HTTP_PROXY="";
	$env:HTTPS_PROXY="";
}

function javaenv{
	$envRegKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true);
	$envPath=$envRegKey.GetValue('Path', $null, "DoNotExpandEnvironmentNames").replace('%JAVA_HOME%\bin;', '');
	[Environment]::SetEnvironmentVariable('JAVA_HOME', "$(jabba which $(jabba current))", 'Machine');
	[Environment]::SetEnvironmentVariable('PATH', "%JAVA_HOME%\bin;$envPath", 'Machine');
}


function myalias{
	Set-Alias grep Select-String -Scope Global;
	Set-Alias open explorer -Scope Global;
	Set-Alias ll ls -Scope Global;
	Set-Alias subl "E:\devtools\Sublime Text\subl.exe" -Scope Global;
}

myalias;

function ohmyposh{
	#Install-Module -Name Terminal-Icons
	#Import-Module Terminal-Icons
	[Console]::OutputEncoding = [Text.Encoding]::UTF8
	#oh-my-posh init pwsh | Invoke-Expression;
	oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/simple.omp.json" | Invoke-Expression;
}

ohmyposh;
