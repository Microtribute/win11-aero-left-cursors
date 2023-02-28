SwapMouseButton(Swap)
{
    return DllCall("user32.dll\SwapMouseButton", "UInt", Swap)
}

ChangeCursorScheme(Scheme)
{
    KeyNames := ["Arrow", "Help", "AppStarting", "Wait", "Crosshair", "IBeam", "NWPen", "No", "SizeNS", "SizeWE", "SizeNWSE", "SizeNESW", "SizeAll", "UpArrow", "Hand", "Pin", "Person"]
    KeyPath := "HKEY_CURRENT_USER\Control Panel\Cursors"
    SPI_SETCURSORS := 0x0057

    RegRead, SchemeVals, HKEY_CURRENT_USER\Control Panel\Cursors\Schemes, %Scheme%

    if(!SchemeVals){
        RegRead, SchemeVals, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors\Schemes, %Scheme%
    }

    SchemeVals := StrSplit(SchemeVals, ",")

    if(SchemeVals.Length() > 0){
        RegWrite, Reg_SZ, %KeyPath%, , %Scheme%
    }

    for index, key in KeyNames {
        val := SchemeVals[index]
        RegWrite, Reg_Expand_SZ, %KeyPath%, %key%, %val%
    }

    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", "0", "UInt", 0, "UInt", "0")
}

Toggle()
{
    buttonState := SwapMouseButton(1)

    if (buttonState <> 0) ; Currently using left hand
    {
        buttonState := SwapMouseButton(0)
        ChangeCursorScheme("Windows Aero")
    }
    else ; Currently right hand (dominant hand)
    {
        ChangeCursorScheme("Windows XI Aero Left Handed")
    }
}

!^+F12::
    Toggle()

; Ensure the cursors remain unchanged from its previous state upon startup,
; which can be accomplished by calling the `Toggle()` function twice.
Toggle()
Toggle()
