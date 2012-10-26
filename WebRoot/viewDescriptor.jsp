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
	
	<%
		String tableName = (String)request.getAttribute("tableName");
		List<HashMap<String,Object>> tableDescriptor = (List<HashMap<String,Object>>)request.getAttribute("tableDescriptor");
		List<HashMap<String,Object>> indexDescriptor = (List<HashMap<String,Object>>)request.getAttribute("indexDescriptor");
		
		List<String> familyName = new LinkedList<String>();
		String para = new String();
		for(HashMap<String,Object> hm : tableDescriptor) {
			familyName.add((String)hm.get("familyName"));
			
			if(para.equals("")) {
				para = para + (String)hm.get("familyName");
			}
			else {
				para = para + "," + (String)hm.get("familyName");
			}
		}
	%>

	<script type="text/javascript">
		var ite = 1;
		var iteIndex = 1;
		
		function editIndexCheck() {
			var tab = document.getElementById("editIndex");
			var rowLength = iteIndex;
			
			var i = 1;
			var obj;
			
			for(i = 1;i < rowLength;i++) {
				obj = document.getElementsByName('qualifier(qualifier_' + i + ')')[0];
				s = obj.value.trim();
				if(s.length == 0) {
					obj.focus();
					alert('Please fill in the qualifier.');
					return false;
				}
			}
			return true;
		}
	
		function addIndex(str) {
			var tab = document.getElementById("editIndex");
			var rowLength = tab.rows.length - 1;
			var newtr = tab.insertRow(rowLength);
			newtr.id = 'row_' + iteIndex;
			
			var newtd_4 = newtr.insertCell(0);
			var newtd_3 = newtr.insertCell(0);
			var newtd_2 = newtr.insertCell(0);
			var newtd_1 = newtr.insertCell(0);
			
			if(rowLength % 2 == 0) {
				newtd_1.className = "row2";
				newtd_2.className = "row2";
				newtd_3.className = "row2";
				newtd_4.className = "row2";
			}
			else {
				newtd_1.className = "row1";
				newtd_2.className = "row1";
				newtd_3.className = "row1";
				newtd_4.className = "row1";
			}
			
			var strs = new Array();
			strs = str.split(',');
			
			var temp = '<select name="columnFamily(columnFamily_' + iteIndex + ')">';
			var i = 0;
			for(i = 0;i < strs.length;i++) {
				temp = temp + '<option value="' + strs[i] + '">' + strs[i] + '</option>';
			}
			temp = temp + '</select>';
			
			newtd_1.innerHTML = temp;
			newtd_2.innerHTML = '<input type="text" name="qualifier(qualifier_' + iteIndex + ')">';
			newtd_3.innerHTML = '<select name="indexType(indexType_' + iteIndex + ')"><option value="CCIndex">CCIndex</option><option value="secondaryIndex">Secondary Index</option></select>';
			newtd_4.innerHTML = '--';
			
			iteIndex++;
		}
		
		function deleteIndex() {
			var tab = document.getElementById("editIndex");
			var rowLength = tab.rows.length - 2;
			if(iteIndex >= 2) {
				tab.deleteRow(rowLength);
				iteIndex--;
			}
		}
		
		function addColumnCheck() {
			var tab = document.getElementById("tableDescriptor");
			var rowLength = ite;
			
			var i = 1;
			var obj;
			
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
			var tab = document.getElementById("tableDescriptor");
			var rowLength = tab.rows.length - 1;
			var newtr = tab.insertRow(rowLength);
			newtr.id = 'row_' + ite;
			
			var newtd_8 = newtr.insertCell(0);
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
				newtd_8.className = "row2";
			}
			else {
				newtd_1.className = "row1";
				newtd_2.className = "row1";
				newtd_3.className = "row1";
				newtd_4.className = "row1";
				newtd_5.className = "row1";
				newtd_6.className = "row1";
				newtd_7.className = "row1";
				newtd_8.className = "row1";
			}
			
			newtd_1.innerHTML = '<input type="text" name="familyName(familyName_' + ite + ')">';
			newtd_2.innerHTML = '<input type="text" name="versions(versions_' + ite + ')">';
			newtd_3.innerHTML = '<select name="compression(compression_' + ite + ')"><option value = "NONE">NONE</option><option value = "LZO">LZO</option><option value = "GZ">GZ</option></select>';
			newtd_4.innerHTML = '<input type="checkBox" name="inMemory(inMemory_' + ite + ')">';
			newtd_5.innerHTML = '<input type="checkBox" name="blockCache(blockCache_' + ite + ')">';
			newtd_6.innerHTML = '<input type="text" name="ttl(ttl_' + ite + ')">';
			newtd_7.innerHTML = '<select name="bloomFilter(bloomFilter_' + ite + ')"><option value = "NONE">NONE</option><option value = "ROW">ROW</option><option value = "ROWCOL">ROWCOL</option></select>';
			newtd_8.innerHTML = '--';
			
			ite++;
		}
		
		function deleteFamily() {
			var tab = document.getElementById("tableDescriptor");
			var rowLength = tab.rows.length - 2;
			if(ite >= 2) {
				tab.deleteRow(rowLength);
				ite--;
			}
		}
	</script>
  </head>
  
  <body bgcolor="#FFFFFF">
  	<input type="hidden" name="tableName" value="<%= tableName %>">
    <jsp:include page="tableDetailTab.jsp">
		<jsp:param name="section" value="viewDescriptor"/>
	</jsp:include>
	
	<div style="background-color: threedface">
	
		<br>
		
		<form name="tableDecriptorForm" action="<%=basePath %>addColumn.do" method="post" onsubmit="return addColumnCheck()">
			<input type="hidden" name="newTableName" value="<%=tableName %>">
			<table cellpadding="2" cellspacing="2" border="0" id="tableDescriptor">
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
		    		<th align="center">
		    			<bean:message key="prompt.delete"/>
		    		</th>
		    	</tr>
		    	
		    	<%
		    		int i = 0;
		    		String cssClass = new String();
		    		for(HashMap<String,Object> hm : tableDescriptor) {
		    			cssClass = (i % 2 == 0) ? "row1" : "row2";
		    	%>
		    	<tr>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=hm.get("familyName") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=hm.get("versions") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=hm.get("compression") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			--
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			--
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=hm.get("ttl") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=hm.get("bloomFilter") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%
		    				if(tableDescriptor.size() == 1) {
		    			%>
		    			<bean:message key="prompt.delete"/>
		    			<%
		    				}
		    				else {
		    			%>
		    			<a href="<%= basePath %>deleteFamily.do?tableName=<%=tableName %>&familyName=<%=hm.get("familyName") %>">
		    				<bean:message key="prompt.delete"/>
		    			</a>
		    			<%
		    				}
		    			%>
		    		</td>
		    	</tr>
		    	<%
		    			i++;
		    		}
		    	%>
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
		    		</td>
		    		<td>
		    			<input type="submit" value="Submit">
		    		</td>
		    	</tr>
			</table>
		</form>
		
		<br>
		
		<b>
			Index Descriptor
		</b>
		
		<form name="editIndexForm" action="<%=basePath%>editIndex.do" method="post" onsubmit="return editIndexCheck()">
			<input type="hidden" name="newTableName" value="<%=tableName %>">
			<table cellpadding="2" cellspacing="2" border="0" id="editIndex">
		  		<tr>
		    		<th align="center">
		    			<bean:message key="prompt.columnFamily"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.qualifier"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.indexType"/>
		    		</th>
		    		<th align="center">
		    			<bean:message key="prompt.delete"/>
		    		</th>
		    	</tr>
		    	
		    	<%
		    		int j = 0;
		    		cssClass = new String();
		    		if(indexDescriptor != null) {
			    		for(HashMap<String,Object> hm : indexDescriptor) {
			    			cssClass = (j % 2 == 0) ? "row1" : "row2";
			    			String temp = (String)hm.get("columnFamily");
			    			String[] tempStrs = temp.split(":");
			    			String cf = tempStrs[0];
			    			String c = tempStrs[1];
		    	%>
		    	<tr>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=cf %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=c %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<%=(String)hm.get("indexType") %>
		    		</td>
		    		<td class="<%=cssClass %>" align="center">
		    			<a href="<%= basePath %>deleteIndex.do?targetTableName=<%=tableName %>&familyName=<%=cf %>&columnName=<%=c %>">
		    				<bean:message key="prompt.delete"/>
		    			</a>
		    		</td>
		    	</tr>
		    	<%
			    			j++;
			    		}
			    	}
		    	%>
		    	
		    	<tr align="right">
		    		<td>
		    			<input type="button" value="Add Index" onClick="addIndex('<%= para %>')">
		    		</td>
		    		<td>
		    			<input type="button" value="Delete Index" onClick="deleteIndex()">
		    		</td>
		    		<td>
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
