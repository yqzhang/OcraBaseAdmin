<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<%
		String emptyTableError = (String)request.getAttribute("emptyTableError");
		String tableName = (String)request.getAttribute("tableName");
	%>
  </head>
  
  <body>
  	<%
  		if(emptyTableError == null) {
  	%>
  	<script>
  		alert('Empty Table Successfully.');
  		window.location = '<%= basePath %>viewTableDetail.do?tableName=<%= tableName%>&type=viewDescriptor';
  	</script>
  	<%
  		}
  		else {
  	%>
  	<script>
  		alert(<%=emptyTableError %>);
  		window.history.go(-1);
  	</script>
  	<%
  		}
  	%>
  </body>
</html>
