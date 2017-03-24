Type=Service
Version=6.5
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	Public tmr_DescargarFoto As Timer
	Public tmr_notificacion As Timer
	Private logs As StringBuilder
	Private logcat As LogCat
	Private url_foto As String
End Sub

Sub Service_Create
	logs.Initialize
	#if RELEASE
		logcat.LogCatStart(Array As String("-v","raw","*:F","B4A:v"), "logcat")
	#end if
	
End Sub

Public Sub CheckUpdate
'	Dim CheckVersion As HttpJob
'	CheckVersion.Initialize("CheckVersion",Me)
'	CheckVersion.Download(Main.server & "mobile/app_version.aspx")
End Sub

Public Sub StartNotificacion
	tmr_notificacion.Initialize("tmr_notificacion",5000)
	tmr_notificacion.Enabled = True
End Sub

Private Sub logcat_LogCatData (Buffer() As Byte, Length As Int)
	logs.Append(BytesToString(Buffer, 0, Length, "utf8"))
	If logs.Length > 5000 Then
		logs.Remove(0, logs.Length - 4000)
	End If
End Sub

Sub Service_Start (StartingIntent As Intent)
End Sub

Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
'	Dim msj As String = $"Fecha: $DateTime{DateTime.Now}"$ & CRLF
'	msj = msj & "usu_id: " & Main.usu_id
'	msj = msj & "Error: " & Error.Message & CRLF
'	msj = msj & "Pila de Seguimiento: "
'
'	Dim jo As JavaObject
'	Dim l As Long = 500
'	jo.InitializeStatic("java.lang.Thread").RunMethod("sleep", Array(l)) 
'	logcat.LogCatStop
'	logs.Append(StackTrace & CRLF & "_________________________________________")
'	msj = msj & logs
'	trilibs.WriteLog2(msj)
	Return True
End Sub

Sub Service_Destroy
End Sub
'
'Sub IniciarDescarga(url As String)
'	url_foto = url
'	If url_foto  <> "" Then
'		tmr_DescargarFoto_Tick
'	End If
'End Sub
'
'Sub JobDone (job As HttpJob)
'    Select job.JobName
'		Case "DescargarFoto"
'			DescargarFotoJobDone(job)
'		Case  "GetCantidadMensajes"
'			GetCantidadMensajesJobDone(job)
'		Case "CheckVersion"
'			CheckVersionJobDone(job) 
'	End Select
'   job.Release
'End Sub
'
'Sub DescargarFotoJobDone(job As HttpJob)
'	If job.Success = True Then
'		tmr_DescargarFoto.Enabled = False
'		Try
'			trilibs.ImageToFile(Main.dirPerfil,"perfil.jpg",job.GetBitmap)
'		Catch
'			Log(LastException)
'		End Try
'	Else
'		tmr_DescargarFoto.Initialize("tmr_DescargarFoto",60000)	
'	End If
'End Sub
'
'
'Sub GetCantidadMensajesJobDone(Job As HttpJob)
'	If Job.Success = True Then
'		Dim JSON As JSONParser
'		JSON.Initialize(Job.GetString)
'		Dim mapa As Map
'		mapa = JSON.NextObject
'		If mapa.Get("success") Then
'			If mapa.Get("cantidad") > 0 Then
'				
'				Dim n As Notification
'				n.Initialize
'				n.SetInfo("Gestión Política", "Tienes " & mapa.Get("cantidad")  & " mensajes sin leer.", buzon)
'				n.Icon = "icon"
'				n.OnGoingEvent = False
'				n.AutoCancel = True
'				n.Notify(0)
'			End If
'		Else
'			trilibs.WriteLog("GetCantidadMensajesJobDone: " & mapa.Get("msjInfo") )
'		End If
'	Else
'		trilibs.WriteLog("GetCantidadMensajesJobDone: " & Job.ErrorMessage )
'	End If
'End Sub

'Sub AbrirBuzon
'	Dim in As Intent
'	in.Initialize("", "")
'	in.SetComponent("b4a.gestionpolitica/.buzon")
'	StartActivity(in)
'End Sub
'
'Sub tmr_DescargarFoto_Tick
'	Dim DescargarFoto As HttpJob
'	DescargarFoto.Initialize("DescargarFoto",Me) 
'	DescargarFoto.Download(Main.server.SubString2(0,Main.server.Length - 1) & url_foto)
'End Sub
'
'Sub tmr_notificacion_Tick
'	Dim GetCantidadMensajes As HttpJob
'	GetCantidadMensajes.Initialize("GetCantidadMensajes",Me)
'	Dim post As String =""
'	post  = post & "usan_android="  & Main.usan_token
'	post = post & "&usu_android_id=" & trilibs.GetDeviceId
'	GetCantidadMensajes.PostString(Main.server & "/mobile/app_getmensajesnuevos.aspx",post)
'End Sub
'
'Sub CheckVersionJobDone(job As HttpJob)
'	ProgressDialogHide
'	If job.Success = True Then
'		Dim JSON As JSONParser
'		JSON.Initialize(job.GetString)
'		Dim mapa As Map
'		mapa = JSON.NextObject
'		If mapa.Get("version") > Application.VersionCode Then
'			CallSub(Main,"MsjActualizacion")
'		End If
'	Else
'		ToastMessageShow("No se pudo comprobar si hay actualizaciones",True)
'	End If
'End Sub
 