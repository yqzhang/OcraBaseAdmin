<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page import = "com.ocrabaseadmin.operation.dataOperation" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="/loginCheck.jsp" />
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
		String tableName = (String)request.getAttribute("tableName");
	%>

  </head>
  
  <body bgcolor="#FFFFFF">
  
  	<input type="hidden" name="tableName" value="<%= tableName %>">
    <jsp:include page="tableDetailTab.jsp">
		<jsp:param name="section" value="queryData"/>
	</jsp:include>
	
	<div style="background-color: threedface">
	
		<br>
		
		<html:form action="/queryData" target="queryDataFrame">
			<html:textarea property="query" style="width:80%; height:20%" ></html:textarea>
				
			<br><br>
				
			<html:submit>
				<bean:message key="prompt.submit"/>
			</html:submit>
			<html:reset>
				<bean:message key="prompt.reset"/>
			</html:reset>
		</html:form>
			
		<iframe id="queryDataFrame" width="80%" height="50%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
		</iframe>
  		
  		<br>
  		
	</div>
  </body>
</html>
