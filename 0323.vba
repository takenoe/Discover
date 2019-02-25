Option Explicit

'定数
Private Const START_LINE = 19           'データ読み取り開始行

Private Const COL_InstrumentClass = 2    'Instrument Class
Private Const COL_ParameterNormalDays = 3              'Parameter Normal Days

'エラーメッセージ
Private Const ERR_NODATA = "有効なレコードが存在しません。" & vbCrLf & "終了します。"
Private Const ERR_CHNULL = "項目に" & vbCrLf & "誤った値（空白かスペースのみ）が設定されているため" & vbCrLf & "確認してください。終了します。"
Private Const ERR_CHCODE = "項目に" & vbCrLf & "半角英数記号以外（全角文字、制御文字、半角かな等）が" & vbCrLf & "含まれています。終了します。"
Private Const ERR_CHNUM = "項目に" & vbCrLf & "半角数字以外が含まれています。" & vbCrLf & "終了します。"
Private Const ERR_CHTRUENULL = "項目に" & vbCrLf & "値が設定されていないため確認してください。" & vbCrLf & "終了します。"

'出力ファイル名を定義
Private Const FILENAME = "InstrumentClass(Trade)_Change.csv"

Type DataStruct
    name As String  'Column Name
    Type As Integer 'Column Type -> 0:number 1:not number
    val As String   'Column Value
End Type

Sub CSVbutton_Click()
    Dim filepath As String          'エクセルファイルのフルパス
    Dim CsvFlNo As Integer          'ファイル番号
    Dim i As Long                   'ループカウンタ
    Dim LngLoop As Long             'Instrument Class列の最終行
    Dim ErrorFlg As Boolean         'エラーフラグ(false:正常,true:異常)
    Dim InstrumentClass As String    'Instrument Class
    Dim ParameterNormalDays As String 'Parameter Normal Days

    'ボタン押下時の確認
    Select Case MsgBox("CSVファイル作成を開始しますか？", vbYesNo + vbQuestion + vbDefaultButton1 + vbApplicationModal)
        Case vbYes
            '処理開始
        Case vbNo
            MsgBox ("キャンセルしました。")
            Exit Sub
    End Select

    With ActiveWorkbook.ActiveSheet
        'Instrument Classの最終行の取得
        LngLoop = .Range("B65536").End(xlUp).Row
    End With

    '最終行が1以下の場合、データ未入力と判断して終了する。
    If LngLoop < START_LINE Then
        MsgBox (ERR_NODATA)
        Exit Sub
    End If

    'ファイル名・Pathを生成
    filepath = ActiveWorkbook.Path & "\" & FILENAME

    'ファイルオブジェクトクリア
    CsvFlNo = FreeFile

    'ファイルストリームOpen
    Open filepath For Output As #CsvFlNo

    'ヘッダ出力
    Print #CsvFlNo, "#Instrument Class,Parameter Normal Days"

    'エラーフラグの初期化(false:正常)
    ErrorFlg = False

    '19行目からレコード出力
    For i = START_LINE To LngLoop

        '主キーチェック(Instrument Class)
        InstrumentClass = Trim(Cells(i, COL_InstrumentClass))
        
        '前後の空白除去後に長さ0の文字列であればエラー
        If Len(InstrumentClass) = 0 Then
            MsgBox ("Instrument Class" & ERR_CHNULL)
            ErrorFlg = True
            GoTo end_exit
        End If
        
        'Instrument Class
        If Not (checkCode(InstrumentClass)) Then
            MsgBox ("Instrument Class" & ERR_CHCODE)
            ErrorFlg = True
            GoTo end_exit
        End If
        
        '主キーチェック(Parameter Normal Days)
        ParameterNormalDays = Trim(Cells(i, COL_ParameterNormalDays))

        '前後の空白除去後に長さ0の文字列であればエラー
        If Len(ParameterNormalDays) = 0 Then
            MsgBox ("Parameter Normal Days" & ERR_CHNULL)
            ErrorFlg = True
            GoTo end_exit
        End If

        'ParameterNormalDays
        If Not (checkCode(ParameterNormalDays)) Then
            MsgBox ("Parameter Normal Days" & ERR_CHNUM)
            ErrorFlg = True
            GoTo end_exit
        End If

        'CSV出力
        Print #CsvFlNo, InstrumentClass & "," & ParameterNormalDays

    Next

end_exit:

    'ファイルストリームClose
    Close #CsvFlNo

    '終了結果判定
    If ErrorFlg = False Then
        '正常の場合、作成完了メッセージ
        MsgBox ("同フォルダにCSVファイルを作成しました。")
    Else
        '異常の場合、途中まで作成したファイルを削除
        Kill (filepath)
    End If

End Sub

'関数名：文字列チェック
'処理内容：英数字、記号であればtrueを返す。
'          それ以外は異常とみなしfalseを返す。
Function checkCode(checkString As String) As Boolean
    Dim i As Long       'ループカウンタ
    Dim chara As String '検査文字格納用

    checkCode = True
    For i = 1 To Len(checkString)
        chara = Mid(checkString, i, 1)
        'ASCIIコードの英数字、記号であることをチェック
        If Asc(chara) < 32 Or 126 < Asc(chara) Then
            checkCode = False
        End If
    Next i
End Function