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
		List<String> headers = (List<String>)request.getAttribute("headers");
		List<HashMap<String,List<String>>> records = (List<HashMap<String,List<String>>>)request.getAttribute("records");
		List<String> rowKey = (List<String>)request.getAttribute("rowKey");
		
		dataOperation dao = (dataOperation)request.getAttribute("dataOperation");
		
		request.getSession().setAttribute("dataOperation",dao);
		
		String nextPage = (String)request.getAttribute("nextPage");
	%>

  </head>
  
  <body bgcolor="#FFFFFF">
  
  	<%
  		if(nextPage != null && nextPage.equals("true") && records.size() == 0) {
  	%>
  		<script type="text/javascript">
  			alert('It is end of the data.');
  			window.location = ('/viewTableDetail.do?tableName=<%= tableName %>&type=browseTable');
  		</script>
  	<%
  		}
  	%>
  
  	<input type="hidden" name="tableName" value="<%= tableName %>">
    <jsp:include page="tableDetailTab.jsp">
		<jsp:param name="section" value="browseTable"/>
	</jsp:include>
	
	<div style="background-color: threedface">
	
		<br>
		
		<table>
			<tr>
				<td>
					<table border="0" cellpadding="5" cellspacing="2">
						<tr>
							<th>
								<bean:message key="prompt.rowKey"/>
							</th>
  						<%
  							
  							for(String s : headers) {
  								out.println("<th>" + s + "</th>");
  							}
  						%>
  							<th>
  								<bean:message key="prompt.delete"/>
  							</th>
  						</tr>
  						<%
  							String cssClass = new String();
 							int i = 0;
  							for(HashMap<String,List<String>> hm : records) {
  								cssClass = (i % 2 == 0) ? "row1" : "row2";
  						%>
  						<tr class="<%=cssClass %>">
  						<%
  								out.println("<td>" + rowKey.get(i) + "</td>");
  								for(String s : headers) {
  									List<String> ls = hm.get(s);
  									if(ls == null) {
  										out.println("<td>null</td>");
  									}
  									else {
  										out.println("<td>");
	  									for(String ss : ls) {
	  										out.println(ss);
	  										out.println("&nbsp;");
	  									}
	  									out.println("</td>");
  									}
  								}
  								
  								out.println("<td>");
  								out.println("<a href=\"/deleteData.do?tableName=" + tableName + "&rowKey=" + rowKey.get(i) + "\">");
  								out.println("Delete");
  								out.println("</a>");
  						%>
  						</tr>
  						<%
  								i++;
  							}
  						%>
  						<tr>
  							<td>
	  							<a href="/viewTableDetail.do?tableName=<%=tableName %>&type=insertData">
	  								<bean:message key="prompt.insertData"/>
	  							</a>
  							</td>
  							<%
  								for(int k = 0;k < headers.size();k++) {
  							%>
  							<td>
  							</td>
  							<%
  								}
  							%>
  							<td>
  								<b>
	  								<a href="/viewTableDetail.do?tableName=<%=tableName %>&type=browseTable&nextPage=true">
		  								<bean:message key="prompt.nextPage"/>
		  							</a>
	  							</b>
  							</td>
  						</tr>
  					</table>
  				</td>
  			</tr>
  		</table>
  		
  		<br>
  		
	</div>
  </body>
</html>
