<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
	import="java.util.*"
	import="org.apache.hadoop.conf.Configuration"
	import="org.apache.hadoop.util.StringUtils"
	import="org.apache.hadoop.hbase.util.Bytes"
	import="org.apache.hadoop.hbase.util.JvmVersion"
	import="org.apache.hadoop.hbase.util.FSUtils"
	import="org.apache.hadoop.hbase.master.HMaster"
	import="org.apache.hadoop.hbase.HConstants"
	import="org.apache.hadoop.hbase.client.HBaseAdmin"
	import="org.apache.hadoop.hbase.HServerInfo"
	import="org.apache.hadoop.hbase.HServerAddress"
	import="org.apache.hadoop.hbase.HTableDescriptor" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
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
	
	<%
    	HMaster master = (HMaster)request.getAttribute("master");
		boolean showFragmentation = ((Boolean)request.getAttribute("showFragmentation")).booleanValue();
		Object tempFrags = request.getAttribute("frags");
		Map<String, Integer> frags = null;
		if(tempFrags != null) {
			frags = (Map<String, Integer>)tempFrags;
		}
    %>

  </head>
  
  <body>
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.home"/>
			</td>
		</tr>
	</table>
	
	<!--
	
    <h1 id="page_title">
    	Master: <%=master.getMasterAddress().getHostname()%>:<%=master.getMasterAddress().getPort()%>
    </h1>
    
    <h2>Master Attributes</h2>
	<table cellspacing="2" cellpadding="2">
		<tr>
			<th>
				Attribute Name
			</th>
			<th>
				Value
			</th>
			<th>
				Description
			</th>
		</tr>
		<tr>
			<td>
				HBase Version
			</td>
			<td>
				<%= org.apache.hadoop.hbase.util.VersionInfo.getVersion() %>, r<%= org.apache.hadoop.hbase.util.VersionInfo.getRevision() %>
			</td>
			<td>
				HBase version and svn revision
			</td>
		</tr>
		<tr>
			<td>
				HBase Compiled
			</td>
			<td>
				<%= org.apache.hadoop.hbase.util.VersionInfo.getDate() %>, <%= org.apache.hadoop.hbase.util.VersionInfo.getUser() %>
			</td>
			<td>
				When HBase version was compiled and by whom
			</td>
		</tr>
		<tr>
			<td>
				Hadoop Version
			</td>
			<td>
				<%= org.apache.hadoop.util.VersionInfo.getVersion() %>, r<%= org.apache.hadoop.util.VersionInfo.getRevision() %>
			</td>
			<td>
				Hadoop version and svn revision
			</td>
		</tr>
		<tr>
			<td>
				Hadoop Compiled
			</td>
			<td>
			<%= org.apache.hadoop.util.VersionInfo.getDate() %>, <%= org.apache.hadoop.util.VersionInfo.getUser() %>
			</td>
			<td>
				When Hadoop version was compiled and by whom
			</td>
		</tr>
		<tr>
			<td>
				HBase Root Directory
			</td>
			<td>
				<%= FSUtils.getRootDir(master.getConfiguration()).toString() %>
			</td>
			<td>
				Location of HBase home directory
			</td>
		</tr>
		<tr>
			<td>
				Load average
			</td>
			<td>
				<%= StringUtils.limitDecimalTo2(master.getServerManager().getAverageLoad()) %>
			</td>
			<td>
				Average number of regions per regionserver.
			</td>
		</tr>
		<%  if (showFragmentation) { %>
       			<tr>
       				<td>
       					Fragmentation
       				</td>
       				<td>
       					<%= frags.get("-TOTAL-") != null ? frags.get("-TOTAL-").intValue() + "%" : "n/a" %>
       				</td>
       				<td>
       					Overall fragmentation of all tables, including .META. and -ROOT-.
       				</td>
       			</tr>
		<%  } %>
		<tr>
			<td>
				Zookeeper Quorum
			</td>
			<td>
				<%= master.getZooKeeperWatcher().getQuorum() %>
			</td>
			<td>
				Addresses of all registered ZK servers.
			</td>
		</tr>
	</table>
		
	-->
	
	<h2 align="center">OcraBase</h2>
	<table cellspacing="2" cellpadding="2" align="center">
		<tr>
			<td class="row1" align="center">
				<b>
					Overview
				</b>
			</td>
			<td class="row1" align="center">
				&nbsp;&nbsp;
				<bean:message key="prompt.overview"/>
			</td>
		</tr>
		<tr>
			<td class="row2" align="center">
				<b>
					Key Features
				</b>
			</td>
			<td class="row2" align="left">
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.table"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.multiIndexs"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.singleLine"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.importData"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.dataWriting"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.dataQuery"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.resourceIsolate"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.multiAccess"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.security"/>
				<br><br>
				&nbsp;&nbsp;
				*<bean:message key="prompt.features.maintenance"/>
			</td>
		</tr>
		<tr>
			<td class="row1" align="center">
				<b>
					Version
				</b>
			</td>
			<td class="row1" align="center">
				1.0
			</td>
		</tr>
	</table>
		
  </body>
</html>
