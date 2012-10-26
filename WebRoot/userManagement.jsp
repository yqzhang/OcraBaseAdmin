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
	
	<script src="./js/jquery-1.6.2.js"></script>
	<script src="./js/ui/jquery.ui.core.js"></script>
	<script src="./js/ui/jquery.ui.widget.js"></script>
	<script src="./js/ui/jquery.ui.tabs.js"></script>

	<link rel="stylesheet" href="<html:rewrite page="/css/demos.css"/>">
	
	<link rel="stylesheet" href="<html:rewrite page="/css/themes/jquery.ui.all.css"/>">

	<%
		String managementType = (String)request.getAttribute("type");
	%>

	<script type="text/javascript">
		$(function() {
			$( "#tabs" ).tabs();
			<%
				if(managementType.equals("group")) {
					out.println("$( \"#tabs\" ).tabs(\"select\",0);");
				}
				else {
					out.println("$( \"#tabs\" ).tabs(\"select\",1);");
				}
			%>
		});
	</script>
	
	<script type="text/javascript">
		function addGroup(line) {
			var username = document.getElementById('username' + line).innerHTML;
			username = username.replace(new RegExp('\n','g'),'');
			var group = document.getElementById('addGroup' + line).value;
			
			//alert('username:' + username + 'group:' + group);
			if(group.length > 0) {
				window.location='<%=basePath%>addGroupToUser.do?username=' + username + '&group=' + group;
			}
		}
		
		function deleteGroup(line) {
			var username = document.getElementById('username' + line).innerHTML;
			username = username.replace(new RegExp('\n','g'),'');
			var group = document.getElementById('deleteGroup' + line).value;
			
			//alert('username:' + username + 'group:' + group);
			
			window.location='<%=basePath%>deleteGroupFromUser.do?username=' + username + '&group=' + group;
		}
	</script>
	
	<%
		Map<byte[], List<byte[]>> users = null;
		
		users = (Map<byte[], List<byte[]>>)request.getAttribute("users");
	%>

  </head>
  
  <body bgcolor="#FFFFFF">
  
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.userManagement"/>
			</td>
		</tr>
	</table>
	
	<br><br>
  
  	<div class="demo">
  
	  	<div id="tabs">
	  		<ul>
	  			<li><a href="#tabs-1">Group Management</a></li>
	  			<li><a href="#tabs-2">User Management</a></li>
	  		</ul>
	  		
	  		<div id="tabs-1">
	  			<table>
	  				<tr>
	  					<th>
	  						Username
	  					</th>
	  					<th>
	  						Group
	  					</th>
	  					<th>
	  						Add Group
	  					</th>
	  					<th>
	  						Delete Group
	  					</th>
	  				</tr>
		  		<%
		  			int j = 0;
		  			String cssClass = new String();
		  			List<byte[]> tempList = null;
		  			for(Map.Entry<byte[],List<byte[]>> entry : users.entrySet()) {
		  				cssClass = (j % 2 == 0) ? "row1" : "row2";
		  				
		  				out.println("<tr>");
		  				
		  				out.println("<td class=\"" + cssClass + "\" id=\"username" + j + "\">");
	  					out.println(Bytes.toString(entry.getKey()));
	  					out.println("</td>");
	  					
	  					out.println("<td class=\"" + cssClass + "\" >");
	  					tempList = entry.getValue();
	  					for(byte[] b : tempList) {
	  						out.print(Bytes.toString(b) + " ");
	  					}
	  					out.println("</td>");
	  					
	  					out.println("<td class=\"" + cssClass + "\" >");
	  					out.println("<input type=\"text\" id=\"addGroup" + j + "\">");
	  					out.println("<input type=\"button\" value=\"Add\" onClick=\"addGroup(" + j +")\">");
	  					out.println("</td>");
	  					
	  					out.println("<td class=\"" + cssClass + "\" >");
	  					out.println("<select id=\"deleteGroup" + j + "\">");
	  					tempList = entry.getValue();
	  					for(byte[] b : tempList) {
	  						out.print("<option value=\"" + Bytes.toString(b) + "\">" + Bytes.toString(b) + "</option>");
	  					}
	  					out.println("</select>");
	  					out.println("<input type=\"button\" value=\"Delete\" onClick=\"deleteGroup(" + j +")\">");
	  					out.println("</td>");
	  					
		  				out.println("</tr>");
		  				
		  				j++;
		  			}
		  		%>
		  		</table>
	  		</div>
	  		
	  		<div id="tabs-2">
	  			<table>
	  				<tr>
	  					<th>
	  						Username
	  					</th>
	  					<th>
	  						Delete
	  					</th>
	  				</tr>
	  				
	  				<%
	  					int k = 0;
	  					for(Map.Entry<byte[],List<byte[]>> entry : users.entrySet()) {
	  						cssClass = (k % 2 == 0) ? "row1" : "row2";
	  						
	  						out.println("<tr>");
	  						
	  						out.println("<td class=\"" + cssClass + "\">");
	  						out.println(Bytes.toString(entry.getKey()));
	  						out.println("</td>");
	  						
	  						out.println("<td class=\"" + cssClass + "\">");
	  						out.println("<a href=\"" + basePath + "deleteUser.do?username=" + Bytes.toString(entry.getKey()) + "\">Delete</a>");
	  						out.println("</td>");
	  						
	  						out.println("</tr>");
	  						
	  						k++;
	  					}
	  				%>
	  			</table>
	  			
	  			<br><br>
	  			
	  			<b>Add User</b>
	  			<br>
	  			<html:form action="addUser.do">
		  			<table>
		  				<tr>
		  					<th>
		  						Username
		  					</th>
		  					<th>
		  						Password
		  					</th>
		  					<th>
		  						Confirm Password
		  					</th>
		  				</tr>
		  				
		  				<tr>
		  					<td class="row1">
		  						<html:text property="username"></html:text>
		  						<html:errors property="usernameError"/>
		  					</td>
		  					<td class="row1">
		  						<html:password property="password"></html:password>
		  					</td>
		  					<td class="row1">
		  						<html:password property="confirmPassword"></html:password>
		  						<html:errors property="confirmPasswordError"/>
		  					</td>
		  				</tr>
		  				
		  				<tr>
		  					<td class="row2">
		  					</td>
		  					<td class="row2">
		  					</td>
		  					<td class="row2">
		  						<html:reset value="Reset"></html:reset>
		  						<html:submit value="Submit"></html:submit>
		  					</td>
		  				</tr>
		  			</table>
	  			</html:form>
	  		</div>
	  	</div>
	  </div>
  </body>
</html>
