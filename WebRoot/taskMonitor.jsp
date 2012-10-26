<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page import="java.util.Date"
	import="java.text.SimpleDateFormat" %>

<%@ page import="ict.ocrabase.main.java.client.webinterface.TaskDescription" %>

<jsp:include page="/loginCheck.jsp" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

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
	
	<script src="./js/jquery-1.6.2.js"></script>
	<script src="./js/ui/jquery.ui.core.js"></script>
	<script src="./js/ui/jquery.ui.widget.js"></script>
	<script src="./js/ui/jquery.ui.progressbar.js"></script>
	
	<link rel="stylesheet" href="<html:rewrite page="/css/demos.css"/>">
	
	<link rel="stylesheet" href="<html:rewrite page="/css/themes/jquery.ui.all.css"/>">
	
	<style>
	.ui-progressbar-value { background-image: url(./img/pbar-ani.gif); }
	</style>
	
	<%
		TaskDescription[] taskDesc = (TaskDescription[])request.getSession().getAttribute("TASKDESC");
	%>
	
	<script type="text/javascript">
		$(function() {
			<%
				for(int i = 0;i < taskDesc.length;i++) {
					out.println("$(\"#progressbar" + i + "\").progressbar({ value:" + taskDesc[i].getProgress() + "});");
				}
			%>
		});
	
		function showTime() {
			setInterval(test,2000);
		}
		
		function test() {
			var rand = Math.random();
			var url = "<%=basePath%>getTaskProgress.do?random=" + rand;
			sendRequest(url);
		}
		
		var XMLHttpReq = false;
		//Create XMLHttpRequest 
		function createXMLHttpRequest() {
		    if(window.XMLHttpRequest) {//Mozilla 
		        XMLHttpReq = new XMLHttpRequest();
		    }
		    else if (window.ActiveXObject) {//IE 
		        try {
		        	XMLHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
		        } catch (e) {
		            try {
		            	XMLHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
		            } catch (e) {
		            	
		            }
		        }
		    }
		}
		
		//Send request
		function sendRequest(url) {
		    createXMLHttpRequest();
		    XMLHttpReq.open("GET", url, true);
		    XMLHttpReq.onreadystatechange = processResponse;//set response function
		    XMLHttpReq.send(null);  // send request
		}
		
		// deal message 
		function processResponse() {
		    if (XMLHttpReq.readyState == 4) { // check status
		        if (XMLHttpReq.status == 200) { // process message
		            var result = XMLHttpReq.responseXML;
		            
		            var tasks = result.getElementsByTagName("task");
		            
		            for(var i = 0;i < tasks.length;i++) {
		            	$("#progressbar" + i).progressbar("option","value",parseInt(tasks[i].getElementsByTagName("progress")[0].firstChild.nodeValue));
		            	document.getElementById("rate" + i).innerHTML = tasks[i].getElementsByTagName("progress")[0].firstChild.nodeValue + '%';
		            	document.getElementById("endtime" + i).innerHTML = tasks[i].getElementsByTagName("endtime")[0].firstChild.nodeValue;
		            	document.getElementById("status" + i).innerHTML = tasks[i].getElementsByTagName("status")[0].firstChild.nodeValue;
		            }
		        } else { //exception
		            //window.alert("Exception request.");
					document.getElementById("rate").innerHTML = "Exception request ajax.";
		        }
		    }
		}
	</script>

  </head>
  
  <body onload="showTime()">
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
  		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.taskMonitor"/>
  			</td>
  		</tr>
	</table>

	<br>

  	<div class="demo">
		<table  cellpadding="2" cellspacing="2" border="0">
			<tr align="center">
				<th>
					<b>
						Table Name
					</b>
				</th>
				<th>
					<b>
						Description
					</b>
				</th>
				<th>
					<b>
						Status
					</b>
				</th>
				<th>
					<b>
						Start Time
					</b>
				</th>
				<th>
					<b>
					End Time
					</b>
				</th>
				<th>
					<b>
						Progress
					</b>
				</th>
			</tr>
		

	  		<%
	  			String cssClass = new String();
	  			
	  			for(int i = 0;i < taskDesc.length;i++) {
	  				cssClass = (i % 2 == 0) ? "row1" : "row2";
	  				out.println("<tr>");
	  				out.println("<td class=\"" + cssClass + "\">" + taskDesc[i].getTableName() + "</td>");
	  				out.println("<td class=\"" + cssClass + "\">" + taskDesc[i].getDescription() + "</td>");
	  				out.println("<td id=\"status" + i + "\" class=\"" + cssClass + "\">" + taskDesc[i].getStatus() + "</td>");
	  				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	  				Date dt = new Date(taskDesc[i].getStartTime());
	  				String time = sdf.format(dt);
	  				out.println("<td class=\"" + cssClass + "\">" + time + "</td>");
	  				dt = new Date(taskDesc[i].getEndTime());
	  				time = sdf.format(dt);
	  				out.println("<td id=\"endtime" + i + "\" class=\"" + cssClass + "\">" + ((dt.getYear() < 100) ? "--" : time) + "</td>");
	  				out.println("<td class=\"" + cssClass + "\"><div id=\"progressbar" + i + "\"></div><b id=\"rate" + i + "\">" + taskDesc[i].getProgress() + "%</b></td>");
	  			}
	  		%>
		
		</table>
	</div>

  </body>
</html>
