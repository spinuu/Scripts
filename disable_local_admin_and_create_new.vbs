sPwd = "password"
strComputer = "."
sUser = "username"
set oShell    = WScript.CreateObject("WScript.Shell")
set oShellEnv = oShell.Environment("Process")
computerName  = oShellEnv("ComputerName")
FileName = "\\remotelocation\" & computerName & ".txt"
Dim oTxtFile
set fso = CreateObject("Scripting.FileSystemObject")
If (fso.FileExists(FileName)) Then
   WScript.Quit
Else



Set objWMIService = GetObject("WinMgmts:\\.\root\cimv2")

Set colAccounts = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True and not Name = '" & sUser & "'")

For Each objAccounts in colAccounts   
     objAccounts.Disabled = True
     objAccounts.Put_
Next

Set colAccounts = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True and Name = 'Administrator' or Name = '" & sUser & "'")
For Each objAccounts in colAccounts
	objAccounts.Rename sUser

Next


Set colAccounts = objWMIService.ExecQuery("Select * From Win32_UserAccount Where LocalAccount = True and Name = '" & sUser & "'")

Set oUser = GetObject("WinNT://" & strComputer & "/" & sUser) 
 
oUser.SetPassword sPwd 
oUser.Setinfo 

	oShell.Run "Net User " & sUser & " /Active:Yes", 0, True


End If
   Set oTxtFile = fso.CreateTextFile(FileName)






