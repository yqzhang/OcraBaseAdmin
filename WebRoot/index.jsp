<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<jsp:include page="/loginCheck.jsp" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>OcraBaseAdmin</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="/css/styles.css">
	-->
	
	<frameset  cols="170,2,*">
    	<frame name="menu"  src="<html:rewrite page="/getTableList.do"/>"  marginwidth="10" marginheight="10" scrolling="auto" frameborder="0">
    	<frame name="black" src="<html:rewrite page="/black.jsp"/>" marginwidth="10" marginheight="10" scrolling="auto" frameborder="0" scrolling="no" noresize>
    	<frame name="main"  src="<html:rewrite page="/getConfiguration.do"/>"  marginwidth="10" marginheight="10" scrolling="auto" frameborder="0">
	</frameset>
  </head>
  
  <body>

  </body>
</html>
