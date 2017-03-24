Type=Activity
Version=6.5
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region
#Extends: android.support.v7.app.AppCompatActivity

Sub Process_Globals
	Public usu_id_buscar As Long = 0
End Sub

Sub Globals
	Dim capa_contorno As Int = 331
	Private gmap As GoogleMap
	Dim MapsExtras As GoogleMapsExtras
	Private mapfrag As MapFragment
	
	Private ActionBar As ACToolBarLight
	Private ABHelper As ACActionBar
	Private AC As AppCompat
	Private sview As HorizontalScrollView
	Private lblFontAwesome As Label
	
	Dim HashMap As Map
	Dim CentrarEn As LatLng

End Sub

Sub Activity_Create(FirstTime As Boolean)
	If FirstTime = True Then
'		trilibs.addActivity(Me)
	End If
	
	Activity.LoadLayout("googlemap")
	If mapfrag.IsGooglePlayServicesAvailable = False Then
		ToastMessageShow("Necesita instalar Google Play Services.", True)
	End If
	
	ABHelper.Initialize
	ABHelper.UpIndicatorBitmap = LoadBitmap(File.DirAssets,trilibs.iMenu)
	ABHelper.ShowUpIndicator = True
	ActionBar.InitMenuListener
	ProgressDialogShow2("Cargando...",False)
	HashMap.Initialize
	GetCoordenadas
End Sub

Sub GetCoordenadas
	Dim GetCoor As HttpJob
	GetCoor.Initialize("GetCoordenadas_test",Me)
	Dim post As String = ""
	'post = post & "usu_id=" & 1
	GetCoor.PostString("http://lospibes.somee.com/http/getCoordenadas.aspx",post)
End Sub


 
Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Sub ActionBar_NavigationItemClick
	
End Sub

Sub mapfrag_Ready
	gmap = mapfrag.GetMap
	ProgressDialogHide
End Sub

Sub mapfrag_MarkerClick (SelectedMarker As Marker) As Boolean 'Return True to consume the click
	
End Sub

Sub ActionBar_MenuItemClick (Item As ACMenuItem)
	
End Sub


Sub JobDone (job As HttpJob)
	Select job.JobName
		Case "GetCoordenadas_test"
			getCoordenadasJobDone(job)
	End Select
	job.Release
End Sub

Sub getCoordenadasJobDone(job As HttpJob)
	If Not(job.Success) Then
		Log(job.ErrorMessage)
		ToastMessageShow("job.ErrorMessage",True)
	Else
		Dim JSON As JSONParser
		Dim obj As Map
		JSON.Initialize(job.GetString)
		obj = JSON.NextObject
		ToastMessageShow(obj.Get("msjInfo"), True)
		Dim listado As List
		listado.Initialize
		listado = obj.Get("list")
		If listado.IsInitialized Then
			For i = 0 To listado.Size -1
				obj = listado.Get(i)
				addMarker(obj)
			Next
		End If
	End If
	ProgressDialogHide
End Sub
 

Sub addMarker(obj As Map)
	Dim m1 As Marker = gmap.AddMarker2(obj.Get("latitud"),obj.Get("latitud"),"Probamos marker",gmap.HUE_MAGENTA)
End Sub

Sub addMarkerPersona(obj As Map)
	Dim id As String
	
	id = obj.Get("descripcion")
	Dim markers_de_la_capa As List
	markers_de_la_capa.Initialize
	If HashMap.ContainsKey(id) = False  Then
		HashMap.Put(id,markers_de_la_capa)
	Else
		markers_de_la_capa = HashMap.Get(id)
	End If
	
	Dim lista As List
	lista.Initialize
	lista = obj.Get("list")
	If lista.IsInitialized Then
		For i = 0 To lista.Size -1
			Dim aux As Map
			aux.Initialize
			aux = lista.Get(i)
			Dim usu_nombre As String = aux.Get("usu_nombre")
			Dim usu_latitud As String = aux.Get("usu_latitud")
			Dim usu_longitud As String = aux.Get("usu_longitud")
			Dim m1 As Marker = gmap.AddMarker2(usu_latitud, usu_longitud, usu_nombre,gmap.HUE_RED)
			markers_de_la_capa.Add(m1)
			'm1.Snippet = usu_nombre
		Next
	End If
	
	HashMap.Put(id,markers_de_la_capa)
End Sub

Sub addPolyline(obj As Map)
	Dim uid As String = ""
	Dim bar_id As String = ""
	Dim bar_descripcion As String = ""
	Dim id As String = ""
	Dim cap_id_gis As String = ""
	Dim dat_titulo As String = ""
	Dim cap_descripcion As String = ""
	Dim cal_descripcion As String = ""
	Dim dat_altura As String = ""
	Dim coo_latitud As String = ""
	Dim coo_longitud As String = ""
	Dim color_fondo As String = ""
	Dim color_borde As String = ""
	Dim cap_orden As String = ""
	Dim tipo As String = ""
	Dim icono As String = ""
	Dim coordenadas As List
	coordenadas.Initialize
				
	uid = obj.Get("uid")
	bar_id = obj.Get("bar_id")
	bar_descripcion = obj.Get("bar_descripcion")
	id = obj.Get("id")
	dat_titulo = obj.Get("dat_titulo")
	cap_descripcion = obj.Get("cap_descripcion")
	cal_descripcion = obj.Get("cal_descripcion")
	dat_altura = obj.Get("dat_altura")
	coo_latitud = obj.Get("coo_latitud")
	coo_longitud = obj.Get("coo_longitud")
	color_fondo = obj.Get("color_fondo")
	color_borde = obj.Get("color_borde")
	cap_orden = obj.Get("cap_orden")
	tipo = obj.Get("tipo")
	icono = obj.Get("icono")
	cap_id_gis = obj.Get("cap_id")
	coordenadas = obj.Get("coordenadas")
	Dim pOption As PolylineOptions
	pOption.Initialize
	Dim polilineas_de_la_capa As List
	polilineas_de_la_capa.Initialize
	
	If HashMap.ContainsKey(cap_id_gis) = False  Then
		HashMap.Put(cap_id_gis,polilineas_de_la_capa)
	Else
		polilineas_de_la_capa = HashMap.Get(cap_id_gis)
	End If
	
	Dim points As List
	points.Initialize
	If coordenadas.IsInitialized Then
		For i = 0 To coordenadas.Size - 1
			Dim arr() As String = Regex.Split("\,", coordenadas.Get(i))
			Dim latlon As LatLng
			latlon.Initialize(arr(0),arr(1))
			points.Add(latlon)
		Next
	End If
	pOption.AddPoints(points)
'	pOption.Color = trilibs.HexToRGB(color_borde)
	pOption.ZIndex = 3
	Dim polilinea As Polyline = MapsExtras.AddPolyline(gmap, pOption)
	polilineas_de_la_capa.Add(polilinea)
	
	HashMap.Put(cap_id_gis,polilineas_de_la_capa)
End Sub

Sub addPolygone(obj As Map)
	Dim uid As String = ""
	Dim bar_id As String = ""
	Dim bar_descripcion As String = ""
	Dim id As String = ""
	Dim cap_id_gis As String = ""
	Dim dat_titulo As String = ""
	Dim cap_descripcion As String = ""
	Dim cal_descripcion As String = ""
	Dim dat_altura As String = ""
	Dim coo_latitud As String = ""
	Dim coo_longitud As String = ""
	Dim color_fondo As String = ""
	Dim color_borde As String = ""
	Dim cap_orden As String = ""
	Dim tipo As String = ""
	Dim icono As String = ""
	Dim coordenadas As List
	coordenadas.Initialize
				
	uid = obj.Get("uid")
	bar_id = obj.Get("bar_id")
	bar_descripcion = obj.Get("bar_descripcion")
	id = obj.Get("id")
	dat_titulo = obj.Get("dat_titulo")
	cap_descripcion = obj.Get("cap_descripcion")
	cal_descripcion = obj.Get("cal_descripcion")
	dat_altura = obj.Get("dat_altura")
	coo_latitud = obj.Get("coo_latitud")
	coo_longitud = obj.Get("coo_longitud")
	color_fondo = obj.Get("color_fondo")
	color_borde = obj.Get("color_borde")
	cap_orden = obj.Get("cap_orden")
	tipo = obj.Get("tipo")
	icono = obj.Get("icono")
	cap_id_gis = obj.Get("cap_id")
	coordenadas = obj.Get("coordenadas")
	
	Dim pOption As PolygonOptions
	pOption.Initialize
	Dim poligonos_de_la_capa As List
	poligonos_de_la_capa.Initialize
	
	If HashMap.ContainsKey(cap_id_gis) = False  Then
		HashMap.Put(cap_id_gis,poligonos_de_la_capa)
	Else
		poligonos_de_la_capa = HashMap.Get(cap_id_gis)
	End If
	
	Dim points As List
	points.Initialize
	If coordenadas.IsInitialized Then
		For i = 0 To coordenadas.Size - 1
			Dim arr() As String = Regex.Split("\,", coordenadas.Get(i))
			Dim latlon As LatLng
			latlon.Initialize(arr(0),arr(1))
			points.Add(latlon)
		Next
	End If
	pOption.AddPoints(points)
'	pOption.StrokeColor = trilibs.HexToRGB(color_borde)
	pOption.FillColor=Colors.ARGB(0, 0, 0, 0)
	pOption.StrokeWidth = 4
	pOption.ZIndex = 4
	 
	
	Dim poligono As Polygon = MapsExtras.AddPolygon(gmap, pOption)
	poligonos_de_la_capa.Add(poligono)
	
	HashMap.Put(cap_id_gis,poligonos_de_la_capa)
	
	CentrarEn = getCenterPoly(points)
	If CentrarEn.IsInitialized Then
		Dim CamPosition As CameraPosition
		CamPosition.Initialize(CentrarEn.Latitude,CentrarEn.Longitude, 14)
		gmap.AnimateCamera(CamPosition)
	End If
	 
End Sub

Sub getCenterPoly(latlongs As List) As LatLng
	Dim masArriba, _
		masAbajo, _
		masDerecha, _
		masIzquierda As Double
	
	masArriba = 0
	masAbajo = 0
	masDerecha = 0
	masIzquierda = 0
	
	Dim rangovertical, _
		rangohorizontal As Double
		
	rangovertical = 0
	rangohorizontal = 0
	
	For i = 0 To latlongs.Size -1
		Dim aux As LatLng = latlongs.Get(i)
		
		''Obtengo el mas arriba
		If masArriba = 0 Then
			masArriba = aux.Latitude
		Else
			If masArriba < aux.Latitude Then
				masArriba = aux.Latitude
			End If
		End If

		''Obtengo el mas abajo
		If masAbajo = 0 Then
			masAbajo = aux.Latitude
		Else
			If masAbajo > aux.Latitude Then
				masAbajo = aux.Latitude
			End If
		End If
		
		''Obtengo el de mas a la derecha
		If masDerecha = 0 Then
			masDerecha = aux.Longitude
		Else
			If masDerecha < aux.Longitude Then
				masDerecha = aux.Longitude
			End If
		End If
		
		''Obtengo el de mas a la izquierda
		If masIzquierda = 0 Then
			masIzquierda = aux.Longitude
		Else
			If masIzquierda > aux.Longitude Then
				masIzquierda = aux.Longitude
			End If
		End If
		
	Next
	rangovertical = (masArriba - masAbajo) / 2
	rangohorizontal = (masDerecha - masIzquierda) / 2
	Dim latlon As LatLng
	latlon.Initialize(masAbajo + rangovertical, masIzquierda + rangohorizontal)
	Return  latlon
End Sub
 
Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK  Then
		Dim close As Boolean = True
		If close Then
			Activity.Finish
		Else
			Return True
		End If
	End If
End Sub

Sub cerrarApp
	Dim result As Int
	result = Msgbox2("¿Esta seguro que desea salir de la aplicación?" , "Salir", "Aceptar", "", "Cancelar", Null)
	If result = DialogResponse.Positive Then
	Else
		Return
	End If
End Sub

Sub MenuApp_Click
	
End Sub

Sub OpenActivity(act As String)
	StartActivity(act)
End Sub

