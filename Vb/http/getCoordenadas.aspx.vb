Imports TriLibs
Imports System.Web.Script.Serialization
Public Class getCoordenadas
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Js As New JavaScriptSerializer
        Dim R As New Respuesta
        Try
            Dim d As New Db("usuario_coordenada")
            d.DataSetFill()

            Dim dt As DataTable = d.GetTable(0)
            For i = 0 To dt.Rows.Count - 1
                Dim item As New Musico
                item.latitud = dt.Rows(i)("usu_lat")
                item.longitud = dt.Rows(i)("usu_lng")
                R.list.Add(item)
            Next
        Catch ex As Exception
            R.success = False
            R.msjInfo = ex.Message
        End Try
        Response.Write(Js.Serialize(R))
    End Sub
    Private Class Respuesta
        Public success As Boolean = True
        Public msjInfo As String = ""
        Public list As New List(Of Musico)
    End Class
    Private Class Musico
        Public latitud As String = ""
        Public longitud As String = ""
    End Class
End Class