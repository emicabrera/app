Type=StaticCode
Version=6.5
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Dependencias:  ByteConverter (1.10)
'				Encryption (1.10)
'				Reflection (2.40)
Sub Process_Globals
	Type menuLateralOpc(activo As Boolean, panel As  Panel) 
	Dim iHome As String = "ic_home_black_24dp.png"
	Dim iMenu As String = "ic_menu_white_24dp.png"  
	Dim iEmail As String =  "ic_email_black_24dp.png"
	Dim iSend As String = "ic_send_black_24dp.png"
	Dim iUser As String = "usuario.png"
	Dim iPerson As String ="ic_person_black_24dp.png"
	Dim iPriority As String ="ic_priority_high_black_24dp.png"
	Dim iBack As String = "ic_arrow_back_white_24dp.png"
	
	Type checkboxlist(id As Int, valor As String )
	Private lstAct As List
End Sub

Sub getEstado(opc As  menuLateralOpc)
	Return opc.activo
End Sub

Sub hex_md5(str As String) As String
	Dim Bconv As ByteConverter
	Dim data(0) As Byte	
	Dim md As MessageDigest
	data = Bconv.StringToBytes(str, "UTF8")
	data = md.GetMessageDigest(data, "MD5")
	str	 = Bconv.HexFromBytes(data)	
	Return str
End Sub

Sub hex_sha1(str As String) As String
	Dim Bconv As ByteConverter
	Dim data(0) As Byte	
	Dim md As MessageDigest
	data = Bconv.StringToBytes(str, "UTF8")
	data = md.GetMessageDigest(data, "SHA-1")
	str	 = Bconv.HexFromBytes(data)	
	Return str
End Sub

Sub GetDeviceId As String
   Dim r As Reflector
   Dim Api As Int
   Api = r.GetStaticField("android.os.Build$VERSION", "SDK_INT")
   If Api < 9 Then
      'Old device
      If File.Exists(File.DirInternal, "__id") Then
         Return File.ReadString(File.DirInternal, "__id")
      Else
         Dim id As Int
         id = Rnd(0x10000000, 0x7FFFFFFF)
         File.WriteString(File.DirInternal, "__id", id)
         Return id
      End If
   Else
      'New device
      Return r.GetStaticField("android.os.Build", "SERIAL")
   End If
End Sub



Sub msjSimple(titulo As String,str As String) As Panel
	'''''''''''''''en proceso ''''''''''''''''''''''''''''
	Dim pContenedorGeneral As Panel
	pContenedorGeneral.Initialize("pContenedorGeneral")
	
	Dim bg As ColorDrawable
	bg.Initialize(Colors.ARGB(128,0,0,0),0)
	pContenedorGeneral.Background = bg
	
	Dim pContenedorMsj As Panel
	pContenedorMsj.Initialize("pContenedorMsj")
	Dim bg2 As ColorDrawable
	bg2.Initialize(Colors.White,0)
	pContenedorMsj.Background = bg2
	pContenedorMsj.Elevation = 20dip
	Dim tit As Label
	tit.Initialize("tit")
	tit.Text = titulo
	tit.TextSize = 24
	tit.Typeface = Typeface.DEFAULT_BOLD
	
	Dim texto As Label
	texto.Initialize("texto")
	texto.Text = str
	texto.TextSize = 20
	pContenedorMsj.AddView(tit,5%x,5%y,90%x,20%y)
	pContenedorMsj.AddView(texto,5%x,tit.Height + 5%y + 5dip ,90%x,70%y)
	pContenedorGeneral.AddView(pContenedorMsj,10%x,25%y,80%x,50%y)
	pContenedorGeneral.BringToFront
	pContenedorMsj.BringToFront
	texto.BringToFront
	
	Return pContenedorGeneral
End Sub


Sub CrearBitmap As Canvas
   Dim bmp As Bitmap
   bmp.InitializeMutable(200dip, 200dip)
   Dim cvs As Canvas
   cvs.Initialize2(bmp)
   Dim r As Rect
   r.Initialize(0, 0, bmp.Width, bmp.Height)
   cvs.DrawRect(r, Colors.Transparent, True, 0)
   Dim p As Path
   p.Initialize(0, 0)
   Dim jo As JavaObject = p
   Dim x = 100dip, y = 100dip, radius = 100dip As Float
   jo.RunMethod("addCircle", Array As Object(x, y, radius, "CW"))
   cvs.ClipPath(p)
   Return cvs
End Sub

Sub DibujarBitmapRedondo (cvs As Canvas, bmp As Bitmap)
   Dim r As Rect
   r.Initialize(0, 0, cvs.Bitmap.Width, cvs.Bitmap.Height)
   cvs.DrawBitmap(bmp, Null, r)
End Sub

Sub redondarBitmap(imagen As Bitmap) As Bitmap
	Dim cvs As Canvas = CrearBitmap
	DibujarBitmapRedondo(cvs,imagen)
	Return cvs.Bitmap
End Sub


Public Sub ImageToBytes(Image As Bitmap) As Byte()
   Dim out As OutputStream
   out.InitializeToBytesArray(0)
   Image.WriteToStream(out, 100, "JPEG")
   out.Close
   Return out.ToBytesArray
End Sub

Public Sub BytesToImage(bytes() As Byte) As Bitmap
   Dim In As InputStream
   In.InitializeFromBytesArray(bytes, 0, bytes.Length)
   Dim bmp As Bitmap
   bmp.Initialize2(In)
   Return bmp
End Sub

Sub BytesToFile (Dir As String, FileName As String, Data() As Byte)
   Dim out As OutputStream = File.OpenOutput(Dir, FileName, False)
   out.WriteBytes(Data, 0, Data.Length)
   out.Close
End Sub

Sub FileToBytes (Dir As String, FileName As String) As Byte()
   Return Bit.InputStreamToBytes(File.OpenInput(Dir, FileName))
End Sub

Sub ImageToFile(Dir As String, FileName As String,bmp As Bitmap)
	Dim out As OutputStream
    out = File.OpenOutput(Dir, FileName, False)
    bmp.WriteToStream(out, 100, "JPEG")
    out.Close
End Sub

Sub StartWaveFile(Dir As String, FileName As String, SampleRate As Int, Mono As Boolean _
		, BitsPerSample As Int) As OutputStream
	File.Delete(Dir, FileName)
	Dim raf As RandomAccessFile
	raf.Initialize2(Dir, FileName, False, True)
	raf.WriteBytes("RIFF".GetBytes("ASCII"), 0, 4, raf.CurrentPosition)
	raf.CurrentPosition = 8 'skip 4 bytes for the size
	raf.WriteBytes("WAVE".GetBytes("ASCII"),0, 4, raf.CurrentPosition)
	raf.WriteBytes("fmt ".GetBytes("ASCII"),0, 4, raf.CurrentPosition)
	raf.WriteInt(16, raf.CurrentPosition)
	raf.WriteShort(1, raf.CurrentPosition)
	Dim numberOfChannels As Int
	If Mono Then numberOfChannels = 1 Else numberOfChannels = 2
	raf.WriteShort(numberOfChannels, raf.CurrentPosition)
	raf.WriteInt(SampleRate, raf.CurrentPosition)
	raf.WriteInt(SampleRate * numberOfChannels * BitsPerSample / 8, raf.CurrentPosition)
	raf.WriteShort(numberOfChannels * BitsPerSample / 8, raf.CurrentPosition)
	raf.WriteShort(BitsPerSample, raf.CurrentPosition)
	raf.WriteBytes("data".GetBytes("ASCII"),0, 4, raf.CurrentPosition)
	raf.WriteInt(0, raf.CurrentPosition)
	raf.Close
	Return File.OpenOutput(Dir, FileName, True)
End Sub

Sub CloseWaveFile(Dir As String, FileName As String)
	Dim raf As RandomAccessFile
	raf.Initialize2(Dir, FileName, False, True)
	raf.WriteInt(raf.Size - 8, 4)
	raf.WriteInt(raf.Size - 44, 40)
	raf.Close
End Sub

Sub CrearToken() As String
	Return hex_md5(DateTime.Now)
End Sub

Sub WriteLog(str As String)
'	Dim writer As TextWriter
'    writer.Initialize(File.OpenOutput(Main.dirGestionPolitica, Main.LogTxt, True))
'    writer.WriteLine(str)
'    writer.Close
End Sub
Sub WriteLog2(str As String)
'	Dim writer As TextWriter
'    writer.Initialize(File.OpenOutput(Main.dirGestionPolitica, Main.LogTxt, True))
'    writer.Write(str & CRLF)
'	writer.Close
End Sub

Sub CreateScaledBitmap(Original As Bitmap, Width As Int, Height As Int, Filter As Boolean) As Bitmap
	Dim jo As JavaObject
	jo.InitializeStatic("android.graphics.Bitmap")
	Return jo.RunMethod("createScaledBitmap", Array (Original, Width, Height, Filter))
End Sub

Sub rellenarceros(numero As String, longitud As Int) As String 
	For	i = numero.Length To longitud
		numero = "0" & numero
	Next
	Return numero
End Sub
 
 
Sub HexToRGB(Hex As String) As Int
	Hex=Hex.Replace("#","")
	If Hex="" Then
		Hex="ffffff"
	End If
	Hex=Hex.ToUpperCase
	Dim R,G,B As String
	R=Hex.substring2(0,2)
	G=Hex.SubString2(2,4)
	B=Hex.substring2(4,6)
	
	Dim RI,GI,BI As Int
	RI = toDecimal(R,16)
	GI = toDecimal(G,16)
	BI = toDecimal(B,16)
	
	Return Colors.RGB(RI,GI,BI)
End Sub

Sub HexToARGB(Hex As String, opacidad As Int) As Int
	Hex=Hex.Replace("#","")
	If Hex="" Then
		Hex="ffffff"
	End If
	Hex=Hex.ToUpperCase
	Dim R,G,B As String
	R=Hex.substring2(0,2)
	G=Hex.SubString2(2,4)
	B=Hex.substring2(4,6)
	
	If opacidad > 255 Then opacidad = 255
	If opacidad < 0 Then opacidad = 0
	
	Dim RI,GI,BI As Int
	RI = toDecimal(R,16)
	GI = toDecimal(G,16)
	BI = toDecimal(B,16)

	Return Colors.ARGB(opacidad,RI,GI,BI)
End Sub

Sub toDecimal( n As String, base As Int) As Int
    n = n.ToUpperCase
   Dim result As Int = 0
   Dim st As String
   Dim chars As  String ="0123456789ABCDEF"
   Dim k As Int = n.length - 1
   Dim multiplier As Int = 1
   For i =  k To 0 Step -1
       st = n.CharAt(i)
       result = chars.IndexOf(st) * multiplier  + result
       multiplier = multiplier * base
	Next
	Return result
End Sub
 
Public Sub addActivity(obj As Object)
	Dim ref As Reflector
	ref.Target=obj
	Dim obj2 As Object = ref.GetActivity
	If lstAct.IsInitialized=False Then lstAct.Initialize
    lstAct.Add(obj2)
End Sub

public Sub ExitApp
    Dim act As Reflector
    For i=0 To lstAct.Size-1
        act.Target=lstAct.Get(0)
        Try
        act.RunMethod("finish")
        Catch
            Log(LastException.Message)
        End Try
        lstAct.RemoveAt(0)
    Next
    StopService(Starter)
    ExitApplication
End Sub