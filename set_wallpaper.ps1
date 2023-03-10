#kopiuje plik graficzny ze ścieżki zdalnej i ustawia jako tapetę

function Set-WallPaper($Value)

{

 Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $value

 rundll32.exe user32.dll, UpdatePerUserSystemParameters

}

copy-item "\\remotelocation\wallpaper.png" -Destination "c:\users\$env:username\documents\"
Set-WallPaper -value "c:\users\$env:username\documents\wallpaper.png"
