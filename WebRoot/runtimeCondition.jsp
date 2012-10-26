<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page import="java.util.*"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.util.StringUtils"
  import="org.apache.hadoop.hbase.util.Bytes"
  import="org.apache.hadoop.hbase.util.JvmVersion"
  import="org.apache.hadoop.hbase.util.FSUtils"
  import="org.apache.hadoop.hbase.master.HMaster"
  import="org.apache.hadoop.hbase.HConstants"
  import="ict.ocrabase.main.java.client.webinterface.IndexAdmin"
  import="org.apache.hadoop.hbase.HServerInfo"
  import="org.apache.hadoop.hbase.HServerAddress"
  import="org.apache.hadoop.hbase.HTableDescriptor" %>
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
	<script src="./js/ui/jquery.ui.tabs.js"></script>

	<link rel="stylesheet" href="<html:rewrite page="/css/demos.css"/>">
	
	<link rel="stylesheet" href="<html:rewrite page="/css/themes/jquery.ui.all.css"/>">

	<script type="text/javascript">
		$(function() {
			$( "#tabs" ).tabs();
		});
	</script>
  
  	<%
		HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
		Configuration conf = master.getConfiguration();
		HServerAddress rootLocation = master.getCatalogTracker().getRootLocation();
		boolean metaOnline = master.getCatalogTracker().getMetaLocation() != null;
		Map<String, HServerInfo> serverToServerInfos = master.getServerManager().getOnlineServers();
		int interval = conf.getInt("hbase.regionserver.msginterval", 1000)/1000;
		if (interval == 0) {
			interval = 1;
		}
		boolean showFragmentation = conf.getBoolean("hbase.master.ui.fragmentation.enabled", false);
		Map<String, Integer> frags = null;
		if (showFragmentation) {
			frags = FSUtils.getTableFragmentation(master);
		}
	%>
	
  </head>
  
  <body>
    <h2>Catalog Tables</h2>
	<% 
	  if (rootLocation != null) { %>
	<table>
	<tr>
	    <th>Table</th>
	<%  if (showFragmentation) { %>
	        <th title="Fragmentation - Will be 0% after a major compaction and fluctuate during normal usage.">Frag.</th>
	<%  } %>
	    <th>Description</th>
	</tr>
	<tr>
	    <td class="row1"><a href="runtimeTableState.jsp?name=<%= Bytes.toString(HConstants.ROOT_TABLE_NAME) %>"><%= Bytes.toString(HConstants.ROOT_TABLE_NAME) %></a></td>
	<%  if (showFragmentation) { %>
	        <td class="row1" align="center"><%= frags.get("-ROOT-") != null ? frags.get("-ROOT-").intValue() + "%" : "n/a" %></td>
	<%  } %>
	    <td class="row1">The -ROOT- table holds references to all .META. regions.</td>
	</tr>
	<%
	    if (metaOnline) { %>
	<tr>
	    <td class="row2"><a href="runtimeTableState.jsp?name=<%= Bytes.toString(HConstants.META_TABLE_NAME) %>"><%= Bytes.toString(HConstants.META_TABLE_NAME) %></a></td>
	<%  if (showFragmentation) { %>
	        <td class="row2" align="center"><%= frags.get(".META.") != null ? frags.get(".META.").intValue() + "%" : "n/a" %></td>
	<%  } %>
	    <td class="row2">The .META. table holds references to all User Table regions</td>
	</tr>
	  
	<%  } %>
	</table>
	<%} %>
	
	<h2>User Tables</h2>
	<% HTableDescriptor[] tables = new IndexAdmin(conf).listTables(); 
	   if(tables != null && tables.length > 0) { %>
	<table>
	<tr>
	    <th>Table</th>
	<%  if (showFragmentation) { %>
	        <th title="Fragmentation - Will be 0% after a major compaction and fluctuate during normal usage.">Frag.</th>
	<%  } %>
	    <th>Description</th>
	</tr>
	<%  int i = 0;
		String cssClass = new String(); 
		for(HTableDescriptor htDesc : tables ) {
			cssClass = (i % 2 == 0) ? "row1" : "row2";
	%>
	<tr>
	    <td class="<%=cssClass %>"><a href=runtimeTableState.jsp?name=<%= htDesc.getNameAsString() %>><%= htDesc.getNameAsString() %></a> </td>
	<%  if (showFragmentation) { %>
	        <td class="<%=cssClass %>" align="center"><%= frags.get(htDesc.getNameAsString()) != null ? frags.get(htDesc.getNameAsString()).intValue() + "%" : "n/a" %></td>
	<%  } %>
	    <td class="<%=cssClass %>"><%= htDesc.toString() %></td>
	</tr>
	<%   }  %>
	
	<p> <%= tables.length %> table(s) in set.</p>
	</table>
	<% } %>
	
	<h2>Region Servers</h2>
	<% if (serverToServerInfos != null && serverToServerInfos.size() > 0) { %>
	<%   int totalRegions = 0;
	     int totalRequests = 0; 
	%>
	
	<table>
	<tr><th rowspan="<%= serverToServerInfos.size() + 1%>"></th><th>Address</th><th>Start Code</th><th>Load</th></tr>
	<%   String[] serverNames = serverToServerInfos.keySet().toArray(new String[serverToServerInfos.size()]);
	     Arrays.sort(serverNames);
	     int i = 0;
	     String cssClass = new String();
	     for (String serverName: serverNames) {
	       cssClass = (i % 2 == 0) ? "row1" : "row2";
	       HServerInfo hsi = serverToServerInfos.get(serverName);
	       String hostname = hsi.getServerAddress().getHostname() + ":" + hsi.getInfoPort();
	       String url = "http://" + hostname + "/";
	       totalRegions += hsi.getLoad().getNumberOfRegions();
	       totalRequests += hsi.getLoad().getNumberOfRequests() / interval;
	       long startCode = hsi.getStartCode();
	%>
	<tr><td class="<%=cssClass %>"><a href="<%= url %>"><%= hostname %></a></td><td class="<%=cssClass %>"><%= startCode %></td><td class=<%=cssClass %>><%= hsi.getLoad().toString(interval) %></td></tr>
	<%   } %>
	<tr><th>Total: </th><td>servers: <%= serverToServerInfos.size() %></td><td>&nbsp;</td><td>requests=<%= totalRequests %>, regions=<%= totalRegions %></td></tr>
	</table>
	
	<p>Load is requests per second and count of regions loaded</p>
	<% } %>
  </body>
</html>
