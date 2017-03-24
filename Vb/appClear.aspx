<%@ Page Language="VB" %>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="refresh" content="1;url=/" />
    <title></title>    
</head>
<body>
    <form id="form1" runat="server">   
        <% HttpRuntime.UnloadAppDomain() %>
    </form>
</body>
</html>
