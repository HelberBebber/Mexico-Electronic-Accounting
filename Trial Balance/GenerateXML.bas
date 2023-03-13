Attribute VB_Name = "GenerateXML"
Sub Generate_XML()
'
' GenerateXML Macro
    Dim Version As String
    Dim RFC As String
    Dim Mes As String
    Dim Anio As String
    Dim TipoEnvio As String
    Dim FechaModBal As String
    Dim Sello As String
    Dim noCertificado As String
    Dim BalanzaCertificado As String
    Dim XML As String
    Dim XML2 As String
    Dim Row As String
    Dim Row2 As String
    Dim ColumnName As String
    Dim ColumnValue As String
    Dim MesP1 As String
    Dim MesP2 As String
    Dim MesPr As String
    Dim Pos As Integer
    Dim Pos2 As Integer
    Dim Pos3 As Integer
    Dim MidStr As String
    Dim MidStr2 As String
    Dim Arr
    Dim myCell As Range

    Sheets(1).Select
    Version = Replace(ActiveSheet.Cells(1, 1).Value, " ", "")
    RFC = Replace(ActiveSheet.Cells(2, 1).Value, " ", "")
    Mes = Replace(ActiveSheet.Cells(3, 1).Value, " ", "")
    Anio = Replace(ActiveSheet.Cells(4, 1).Value, " ", "")
    TipoEnvio = Replace(ActiveSheet.Cells(5, 1).Value, " ", "")
    FechaModBal = Replace(ActiveSheet.Cells(6, 1).Value, " ", "")
    Sello = Replace(ActiveSheet.Cells(7, 1).Value, " ", "")
    noCertificado = Replace(ActiveSheet.Cells(8, 1).Value, " ", "")
    BalanzaCertificado = Replace(ActiveSheet.Cells(9, 1).Value, " ", "")
    
    Arr = Array("Version", "RFC", "Mes", "Anio", "TipoEnvio", "FechaModBal", "Sello", "noCertificado", "Certificado")
    
    'XML = XML & "<BCE:Balanza xmlns:BCE=" & Chr(34) & "http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/BalanzaComprobacion" & Chr(34) & " xmlns:xsi=" & Chr(34) & "http://www.w3.org/2001/XMLSchema-instance" & Chr(34) & " xsi:schemaLocation=" & Chr(34) & "http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/BalanzaComprobacion http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/BalanzaComprobacion/BalanzaComprobacion_1_1.xsd" & Chr(34) & " " & Version & " " & RFC & " " & Mes & " " & Anio & " " & TipoEnvio & " " & FechaModBal & " " & Sello & " " & noCertificado & " " & BalanzaCertificado & ">" & vbNewLine
    XML = XML & "<BCE:Balanza xmlns:BCE=" & Chr(34) & "http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion" & Chr(34) & " xmlns:xsi=" & Chr(34) & "http://www.w3.org/2001/XMLSchema-instance" & Chr(34) & " xsi:schemaLocation=" & Chr(34) & "http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion/BalanzaComprobacion_1_3.xsd" & Chr(34)
    XML2 = XML
    Row2 = ""
    
    For I = 1 To 9
        Row2 = Row2 & " " & ActiveSheet.Cells(I, 1)
    Next I
    'MsgBox XML2
    'MsgBox Row2
    XML2 = XML2 & "  " & Row2
    
    XML = XML2 & ">" & vbNewLine
    
    ActiveSheet.Range("A10").Select
    Selection.End(xlDown).Select
    SheetLastRow = ActiveCell.Row
    
    ActiveSheet.Range("A10").Select
    Selection.End(xlToRight).Select
    SheetLastColumn = ActiveCell.Column

    'Forcing decimal point
    Application.DecimalSeparator = "."
    Application.ThousandsSeparator = ""
    Application.UseSystemSeparators = False
    
    For I = 11 To SheetLastRow
        Row = vbTab & "<BCE:Ctas "
        For J = 1 To SheetLastColumn
            ColumnName = Replace(ActiveSheet.Cells(10, J).Value, " ", "")
            If ColumnName = "SaldoIni" Or ColumnName = "Debe" Or ColumnName = "Haber" Or ColumnName = "SaldoFin" Then
                'MsgBox ColumnValue
                If ActiveSheet.Cells(I, J).Value = "" Or ActiveSheet.Cells(I, J).Value = "0" Then
                
                    ColumnValue = 0
                    'MsgBox ColumnValue
                Else
                    ActiveSheet.Cells(I, J).Value = CDbl(ActiveSheet.Cells(I, J))
                    ActiveSheet.Cells(I, J).NumberFormat = "0.00"
                    ColumnValue = ActiveSheet.Cells(I, J).Text
                End If
                'Selection.NumberFormat = "#,###"
            Else
                ActiveSheet.Cells(I, J).Value = CDbl(ActiveSheet.Cells(I, J))
                ActiveSheet.Cells(I, J).NumberFormat = "0.00"
                ColumnValue = ActiveSheet.Cells(I, J).Text
            End If
            Row = Row & ColumnName & "=" & Chr(34) & ColumnValue & Chr(34) & " "
        Next J
        Row = Row & "/>" & vbNewLine
        
        XML = XML & Row
    Next I
    
    Application.UseSystemSeparators = True

    XML = XML & "</BCE:Balanza>"
    
    fileSaveName = Application.GetSaveAsFilename(ActiveSheet.Name, fileFilter:="XML Files (*.xml), *.xml")
        
    Open fileSaveName For Output As #1
    Print #1, "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "UTF-8" & Chr(34) & "?>"
    Print #1, XML
    Close #1
'
End Sub

