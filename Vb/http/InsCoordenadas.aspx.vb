Imports TriLibs
Imports System.Web.Script.Serialization

Public Class InsCoordenadas
    Inherits System.Web.UI.Page
    Dim USU_ID As String = ""
    Dim USU_LAT As String = ""
    Dim USU_LNG As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        USU_ID = Request("USU_ID")
        USU_LAT = Request("USU_LAT")
        USU_LNG = Request("USU_LNG")

        Dim Js As New JavaScriptSerializer
        Dim R As New Respuesta
        Try
            Dim d As New Db("USUARIO_COORDENADA_UPD")
            d.addParameter("@USU_ID", USU_ID)
            d.addParameter("@USU_LAT", Replace(USU_LAT, ",", "."))
            d.addParameter("@USU_LNG", Replace(USU_LNG, ",", "."))
            d.DataSetFill()
        Catch ex As Exception
            R.success = False
            R.msjInfo = ex.Message
        End Try
        Response.Write(Js.Serialize(R))
    End Sub
    Private Class Respuesta
        Public success As Boolean = True
        Public msjInfo As String = "Coordenadas guardadas"
    End Class

End Class