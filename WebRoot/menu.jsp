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
    
    <title></title>
    
    <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css"/>">
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<%
		Object tempTableList = request.getAttribute("tableList");
		List<String> tableList = null;
		if(tempTableList != null) {
			tableList = (List<String>) tempTableList;
		}
		boolean ifAdmin = true;
		Object temp = request.getSession().getAttribute("usertype");
		if(temp != null) {
			ifAdmin = ((String)temp).equals("admin") ? true : false;
		}
	%>

  </head>
  
  <body topmargin="0" leftmargin="0" bgcolor="#F0F0F0">
  
  	<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="center">
				<br>
				&nbsp;&nbsp;
				<html:link target="_blank" href="http://www.ccindex.org/wiki/">
					<html:img border="0" width="155" height="30" page="/img/minilogo.png"/>
				</html:link>
			</td>
		</tr>
	</table>
	
	<table cellpadding="2" cellspacing="2" border="0">
		<tr>
  			<td colspan="2">
  				&nbsp;
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/getConfiguration.do">
  					<bean:message key="prompt.home"/>
  				</html:link>
  				<br>
  				<br>
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<b>
  					<html:link target="main" page="/viewTableList.do">
  						<bean:message key="prompt.tableList"/>
  					</html:link>
  				</b>
  			</td>
		</tr>
		
		<%
			if(tableList == null) {
		%>
				<tr>
					<td>
						&nbsp;&nbsp;
						<bean:message key="prompt.noTable"/>
					</td>
				</tr>
		<%
			}
			else {
				for(String tableName : tableList) {
		%>
					<tr>
						<td>
							&nbsp;&nbsp;
							<html:img align="top" border="0" width="16" height="16" page="/img/icons/tb.gif"/>
								<a title="<%= tableName %>" class="menuTable" target="main" href="/viewTableDetail.do?tableName=<%= tableName %>&type=viewDescriptor">
									<%= tableName %>
								</a>
								<br>
						</td>
					</tr>
		<%
				}
			}
		%>
		
		<tr>
  			<td colspan="2">
  				&nbsp;&nbsp;
  				<html:link target="main" page="/createTable.jsp">
  					<bean:message key="prompt.createTable"/>
  				</html:link>
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				&nbsp;&nbsp;
  				<html:link page="/getTableList.do">
  					<bean:message key="prompt.refresh"/>
  				</html:link>
  			</td>
		</tr>
		
		<tr>
			<td>
				<br>
			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/taskMonitor.do">
  					<bean:message key="prompt.taskMonitor"/>
  				</html:link>
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/maintenanceTools.jsp">
  					<bean:message key="prompt.maintenanceTools"/>
  				</html:link>
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/performanceTest.jsp">
  					<bean:message key="prompt.performanceTest"/>
  				</html:link>
  			</td>
		</tr>
		
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/getAuthorityInfo.do">
  					<bean:message key="prompt.accessControl"/>
  				</html:link>
  			</td>
		</tr>
		
		<%
			if(ifAdmin) {
		%>
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/getUserManagementInfo.do">
  					<bean:message key="prompt.userManagement"/>
  				</html:link>
  			</td>
		</tr>
		<%
			}
		%>
		
		<%
			if(!ifAdmin) {
		%>
		<tr>
  			<td colspan="2">
  				<html:link target="main" page="/userProfile.jsp">
  					<bean:message key="prompt.userProfile"/>
  				</html:link>
  			</td>
		</tr>
		<%
			}
		%>
	</table>
  </body>
</html>
