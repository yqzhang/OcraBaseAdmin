<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

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
	<script src="./js/ui/jquery.ui.progressbar.js"></script>

	<link rel="stylesheet" href="<html:rewrite page="/css/demos.css"/>">
	
	<link rel="stylesheet" href="<html:rewrite page="/css/themes/jquery.ui.all.css"/>">
	
	<style>
	.ui-progressbar-value { background-image: url(./img/pbar-ani.gif); }
	</style>
	
	<script type="text/javascript">
		var ifFinished = 0;
		
		$(function() {
			$( "#progressbar" ).progressbar({
				value: 0
			});
		});
	
		function showTime() {
			setInterval(test,2000);
		}
		
		function test() {
			var rand = Math.random();
			var url = "<%=basePath%>getTestBulkLoadProgress.do?random=" + rand;
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
		            var result = XMLHttpReq.responseText;
					$("#progressbar").progressbar("option","value",parseInt(result));
		            document.getElementById("rate").innerHTML = result + '%';
		            
		            if(parseInt(result) == 100 && ifFinished == 0) {
		            	alert('BulkLoad Finished.');
		            	window.location = '/testBulkLoadResult.jsp';
		            	ifFinished = 1;
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
  
  	<div class="demo">

		<b id="rate">0%</b>

		<div id="progressbar">
		</div>

	</div>
  
  </body>
</html>
