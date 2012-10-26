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
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css"/>">

	<script language="javascript">
		function createTableCheck() {
			var tab = document.getElementById("createTable");
			var rowLength = tab.rows.length - 1;
			
			var i = 1;
			var obj;
			
			obj = document.getElementsByName('tableName')[0];
			var content = obj.value.trim();
			if(content.length == 0) {
				obj.focus();
				alert('Please fill in the table name.');
				return false;
			}
			
			for(i = 1;i < rowLength;i++) {
				obj = document.getElementsByName('familyName(familyName_' + i + ')')[0];
				var s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the family name.');
					return false;
				}
				
				obj = document.getElementsByName('versions(versions_' + i + ')')[0];
				s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the versions.');
					return false;
				}
				
				obj = document.getElementsByName('ttl(ttl_' + i + ')')[0];
				s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the ttl.');
					return false;
				}
			}
			return true;
		}
	
		function addFamily() {
			var tab = document.getElementById("createTable");
			var rowLength = tab.rows.length - 1;
			var newtr = tab.insertRow(rowLength);
			newtr.id = 'row_' + rowLength;
			
			var newtd_7 = newtr.insertCell(0);
			var newtd_6 = newtr.insertCell(0);
			var newtd_5 = newtr.insertCell(0);
			var newtd_4 = newtr.insertCell(0);
			var newtd_3 = newtr.insertCell(0);
			var newtd_2 = newtr.insertCell(0);
			var newtd_1 = newtr.insertCell(0);
			
			if(rowLength % 2 == 0) {
				newtd_1.className = "row2";
				newtd_2.className = "row2";
				newtd_3.className = "row2";
				newtd_4.className = "row2";
				newtd_5.className = "row2";
				newtd_6.className = "row2";
				newtd_7.className = "row2";
			}
			else {
				newtd_1.className = "row1";
				newtd_2.className = "row1";
				newtd_3.className = "row1";
				newtd_4.className = "row1";
				newtd_5.className = "row1";
				newtd_6.className = "row1";
				newtd_7.className = "row1";
			}
			newtd_1.innerHTML = '<input type="text" name="familyName(familyName_' + rowLength + ')">';
			newtd_2.innerHTML = '<input type="text" name="versions(versions_' + rowLength + ')">';
			newtd_3.innerHTML = '<select name="compression(compression_' + rowLength + ')"><option value = "NONE">NONE</option><option value = "LZO">LZO</option><option value = "GZ">GZ</option></select>';
			newtd_4.innerHTML = '<input type="checkBox" name="inMemory(inMemory_' + rowLength + ')">';
			newtd_5.innerHTML = '<input type="checkBox" name="blockCache(blockCache_' + rowLength + ')">';
			newtd_6.innerHTML = '<input type="text" name="ttl(ttl_' + rowLength + ')">';
			newtd_7.innerHTML = '<select name="bloomFilter(bloomFilter_' + rowLength + ')"><option value = "NONE">NONE</option><option value = "ROW">ROW</option><option value = "ROWCOL">ROWCOL</option></select>';
		}
		
		function deleteFamily() {
			var tab = document.getElementById("createTable");
			var rowLength = tab.rows.length - 2;
			if(rowLength >= 2) {
				tab.deleteRow(rowLength);
			}
		}
	</script>

	<%
		String err = (String)request.getAttribute("error");
	%>
	
  </head>
  
  <body bgcolor="#FFFFFF">
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br><br>
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
  		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.createTable"/>
  			</td>
  		</tr>
	</table>
	
	<form name="createTableForm" action="<%=basePath%>createTable.do" method="post" onsubmit="return createTableCheck()">
		<table cellpadding="2" cellspacing="2" border="0">
			<tr>
				<td>
					<b>
						<bean:message key="prompt.tableName"/>
					</b>
				</td>
				<td>
					<input type="text" name="newTableName">
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
			</tr>
		</table>
		
		<br>
		
		<table cellpadding="2" cellspacing="2" border="0" id="createTable">
	  		<tr>
	    		<th align="center">
	    			<bean:message key="prompt.familyName"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.versions"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.compression"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.inMemory"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.blockCache"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.ttl"/>
	    		</th>
	    		<th align="center">
	    			<bean:message key="prompt.bloomFilter"/>
	    		</th>
	    	</tr>
	    	
	
			<tr id="row_1">
				<td class="row1">
					<input type="text" name="familyName(familyName_1)">
				</td>
				<td class="row1">
					<input type="text" name="versions(versions_1)">
				</td>
				<td class="row1">
					<select name="compression(compression_1)">
						<option value = "NONE">NONE</option>
						<option value = "LZO">LZO</option>
						<option value = "GZ">GZ</option>
					</select>
				</td>
				<td class="row1">
					<input type="checkBox" name="inMemory(inMemory_1)">
				</td>
				<td class="row1">
					<input type="checkBox" name="blockCache(blockCache_1)">
				</td>
				<td class="row1">
					<input type="text" name="ttl(ttl_1)">
				</td>
				<td class="row1">
					<select name="bloomFilter(bloomFilter_1)">
						<option value = "NONE">NONE</option>
						<option value = "ROW">ROW</option>
						<option value = "ROWCOL">ROWCOL</option>
					</select>
				</td>
			</tr>
	    	
	    	<tr align="right">
	    		<td>
	    			<input type="button" value="Add Family" onClick="addFamily()">
	    		</td>
	    		<td>
	    			<input type="button" value="Delete Family" onClick="deleteFamily()">
	    		</td>
	    		<td>
	    		</td>
	    		<td>
	    		</td>
	    		<td>
	    		</td>
	    		<td>
	    			
	    		</td>
	    		<td>
	    			<input type="submit" value="Submit">
	    		</td>
	    	</tr>
	    </table>
    </form>
  </body>
</html>
