<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
 
<html> 
	<head>
		<title>OcraBaseAdmin</title>
	</head>
	<body bgcolor="#F0F0F0">
		<br><br><br><br><br><br><br><br>
		<center>
		<html:form action="/login">
			<table align="center">
				<tr>
					<td>
						<img src="./img/logo.png" border="0" />
					</td>
				</tr>
				<tr>
					<td>
						<br/><br/>
					</td>
				</tr>
				<tr>
					<td align="right">
						<bean:message key="prompt.username"/> : <html:text property="username"/><html:errors property="username"/><br/>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
					</td>
				</tr>
				<tr>
					<td align="right">
						<bean:message key="prompt.password"/> : <html:password property="password"/><html:errors property="password"/><br/>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
					</td>
				</tr>
				<tr>
					<td align="right">
						<html:submit>
							<bean:message key="prompt.submit"/>
						</html:submit>
						<html:reset>
							<bean:message key="prompt.reset"/>
						</html:reset>
					</td>
				</tr>
			</table>
		</html:form>
		</center>
	</body>
</html>

