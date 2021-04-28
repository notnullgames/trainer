$wshell = New-Object -ComObject Wscript.Shell

#Call notepad and run it
$wshell.Run("notepad")

#Delay for 1 second
Start-Sleep -m 1000

#Send keys to notepad
$wshell.SendKeys("HELLO WORLD")
