If WScript.Arguments.length = 0 Then
   Set objShell = CreateObject("Shell.Application")
   'Pass a bogus argument, say [ uac]
   objShell.ShellExecute "wscript.exe", Chr(34) & _
      WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
Else

sPwd = "PASSWORD"
strComputer = "."
sUser = "ADMIN_NAME"

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colAccounts = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True")

For Each objAccounts in colAccounts   
     objAccounts.Disabled = True
     objAccounts.Put_
Next

Set colAccounts = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True and Name = 'Administrator'")
For Each objAccounts in colAccounts   
     	objAccounts.Disabled = False
     	objAccounts.Put_
	objAccounts.Rename sUser
Next

Set colAccounts3 = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True and Name = '" & sUser & "'")
For Each objAccounts3 in colAccounts3   
     	objAccounts3.Disabled = False
     	objAccounts3.Put_
Next

Set oUser = GetObject("WinNT://" & strComputer & "/" & sUser) 
 
oUser.SetPassword sPwd 
oUser.Setinfo 

End If





