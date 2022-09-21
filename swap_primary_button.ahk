; ===============================================================================================================================
; Function......: SwapMouseButton
; DLL...........: User32.dll
; Library.......: User32.lib
; U/ANSI........:
; Author........: jNizM
; Modified......:
; Links.........: https://msdn.microsoft.com/en-us/library/ms646264.aspx
;                 https://msdn.microsoft.com/en-us/library/windows/desktop/ms646264.aspx
; ===============================================================================================================================
; Swap:
; If this parameter is TRUE,
; the left button generates right-button messages
; and the right button generates left-button messages.
; If this parameter is FALSE,
; the buttons are restored to their original meanings.
;
; Return
; If the meaning of the mouse buttons was reversed previously,
; before the function was called, the return value is nonzero.
; If the meaning of the mouse buttons was not reversed,
; the return value is zero.
SwapMouseButton(Swap)
{
    return DllCall("user32.dll\SwapMouseButton", "UInt", Swap)
}

ChangeCursorScheme(Scheme){
	KeyNames := ["Arrow", "Help", "AppStarting", "Wait", "Crosshair", "IBeam", "NWPen", "No", "SizeNS", "SizeWE", "SizeNWSE", "SizeNESW", "SizeAll", "UpArrow", "Hand", "Pin", "Person"]
	KEYpath := "HKEY_CURRENT_USER\Control Panel\Cursors"
	SPI_SETCURSORS := 0x0057
	
	RegRead, SchemeVals, HKEY_CURRENT_USER\Control Panel\Cursors\Schemes, %Scheme%

	if(!SchemeVals){
		RegRead, SchemeVals, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors\Schemes, %Scheme%
	}

	SchemeVals := StrSplit(SchemeVals, ",")
	
	if(SchemeVals.Length() > 0){
		RegWrite, Reg_SZ, %KEYpath%, , %Scheme%
	}

    for index, key in KeyNames {
        val := SchemeVals[index]
        RegWrite, Reg_Expand_SZ, %KEYpath%, %key%, %val%
    }

	DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", "0", "UInt", 0, "UInt", "0")
}

Toggle()
{
    buttonState := SwapMouseButton(1)

    if (buttonState <> 0)   ; Currently using left hand
    {
        buttonState := SwapMouseButton(0)
        ChangeCursorScheme("Windows Aero")
    }
    else      ; Currently right hand (dominant hand)
    {
        ChangeCursorScheme("Windows XI Aero Left Handed")
    }
}

; ===============================================================================================================================

#F12::
    Toggle()
