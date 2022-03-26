

/*
 该函数 通过winget 函数，获取所有运行的窗口,然后通过 & 运算过滤掉 windows 中的一些窗口。
 返回一个 alt+tab窗口数量 AltTab_ID_List_Size
 其中窗口的id 值 返回为 AltTab_ID_List_%A_Index% 
  更改为一个 ahkid 数组 Widow_Array 其中ahk_id 为16进制。
*/
; 返回alt_tab 中获取的窗口列表的ahk_id。
AltTab_window_list(){

  global
  WS_EX_CONTROLPARENT =0x10000
  WS_EX_APPWINDOW =0x40000
  WS_EX_TOOLWINDOW =0x80
  WS_DISABLED =0x8000000
  WS_POPUP =0x80000000
  AltTab_ID_List_ =0
  WinGet, Window_List, List ; Gather a list of running programs
  id_list =
  Loop, %Window_List%
  {
    wid := Window_List%A_Index%
    WinGetTitle, wid_Title, ahk_id %wid%
    WinGet, Style, Style, ahk_id %wid%

    If ((Style & WS_DISABLED) or ! (wid_Title)) ; skip unimportant windows ; ! wid_Title or 
      Continue

    WinGet, es, ExStyle, ahk_id %wid%
    Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
    WinGetClass, Win_Class, ahk_id %wid%
    WinGet, Style_parent, Style, ahk_id %Parent%

    If ((es & WS_EX_TOOLWINDOW)
      or ((es & ws_ex_controlparent) and ! (Style & WS_POPUP) and !(Win_Class ="#32770") and ! (es & WS_EX_APPWINDOW)) ; pspad child window excluded
    or ((Style & WS_POPUP) and (Parent) and ((Style_parent & WS_DISABLED) =0))) ; notepad find window excluded ; note - some windows result in blank value so must test for zero instead of using NOT operator!
    continue
    AltTab_ID_List_ ++
    AltTab_ID_List_%AltTab_ID_List_% :=wid
  }
  AltTab_ID_List_Size := AltTab_ID_List_
}
; 根据ahkid 数组返回一个 进程名数组。
AhkidArray_to_ProcessArray(){
  processArray := [];
  For index, element in Widow_Array {
    ; WinActivate, ahk_id %element%
    WinGet, processName, ProcessName, ahk_id %element%
    processArray[A_Index] := processName
    ; MsgBox % processArray[A_Index]
  }
  return processArray
}
; 十进制转换为16进制
Decimal_to_Hex(var){
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}