<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page import="com.ocrabaseadmin.operation.dataOperation" %>
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

	<%
		int presentPage = Integer.parseInt((String)request.getAttribute("page"));
		ArrayList<String> viewResult = (ArrayList<String>)request.getAttribute("viewResult");
		int resultSize = ((dataOperation)request.getSession().getAttribute("QUERYRESULT")).getResultSize();
	%>
	
  </head>
  
  <body>
    <table border="0" cellpadding="5" cellspacing="2">
    	<tr>
    		<th align="center">
    			<b>Query Result</b>
    		</th>
    	</tr>
    	<%
    		String cssClass = new String();
    		for(int i = 0;i < viewResult.size();i++) {
    			cssClass = (i % 2 == 0) ? "row1" : "row2";
    			out.println("<tr><td class=\"" + cssClass + "\">");
    			out.println(viewResult.get(i));
    			out.println("</td></tr>");
    		}
    	%>
    	<tr>
    		<td>
    			<a href="/getQueryResult.do?page=0">
    				First
    			</a>
    			<%
    				if(presentPage <= 0) {
    			%>
    			<a>Previous</a>
    			<%
    				}
    				else {
    			%>
    			<a href="/getQueryResult.do?page=<%=presentPage - 1 %>">
    				Previous
    			</a>
    			<%
    				}
    				if(presentPage >= (resultSize - 1) / 20) {
    			%>
    			<a>Next</a>
    			<%
    				}
    				else {
    			%>
    			<a href="/getQueryResult.do?page=<%=presentPage + 1 %>">
    				Next
    			</a>
    			<%
    				}
    			%>
    			<a href="/getQueryResult.do?page=<%=(resultSize - 1) / 20 %>">
    				Last
    			</a>
    		</td>
    	</tr>
    </table>
  </body>
</html>
