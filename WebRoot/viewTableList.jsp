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
    <script language="JavaScript" type="text/javascript" src="/js/function.js"></script>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<%
		Object tempTableList = request.getAttribute("tableList");
		List<String> tableList = null;
		if(tempTableList != null) {
			tableList = (List<String>) tempTableList;
		}
	%>
	
  </head>
  
  <body bgcolor="#FFFFFF">
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br><br>
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
  		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.tableList"/>
  			</td>
  		</tr>
	</table>
	
	<table>
		<tr>
			<td>
				<table cellpadding="2" cellspacing="2" width="100%" border="0">
					<tr>
						<td colspan="5">
							<br>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th align="center">
							&nbsp;
						</th>
						<th align="center">
							<b>
								<bean:message key="prompt.tableName"/>
							</b>
						</th>
						<th align="center">
							<b>
								<bean:message key="prompt.regionCount"/>
							</b>
						</th>
						<th align="center">
							<b>
								<bean:message key="prompt.isLocked"/>
							</b>
						</th>
						<th align="center">
							<b>
								<bean:message key="prompt.operation"/>
							</b>
						</th>
					</tr>
					<%
						if(tableList == null || tableList.size() == 0) {
					%>
					<tr>
						<td class="title" style="background-color: threedface">
							<bean:message key="prompt.noTable"/>
						</td>
						<td class="title" style="background-color: threedface">
							<a href="/createTable.jsp">
								<bean:message key="prompt.createTable"/>
							</a>
						</td>
					</tr>
					<%
						}
						else {
							int i = 0;
							String cssClass = null;
							String[] tempTable = null;
							String tableName = null;
							String regionCount = null;
							String isActive = null;
							for(String table : tableList) {
								cssClass = ((i%2)==0) ? "row1" : "row2";
								tempTable = table.split(",");
								tableName = tempTable[0];
								regionCount = tempTable[1];
								isActive = tempTable[2];
					%>
					<tr>
						<td class="<%= cssClass %>">
							<input type="checkbox" name="tableName" value="<%= tableName %>">
						</td>
						<td class="<%= cssClass %>" align="center">
							<%= tableName %>
						</td>
						<td class="<%= cssClass %>" align="center">
							<%= regionCount %>
						</td>
						<td class="<%= cssClass %>" align="center">
							<%= isActive %>
						</td>
						<td class="<%= cssClass %>" align="center">
							<%
								if(isActive.equals("false")) {
							%>
							<a href="viewTableDetail.do?tableName=<%= tableName %>&type=viewDescriptor">
								<bean:message key="prompt.viewDescriptor"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.viewDescriptor"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="viewTableDetail.do?tableName=<%= tableName %>&type=browseTable">
								<bean:message key="prompt.browseTable"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.browseTable"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="viewTableDetail.do?tableName=<%= tableName %>&type=insertData">
								<bean:message key="prompt.insertData"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.insertData"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="viewTableDetail.do?tableName=<%= tableName %>&type=importData">
								<bean:message key="prompt.importData"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.importData"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="viewTableDetail.do?tableName=<%= tableName %>&type=queryData">
								<bean:message key="prompt.queryData"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.queryData"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="javascript:areYouSure('/viewTableDetail.do?tableName=<%= tableName %>&type=emptyTable')">
								<bean:message key="prompt.emptyTable"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.emptyTable"/>
							<%
								}
							%>
							&nbsp;&nbsp;&nbsp;
							<%
								if(isActive.equals("false")) {
							%>
							<a href="javascript:areYouSure('/viewTableDetail.do?tableName=<%= tableName %>&type=dropTable')">
								<bean:message key="prompt.dropTable"/>
							</a>
							<%
								}
								else {
							%>
							<bean:message key="prompt.dropTable"/>
							<%
								}
							%>
						</td>
					</tr>
					
					<%
								i++;
							}
					%>
					<tr>
						<td>
						</td>
						<td>
							<a href="/createTable.jsp">
								<bean:message key="prompt.createTable"/>
							</a>
						</td>
					</tr>
					<tr>
  						<td colspan="5">
  							&nbsp;
  						</td>
					</tr>
					<%
						}
					%>
				</table>
			</td>
		</tr>
	</table>
								
									
  </body>
</html>
