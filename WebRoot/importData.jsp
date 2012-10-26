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
	
	<script type="text/javascript">
		function changeRowKey() {
			var obj = document.getElementsByName('isRowKey')[0];
			var tab = document.getElementById('importData');
			var rowLength = tab.rows.length;
			
			if(obj.checked) {
				tab.deleteRow(rowLength - 1);
			
				var newtr = tab.insertRow(rowLength - 1);
				newtr.id = 'rowKeyLength';
				
				var newtd_2 = newtr.insertCell(0);
				var newtd_1 = newtr.insertCell(0);
				
				newtd_1.className = 'row1';
				newtd_2.className = 'row1';
				
				newtd_1.innerHTML = '<b>Length of Row Key</b>';
				newtd_2.innerHTML = '<input type="text" name="rowKeyLength"><input type="submit" value="isSuitable" onClick="subAction(\'rowKeyCheck.do\')">';
			}
			else {
				tab.deleteRow(rowLength - 1);
				
				var newtr = tab.insertRow(rowLength - 1);
				newtr.id = 'ifOrdered';
				
				var newtd_2 = newtr.insertCell(0);
				var newtd_1 = newtr.insertCell(0);
				
				newtd_1.className = 'row1';
				newtd_2.className = 'row1';
				
				newtd_1.innerHTML = '<b>If Ordered</b>';
				newtd_2.innerHTML = '<input type="checkBox" name="ifOrdered">';
			}
		}
		
		function addFormat(str) {
			var tab = document.getElementById("dataFormat");
			var rowLength = tab.rows.length - 2;
			var newtr = tab.insertRow(rowLength);
			newtr.id = 'row_' + rowLength;
			
			var newtd_2 = newtr.insertCell(0);
			var newtd_1 = newtr.insertCell(0);
			
			if(rowLength % 2 == 0) {
				newtd_1.className = "row2";
				newtd_2.className = "row2";
			}
			else {
				newtd_1.className = "row1";
				newtd_2.className = "row1";
			}
			
			var strs = new Array();
			strs = str.split(',');
			
			var temp = '<select name="columnFamily(columnFamily_' + rowLength + ')">';
			var i = 0;
			for(i = 0;i < strs.length;i++) {
				temp = temp + '<option value="' + strs[i] + '">' + strs[i] + '</option>';
			}
			temp = temp + '</select>';
			
			newtd_1.innerHTML = temp;
			newtd_2.innerHTML = '<input type="text" name="columnName(columnName_' + rowLength + ')">';
		}
		
		function deleteFormat() {
			var tab = document.getElementById("dataFormat");
			var rowLength = tab.rows.length - 3;
			if(rowLength >= 2) {
				tab.deleteRow(rowLength);
			}
		}
		
		function subAction(formAction) {
			var targetForm = document.importDataForm;
			targetForm.action = formAction;
			targetForm.submit();
		}
	</script>
	
	<%
		String tableName = (String)request.getAttribute("tableName");
		List<String> columnFamily = (List<String>)request.getAttribute("columnFamily");
		
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
		<jsp:param name="section" value="importData"/>
	</jsp:include>
	
	<div style="background-color: threedface">
	
		<br>
	
		<form name="importDataForm" method="post" onsubmit="return importDataCheck()">
			<table cellpadding="2" cellspacing="2" border="0" id="importData">
				<tr>
					<td class="row1">
						<b>
							<bean:message key="prompt.sourceDirectory"/>
						</b>
					</td>
					<td class="row1">
						<input type="text" name="sourceDirectory">
					</td>
					<td>
						<input type="hidden" name="tableName" value="<%=tableName %>">
					</td>
				</tr>
				<tr>
					<td class="row2">
						<b>
							<bean:message key="prompt.separator"/>
						</b>
					</td>
					<td class="row2">
						<select name="separator">
							<option value="tab">TAB</option>
							<option value="space">SPACE</option>
							<option value="comma">COMMA</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="row1">
						<b>
							<bean:message key="prompt.isBulkload"/>
						</b>
					</td>
					<td class="row1">
						<input type="checkBox" name="isBulkload">
					</td>
				</tr>
				<tr>
					<td class="row2">
						<b>
							<bean:message key="prompt.isRowKey"/>
						</b>
					</td>
					<td class="row2">
						<input type="checkBox" name="isRowKey" onChange="changeRowKey()">
					</td>
				</tr>
				<tr id="ifOrdered">
					<td class="row1">
						<b>
							If Ordered
						</b>
					</td>
					<td class="row1">
						<input type="checkBox" name="ifOrdered">
					</td>
				</tr>
			</table>
			
			<br>
			
			<b>
				<bean:message key="prompt.dataFormat"/>
			</b>
			
			<table cellpadding="2" cellspacing="2" border="0" id="dataFormat">
		  		<tr>
		    		<th align="center">
		    			<bean:message key="prompt.columnName"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.qualifier"/>
		    		</th>
		    	</tr>
		    	<tr id="row_1">
		    		<td class="row1">
			    		<select name="columnFamily(columnFamily_1)">
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
		    			<input type="text" name="columnName(columnName_1)">
		    		</td>
		    	</tr>
		    	
		    	<tr align="right">
		    		<td>
		    			<input type="button" value="Add Format" onClick="addFormat('<%= para %>')">
		    		</td>
		    		<td>
		    			<input type="button" value="Delete Format" onClick="deleteFormat()">
		    		</td>
		    	</tr>
		    	
		    	<tr align="right">
		    		<td>
		    		</td>
		    		<td>
		    			<input type="submit" value="Submit" onClick="subAction('importData.do')">
		    		</td>
		    	</tr>
			</table>
		</form>
		
		<br>
		
	</div>
  </body>
</html>
