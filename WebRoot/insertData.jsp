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
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<script language="javascript">
		function insertDataCheck() {
			var tab = document.getElementById("insertData");
			var rowLength = tab.rows.length - 1;
			
			var i = 1;
			var obj;
			
			obj = document.getElementsByName('rowKey')[0];
			var content = obj.value.trim();
			if(content.length == 0) {
				obj.focus();
				alert('Please fill in the row key.');
				return false;
			}
			
			for(i = 1;i < rowLength;i++) {
				obj = document.getElementsByName('qualifier(qualifier_' + i + ')')[0];
				s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the qualifier.');
					return false;
				}
				
				obj = document.getElementsByName('value(value_' + i + ')')[0];
				s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the value.');
					return false;
				}
			}
			return true;
		}
	
		function addQualifier(str) {
			var tab = document.getElementById("insertData");
			var rowLength = tab.rows.length - 1;
			var newtr = tab.insertRow(rowLength);
			newtr.id = 'row_' + rowLength;
			
			var newtd_3 = newtr.insertCell(0);
			var newtd_2 = newtr.insertCell(0);
			var newtd_1 = newtr.insertCell(0);
			
			if(rowLength % 2 == 0) {
				newtd_1.className = "row2";
				newtd_2.className = "row2";
				newtd_3.className = "row2";
			}
			else {
				newtd_1.className = "row1";
				newtd_2.className = "row1";
				newtd_3.className = "row1";
			}
			
			var strs = new Array();
			strs = str.split(',');
			
			var temp = '<select name="familyName(familyName_' + rowLength + ')">';
			var i = 0;
			for(i = 0;i < strs.length;i++) {
				temp = temp + '<option value="' + strs[i] + '">' + strs[i] + '</option>';
			}
			temp = temp + '</select>';
			
			newtd_1.innerHTML = temp;
			newtd_2.innerHTML = '<input type="text" name="qualifier(qualifier_' + rowLength + ')">';
			newtd_3.innerHTML = '<input type="text" name="values(values_' + rowLength + ')">';
		}
		
		function deleteQualifier() {
			var tab = document.getElementById("insertData");
			var rowLength = tab.rows.length - 2;
			if(rowLength >= 2) {
				tab.deleteRow(rowLength);
			}
		}
	</script>
	
	<%
		String tableName = (String)request.getAttribute("tableName");
		List<String> columnFamily = (List<String>)request.getAttribute("columnFamily");
		String err = (String)request.getAttribute("err");
		
		String para = new String();
		for(String s : columnFamily) {
			if(para.equals("")) {
				para = para + s;
			}
			else {
				para = para + "," + s;
			}
		}
	%>

  </head>
  
  <body bgcolor="#FFFFFF">
  	<input type="hidden" name="tableName" value="<%= tableName %>">
    <jsp:include page="tableDetailTab.jsp">
		<jsp:param name="section" value="insertData"/>
	</jsp:include>
	
	<div style="background-color: threedface">
	
		<br>
		
		<form name="insertDataForm" action="<%=basePath%>insertData.do" method="post" onsubmit="return insertDataCheck()">
			<table cellpadding="2" cellspacing="2" border="0">
				<tr>
					<td>
						<b>
							<bean:message key="prompt.rowKey"/>
						</b>
					</td>
					<td>
						<input type="text" name="rowKey">
					</td>
					<td>
						<%
							if(err != null) {
						%>
						<%=err %>
						<%
							}
						%>
					</td>
					<td>
						<input type="hidden" name="tableName" value="<%=tableName %>">
					</td>
				</tr>
			</table>
			
			<br>
			
			<table cellpadding="2" cellspacing="2" border="0" id="insertData">
		  		<tr>
		    		<th align="center">
		    			<bean:message key="prompt.familyName"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.qualifier"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.value"/>
		    		</th>
		    	</tr>
		    	
		
				<tr id="row_1">
					<td class="row1">
						<select name="familyName(familyName_1)">
							<%
								for(String s : columnFamily) {
							%>
							<option value = "<%=s %>">
								<%=s %>
							</option>
							<%
								}
							%>
						</select>
					</td>
					<td class="row1">
						<input type="text" name="qualifier(qualifier_1)">
					</td>
					<td class="row1">
						<input type="text" name="values(values_1)">
					</td>
				</tr>
		    	
		    	<tr align="right">
		    		<td>
		    			<input type="button" value="Add Qualifier" onClick="addQualifier('<%=para%>')">
		    		</td>
		    		<td>
		    			<input type="button" value="Delete Qualifier" onClick="deleteQualifier()">
		    		</td>
		    		<td>
		    			<input type="submit" value="Submit">
		    		</td>
		    	</tr>
		    </table>
	    </form>
	    
	    <br>
	    
	</div>
	
  </body>
</html>
