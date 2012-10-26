<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<jsp:include page="/loginCheck.jsp" />
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
	
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css"/>">

  </head>
  
  <body>
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.userProfile"/>
			</td>
		</tr>
	</table>
	
	<br><br>
	
	<html:form action="/changePassword.do">
		<table align="center">
			<tr>
				<td class="row1">
					<b>
						Username
					</b>
				</td>
				<td class="row1">
					<b>
						<%
							out.println((String)request.getSession().getAttribute("username"));
						%>
					</b>
				</td>
			</tr>
			<tr>
				<td class="row2">
					<b>
						Password
					</b>
				</td>
				<td class="row2">
					<html:password property="password"></html:password>
				</td>
			</tr>
			<tr>
				<td class="row1">
					<b>
						New Password
					</b>
				</td>
				<td class="row1">
					<html:password property="newPassword"></html:password>
				</td>
			</tr>
			<tr>
				<td class="row2">
					<b>
						Confirm Password
					</b>
				</td>
				<td class="row2">
					<html:password property="confirmPassword"></html:password>
				</td>
			</tr>
			<tr>
				<td class="row1">
					<html:reset>Reset</html:reset>
				</td>
				<td class="row1">
					<html:submit>Submit</html:submit>
				</td>
			</tr>
		</table>
	</html:form>
	
	<br><br>
	
  </body>
</html>
