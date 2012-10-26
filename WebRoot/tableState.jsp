<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page import="java.util.Map"
  import="org.apache.hadoop.io.Writable"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.hbase.client.HTable"
  import="org.apache.hadoop.hbase.HTableDescriptor"
  import="ict.ocrabase.main.java.client.webinterface.IndexAdmin"
  import="org.apache.hadoop.hbase.HRegionInfo"
  import="org.apache.hadoop.hbase.HServerAddress"
  import="org.apache.hadoop.hbase.HServerInfo"
  import="org.apache.hadoop.hbase.HServerLoad"
  import="org.apache.hadoop.hbase.io.ImmutableBytesWritable"
  import="org.apache.hadoop.hbase.master.HMaster"
  import="org.apache.hadoop.hbase.util.Bytes"
  import="org.apache.hadoop.hbase.util.FSUtils"
  import="java.util.*"
  import="org.apache.hadoop.hbase.HConstants"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
	
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/table.css"/>" />
	<link media="screen" rel="stylesheet" href="<html:rewrite page="/css/colorbox.css"/>" />
	<script type="text/javascript" src="./js/loading.js"></script>
	<script type="text/javascript" src="./js/jquery.min.js"></script>
	<script type="text/javascript" src="./js/highcharts.js"></script>
	<script type="text/javascript" src="./js/modules/exporting.js"></script>
	<script type="text/javascript" src="./js/jquery.colorbox.js"></script>

		<%
			boolean login = true;
			String usertype = (String)request.getSession().getAttribute("usertype");
			int permissionLevel = (usertype.equals("user")) ? 1 : 2;
			String username = (String)request.getSession().getAttribute("username");
			Enumeration parameterEnum = request.getParameterNames();
		%>

		<%
			List<String> tableNameList = new ArrayList<String>();
			List<Integer> tableRCList = new ArrayList<Integer>();
			List<Boolean> needBalanceList = new ArrayList<Boolean>();
			Map<String, List<Integer>> rsMapTableRC = new HashMap<String, List<Integer>>();
			HMaster master = (HMaster) getServletContext().getAttribute(HMaster.MASTER);
			List<Object> tableEles = new ArrayList<Object>();
			Configuration conf = master.getConfiguration();
			Map<String, HServerInfo> serverToServerInfos = master.getServerManager().getOnlineServers();
			List<String> serverNameList = new ArrayList<String>(serverToServerInfos.keySet());
			Collections.sort(serverNameList);
			String[] serverNames = serverToServerInfos.keySet().toArray(new String[serverToServerInfos.size()]);
			Arrays.sort(serverNames);
			HTableDescriptor[] tables = new IndexAdmin(conf).listTables();
			//int regionsBase = 0;
			//int requestsBase = 0;
			//int requestsCount = 0;
			//int regionsCount = 0;
			int i = 0;
			int j = 0;
			int elesNum = 6;

			int onlineServers = serverNames.length;

			if (login) {
				if(tables != null) {
					for (HTableDescriptor tableDesc : tables) {
						String tableName = tableDesc.getNameAsString();
						HTable table = new HTable(conf, tableName);
						Map<HRegionInfo, HServerAddress> regions = table
								.getRegionsInfo();
						int regionCount = regions.size();
						int perRSRegion = 0;
						int perRSRegionMax = 0;
						if (regionCount <= onlineServers) {
							perRSRegion = 0;
							perRSRegionMax = 1;
						} else {
							perRSRegion = regionCount / onlineServers;
							perRSRegionMax = (regionCount % onlineServers == 0) ? perRSRegion : perRSRegion + 1;
						}
						i = 0;
						Map<String, List> rsCounts = new HashMap<String, List>();
						for (Map.Entry<HRegionInfo, HServerAddress> hriEntry : regions.entrySet()) {
							/*if(i==0){
							   i=1;
							   continue;
							}*/
							HServerAddress addr = hriEntry.getValue();
	
							int infoPort = 0;
							String urlRegionServer = null;
	
							if (addr != null) {
								HServerInfo info = master.getServerManager()
										.getHServerInfo(addr);
								if (info != null) {
									infoPort = info.getInfoPort();
									urlRegionServer = "http://"
											+ addr.getHostname().toString() + ":"
											+ infoPort + "/";
								}
							}
							HRegionInfo regionInfo = hriEntry.getKey();
							String regionName = Bytes.toStringBinary(regionInfo
									.getRegionName());
							String encodeRegionName = regionName.substring(
									(regionName.lastIndexOf(".",
											regionName.length() - 2)) + 1,
									regionName.length() - 1);
							if (rsCounts.containsKey(urlRegionServer)) {
								rsCounts.get(urlRegionServer).add(encodeRegionName);
							} else {
								List<String> regionNames = new ArrayList<String>();
								regionNames.add(encodeRegionName);
								rsCounts.put(urlRegionServer, regionNames);
							}
						}
	
						boolean needBalance = false;
						int maxRegionsInRS = 0;
						for (Map.Entry<String, List> rsCount : rsCounts.entrySet()) {
							int rsRegions = rsCount.getValue().size();
							if (rsRegions > perRSRegionMax + 1) {
								needBalance = true;
							}
							if (rsRegions > maxRegionsInRS) {
								maxRegionsInRS = rsRegions;
							}
	
						}
						for (String rsName : serverNameList) {
							HServerInfo info = serverToServerInfos.get(rsName);
							String urlServer = "http://"
									+ info.getHostname().toString() + ":"
									+ info.getInfoPort() + "/";
							int rc = 0;
							if (rsCounts.containsKey(urlServer)) {
								rc = rsCounts.get(urlServer).size();
							}
							if (rsMapTableRC.containsKey(rsName))
								rsMapTableRC.get(rsName).add(rc);
							else {
								List<Integer> tmptableRCList = new ArrayList<Integer>();
								tmptableRCList.add(rc);
								rsMapTableRC.put(rsName, tmptableRCList);
							}
						}
						tableNameList.add(tableName);
						tableRCList.add(regionCount);
						needBalanceList.add(needBalance);
						j++;
						tableEles.add(tableName);
						tableEles.add(regionCount);
						tableEles.add(maxRegionsInRS);
						tableEles.add(perRSRegion);
						tableEles.add(perRSRegionMax);
						tableEles.add(needBalance);
					}
				}
			}
		%>
		
	<script type="text/javascript">
	var rev=false;
	function on_submit()
	{
		return true
	}
	
	function sortAs(sorttype)
	{
		var table = document.getElementById("tableState");
		var tableNum=table.rows.length;
		var tableData=[];
		for(var i=1;i<tableNum;i++)
		{
			//alert(table.rows[i].cells[2].innerHTML);
			tableData.push(table.rows[i]);
		}
		if(sorttype==1)
		{
				tableData=tableData.sort(function(x,y){return (x.cells[0].innerHTML<y.cells[0].innerHTML)?-1:1;});
				if(rev)tableData.reverse();
				rev=!rev;
		}
		else if(sorttype==2)
		{
			tableData=tableData.sort(function(x,y){return parseInt(x.cells[1].innerHTML)-parseInt(y.cells[1].innerHTML);});
			if(rev)tableData.reverse();
			rev=!rev;
		}
		else if(sorttype==3)
		{
			tableData=tableData.sort(function(x,y){return parseInt(x.cells[2].innerHTML.split(" (Regions")[0])-parseInt(y.cells[2].innerHTML.split(" (Regions")[0]);});
			if(rev)tableData.reverse();
			rev=!rev;
		}
		else if(sorttype==4)
		{
			tableData=tableData.sort(function(x,y){return (x.cells[3].innerHTML<y.cells[3].innerHTML)?-1:1;});
			if(rev)tableData.reverse();
			rev=!rev;
		}
		var rowdatas=[]; 
		for(var i=1;i<tableNum;i++)
		{
			rowdatas.push(tableData[i-1].innerHTML);
		}
		//alert(tableData[3].cells[0].innerHTML);
		for(var i=1;i<tableNum;i++)
		{
			//alert(rowdatas[i-1]);
			table.rows[i].innerHTML=rowdatas[i-1];
		}
		
	}
	
	function refreshTableState()
	{
		location.reload();
	}
	

	</script>

	</head>
  
  <body>
		<%
			if (login) {
		%>
		<h1>
			Username: <%=username%>
			Permission: <%=permissionLevel%></h1>
		<p>
		
		<div id="UnbalancedTableContainer"
			style="width: 100%; height: 400px; margin: 0 auto; display: block; float: left;"></div>
		<div id="TableStateContainer"
			style="width: 100%; height: 400px; margin: 0 auto; display: block; float: left;"></div>
		<h1>
			Search Result
		</h1>

		<iframe marginwidth=0 marginheight=0 name="resultview"
			frameborder="no" scrolling="yes" width=100% height=200>
		</iframe>
		<h1>
			Table State
			<input id="balance_all" type="button" onclick="refreshTableState()"
				value="Refresh" />
			<%
				if (permissionLevel > 1) {
			%><input id="balance_all" type="button" onclick="dobalance()"
				value="Do Balance" />
			<script>
								
	function dobalance()
	{
		if(<%=permissionLevel%>>1)
		{
			var queren=confirm('Do balance?')
			if(queren)
			{
				window.location="makebalance.jsp";
				//Show();
			}
		}
		else
			alert("Permission Denied");
		
	}
	</script>
			<%
				}
			%>
		</h1>
		<table id="tableState" width="100%" border="1">
			<tr>
				<th>
					<a href="javascript:void(0);" onclick="javascript:sortAs(1);">Table
						Name</a>
				</th>
				<th>
					<a href="javascript:void(0);" onclick="javascript:sortAs(2);">Region
						Numbers</a>
				</th>
				<th>
					<a href="javascript:void(0);" onclick="javascript:sortAs(3);">max
						regions in one server</a>
				</th>
				<th>
					<a href="javascript:void(0);" onclick="javascript:sortAs(4);">need
						balance?</a>
				</th>
				<th>
					which regionserver is the key on?
				</th>
				<th>
					query Rowkey
				</th>
			</tr>
			<%
				if(tableEles != null && tableEles.size() != 0) {
					int total = tableEles.size();
					int k = 0;
					for (int m = 0; m < total / elesNum; m++) {
						String tableName = (String) tableEles.get(k++);
						int regionCount = (Integer) tableEles.get(k++);
						int maxRegionsInRS = (Integer) tableEles.get(k++);
						int perRSRegion = (Integer) tableEles.get(k++);
						int perRSRegionMax = (Integer) tableEles.get(k++);
						boolean needBalance = (Boolean) tableEles.get(k++);
			%>
			<tr>
				<td>
					<a href=runtimeTableState.jsp?name=<%=tableName%>> <%=tableName%>
					</a>
				</td>
				<td><%=regionCount%></td>
				<td><%=maxRegionsInRS%>
					(Regions Range:[<%=perRSRegion%>,<%=perRSRegionMax%>] )
				</td>
				<td><%=needBalance%>
					<%
						if (permissionLevel > 1) {
									out.print(needBalance ? ",<a href=showTableBalance.jsp?tableName="
											+ tableName + ">show detail</a>"
											: "");
								}
					%>
				</td>
				<td>
					<form action="search.jsp" method="post" name="form1"
						id="form_<%=tableName%>" onsubmit="return on_submit"
						target="resultview">
						<INPUT type=text name=RSLocation_<%=tableName%>>
						<input type="submit" value="Search" />
					</form>
				</td>
				<td>
					<form action="search.jsp" method="post" name="form1"
						onsubmit="return on_submit" target="resultview">
						<INPUT class=I_w70 type=text name=Query_<%=tableName%>>
						<input type="submit" value="Search" />
					</form>
				</td>
			</tr>
			<%
					}
				}
			%>

		</table>
		<script type="text/javascript">
 			
 				var tablenames=[];
 				var tableRCs=[];
				var rsNames=[];
				var rsTableRegions=[];
				var needBalances=[];
				var tableStatechart;
				var unbalancedTableChart;
	$(document).ready(function() 
	{
		
				tableDataInit();
				tableStatechart =getTableStateChart("TableStateContainer");
				unbalancedTableChart = getUnbalanceTableChart("UnbalancedTableContainer");
				showalltable();
				//$(".example7").colorbox({width:"80%", height:"80%",iframe:true});
				/*$('#tableState').flexigrid({
					 colModel : [
                    {display: 'Table Ãû×Ö', name : 'id', width : 'auto', sortable : true, align: 'center'},
                    {display: 'Region ÊýÄ¿ 	', name : 'name', width : 'auto', sortable : true, align: 'center'},
                    {display: 'max regions in one server', name : 'address', width : 'auto', sortable : true, align: 'center'},
                    {display: '	need balance?', name : 'createDate', width : 'auto', sortable : true, align: 'center'},
                    {display: 'which regionserver is the key on£¿', name : 'createDate2', width : 'auto', sortable : false, align: 'center'},
                    {display: 'query Rowkey', name : 'description', width : 'auto', sortable : false, align: 'center'}
                    ],

				usepager: true,
				title: 'Countries',
				useRp: true,
				rp: 15,
				showTableToggleBtn: true,
				width: 'auto',
				height: 400
			});*/
	});
			
			
		function tableDataInit()
		{
			
			<%for (boolean need : needBalanceList) {%>
			needBalances.push(<%=need%>);
			<%}

				for (String tbName : tableNameList) {%>
			tablenames.push("<%=tbName%>");
			<%}

				for (int tbRC : tableRCList) {%>
			var num=<%=tbRC%>;
			tableRCs.push(num);
			<%}

				for (String rsName : serverNameList) {
					List<Integer> tableRCforRS = rsMapTableRC.get(rsName);%>
			var tmprsname="<%=rsName%>";
			if(tmprsname.indexOf(".")!=-1)tmprsname=tmprsname.split(".")[0];
			rsNames.push(tmprsname);
			var rcdata=[];
			<%for (int kk = 0; kk < tableRCforRS.size(); kk++) {
						int rc = tableRCforRS.get(kk);%>
				rcdata.push(<%=rc%>*100.0/tableRCs[<%=kk%>]);
			<%}%>
			rsTableRegions.push(rcdata);
			<%}%>
	
	}

	
	
</script>


		<%
			} else {
				if (username != "")
					out.println("<p>");
		%>
		<h2>
			Table State Please Login
			<p>
				read acount test:test
		</h2>
		<p>
		
		<form action="tableState.jsp" method="post">
			<table>
				<tr class="field">
					<td class="label" valign="top">
						<label>
							Username:
						</label>
					</td>
					<td class="field" colspan="2" valign="top">
						<input id="username" name="username" type="text" />
					</td>
				</tr>
				<tr class="field">
					<td class="label" valign="top">
						<label>
							Password:
						</label>
					</td>
					<td class="field" colspan="2" valign="top">
						<input id="password" name="password" type="password" />
					</td>
				</tr>
				<tr class="field">
					<td class="label" valign="top">
						<label></label>
					</td>
					<td class="field" colspan="2" valign="top">
						<input id="need-margin" name="submit" type="submit" value="Login" />
					</td>
				</tr>
			</table>
		</form>
		<%
			}
		%></body>
</html>

<script type="text/javascript">

function getUnbalanceTableChart(containerName)
{
	var chart = new Highcharts.Chart({
					chart: {
						renderTo: containerName,
						defaultSeriesType: 'column'
					},
					title: {
						text: 'Unbalanced Table Regions Distribution'
					},
					xAxis: {
						categories: getUnbalancedTableCategories()
					},
					yAxis: {
						min: 0,
						title: {
							text: 'Percent(%)'
						}
					},
					legend: {
						layout: 'horizontal',
						backgroundColor: '#FFFFFF',
						//align: 'left',
						//verticalAlign: 'top',
						//x: 100,
						//y: 70,
						//floating: true,
						labelFormatter: function() {
						
						if(this.name.indexOf(".")!=-1)
								return this.name.split(".")[0];
							return this.name;
						},
						shadow: true
					},
					tooltip: {
						formatter: function() {
							var sn=this.series.name;
							if(sn.indexOf(".")!=-1)sn=sn.split(".")[0];
							return ''+sn+': '+Highcharts.numberFormat(this.y, 2, '.')+'% ('+Math.round(getTableRC(this.x)*this.y/100).toString()+' region(s))';
						}
					},
					plotOptions: {
						column: {
							pointPadding: 0.2,
							borderWidth: 0
						}
					},
					credits: {
						enabled: true,
						text: 'View / Close Table',
						href: 'Javascript:showalltable()',
						position: {
							align: 'right',
							x: -10,
							verticalAlign: 'bottom',
							y: -5
										},
						style: {
							cursor: 'pointer',
							color: '#330000',
							fontSize: '12px'
								}
					},
				  series: getUnbalancedTableSeries()
				});
				return chart;
}

function showalltable()
{
	var show=document.getElementById("TableStateContainer").style.display;
	if(show=="block")document.getElementById("TableStateContainer").style.display="none";
	else document.getElementById("TableStateContainer").style.display="block";
	
}

function getTableRC(theTableName)
{
	for(var ii=0;ii<tablenames.length;ii++)
	{
		if(tablenames[ii]==theTableName)return tableRCs[ii];
	}
	return 0;
}

function getUnbalancedTableCategories()
{
	var cate=[];
	for(var ii=0;ii<tablenames.length;ii++)
	{
		if(needBalances[ii])
		{
			cate.push(tablenames[ii]);
		}
	}
	return cate;
}

function getUnbalancedTableSeries()
{
	var series=[];
			for(var j=0;j<rsNames.length;j++)
			{
				var tmpdata=rsTableRegions[j];
				var seriesdata=[];
				for(var tmpi=0;tmpi<tmpdata.length;tmpi++)
				{
					if(needBalances[tmpi])seriesdata.push(tmpdata[tmpi]);
				}
				series.push({name: rsNames[j],data: seriesdata});

			}
			return series;
}

function getTableStateChart(containerName)
{

				var chart	= new Highcharts.Chart({
					chart: {
						renderTo: containerName,
						plotBackgroundColor: 'none',
						plotBorderWidth: 0,
						plotShadow: false,	
						defaultSeriesType: 'area'
					},
					title: {
						text: 'Table Regions Distribution on Regionservers',
						style: {color: '#FF34B3',fontSize: '16px'}
					},
					xAxis: {
						categories: getTableStateChartCategories(),
						tickmarkPlacement: 'on',
						title: {
							enabled: false
						}
					},
					yAxis: {
						title: {
							text: 'Percent(%)'
						}
					},
					tooltip: {
						formatter: function() {
							var sn=this.series.name;
							if(sn.indexOf(".")!=-1)sn=sn.split(".")[0];
				                return ''+sn+'-'+tablenames[parseInt(this.x)-1] +': '+Highcharts.numberFormat(this.y, 0, ',')+'% ('+Math.round(tableRCs[parseInt(this.x)-1]*this.y/100).toString()+' region(s))';
						}
					},
					plotOptions: {
						area: {
							stacking: 'normal',
							lineColor: '#ffffff',
							lineWidth: 1,
							marker: {
								lineWidth: 1,
								lineColor: '#ffffff'
							}
						}
					},
					series: getTableStateChartSeries()
				});
				for(var k=1;k<chart.series.length;k++)
					chart.series[k].hide();
				return chart;
}

function getTableStateChartSeries()
{
			var series=[];
			for(var j=0;j<rsNames.length;j++)
			{
				series.push({name: rsNames[j],data: rsTableRegions[j]});

			}
			return series;
}

function getTableStateChartCategories()
{
	var categories=[];
	for(var i=1;i<=tablenames.length;i++)
		categories.push(i.toString());
	return categories;
}
</script>	
