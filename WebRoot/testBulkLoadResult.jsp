<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="ict.ocrabase.main.java.client.bulkload.BulkLoad" %>
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
    
    <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css"/>">
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<%
		BulkLoad bl = (BulkLoad)request.getSession().getAttribute("BULKLOAD");
	%>
	
  </head>
  
  <body>
    <table border="0" cellpadding="5" cellspacing="2">
    	<tr>
    		<th align="center">
    			<b>BulkLoad Result</b>
    		</th>
    	</tr>
    	<tr>
    		<td>
    			<%
    				out.println(bl.getResult());
    			%>
    		</td>
    	</tr>
    </table>
  </body>
</html>
