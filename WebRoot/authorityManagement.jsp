<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page import="org.apache.hadoop.security.ACLField"
	import="org.apache.hadoop.hbase.util.Bytes"
	import="java.util.Map"
	import="java.util.List"
	import="java.util.HashMap" %>

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
	
	<script type="text/javascript">
		function changeAuthority(line) {
			var tablename = document.getElementById('tablename' + line).innerHTML;
			var user = document.getElementById('user' + line).value;
			var group = document.getElementById('group' + line).value;
			var authority = 0;
			
			if(document.getElementById('own_r' + line).checked) {
				authority += 32;
			}
			
			if(document.getElementById('own_w' + line).checked) {
				authority += 16;
			}
			
			if(document.getElementById('group_r' + line).checked) {
				authority += 8;
			}
			
			if(document.getElementById('group_w' + line).checked) {
				authority += 4;
			}
			
			if(document.getElementById('other_r' + line).checked) {
				authority += 2;
			}
			
			if(document.getElementById('other_w' + line).checked) {
				authority += 1;
			}
			
			window.location.href = "<%=basePath%>changeAuthority.do?tablename=" + tablename + "&user=" + user + "&group=" + group + "&authority=" + authority;
		}
	</script>
	
	<%
		Map<byte[],ACLField> tables = (Map<byte[],ACLField>)request.getAttribute("tables");
	%>

  </head>
  
  <body bgcolor="#FFFFFF">
  
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.accessControl"/>
			</td>
		</tr>
	</table>
	
	<br><br>
  
	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
			<th>
				Table Name
			</th>
			<th>
				User
			</th>
			<th>
				Group
			</th>
			<th>
				own-r
			</th>
			<th>
				own-w
			</th>
			<th>
				group-r
			</th>
			<th>
				group-w
			</th>
			<th>
				other-r
			</th>
			<th>
				other-w
			</th>
			<th>
				Change
			</th>
		</tr>
	<%
		int i = 0;
		String cssClass = new String();
		for(Map.Entry<byte[], ACLField> entry : tables.entrySet()) {
			cssClass = (i % 2 == 0) ? "row1" : "row2";
			out.println("<tr><td class=\"" + cssClass + "\"><b id=\"tablename" + i + "\">");
			out.println(Bytes.toString(entry.getKey()));
			out.println("</b></td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			out.println("<input type=\"text\" id=\"user" + i + "\" value=\"" + Bytes.toString(entry.getValue().getUser()) + "\">");
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			out.println("<input type=\"text\" id=\"group" + i + "\" value=\"" + Bytes.toString(entry.getValue().getGroup()) + "\">");
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 32) != 0) {
				out.println("<input type=\"checkbox\" id=\"own_r" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"own_r" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 16) != 0) {
				out.println("<input type=\"checkbox\" id=\"own_w" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"own_w" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 8) != 0) {
				out.println("<input type=\"checkbox\" id=\"group_r" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"group_r" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 4) != 0) {
				out.println("<input type=\"checkbox\" id=\"group_w" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"group_w" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 2) != 0) {
				out.println("<input type=\"checkbox\" id=\"other_r" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"other_r" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			if((entry.getValue().getMask() & 1) != 0) {
				out.println("<input type=\"checkbox\" id=\"other_w" + i +"\" checked=\"checked\">");
			}
			else {
				out.println("<input type=\"checkbox\" id=\"other_w" + i +"\">");
			}
			out.println("</td>");
			
			out.println("<td class=\"" + cssClass + "\">");
			out.println("<input type=\"button\" value=\"Change\" onClick=\"changeAuthority("  + i + ")\">");
			out.println("</td>");
			
			out.println("</tr>");
			
			i++;
		}
	%>
	</table>
	
	<br><br>
	
  </body>
</html>
