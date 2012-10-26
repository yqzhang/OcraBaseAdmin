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
	
	<script type="text/javascript" src="./js/jquery.min.js"></script>
	<script type="text/javascript" src="./js/highcharts.js"></script>
	<script type="text/javascript" src="./js/modules/exporting.js"></script>
	
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
	class RSStatics {

		private int regions, requests, loads;
		private String serverName;
		public int storeFiles, memStoreSize, storeFileSize,
				storeFileIndexSize;

		public RSStatics(int regions, int requests, int loads,
				String serverName, int storeFiles, int memStoreSize,
				int storeFileSize, int storeFileIndexSize) {
			this.regions = regions;
			this.requests = requests;
			this.loads = loads;
			this.serverName = serverName;
			this.storeFiles = storeFiles;
			this.memStoreSize = memStoreSize;
			this.storeFileSize = storeFileSize;
			this.storeFileIndexSize = storeFileIndexSize;
		}

		public int getRegionsCount() {
			return this.regions;
		}

		public int getRequestsCount() {
			return this.requests;
		}

		public int getLoads() {
			return this.loads;
		}

		public String getName() {
			return this.serverName;
		}

	}

	class TableStatics {
		public String tableName;
		public int regionCount, maxRegionsInRS, perRSRegion,
				perRSRegionMax;
		public boolean needBalance;

		public TableStatics(String tableName, int regionCount,
				int maxRegionsInRS, int perRSRegion,
				int perRSRegionMax, boolean needBalance) {
			this.tableName = tableName;
			this.regionCount = regionCount;
			this.maxRegionsInRS = maxRegionsInRS;
			this.perRSRegion = perRSRegion;
			this.perRSRegionMax = perRSRegionMax;
			this.needBalance = needBalance;
		}
	}

	class RSBalance {

		private HMaster master;
		private Configuration conf;

		public RSBalance(HMaster master, Configuration conf) {
			this.master = master;
			this.conf = conf;
		}

		private List<RSStatics> RSSList = new ArrayList<RSStatics>();

		public void updateStatics(HTableDescriptor[] tables) {
			RSSList.clear();
			Map<String, HServerInfo> serverToServerInfos = master
					.getServerManager().getOnlineServers();
			String[] serverNames = serverToServerInfos.keySet()
					.toArray(new String[serverToServerInfos.size()]);
			Arrays.sort(serverNames);
			int regionsBase = 0;
			int requestsBase = 0;
			int requestsCount = 0;
			int regionsCount = 0;
			for (String serverName : serverNames) {
				HServerInfo serverInfo = serverToServerInfos
						.get(serverName);
				HServerLoad load = serverInfo.getLoad();
				int regions = load.getNumberOfRegions();
				int requests = load.getNumberOfRequests();
				int loads = load.getUsedHeapMB();
				int storeFiles = load.getStorefiles();
				int memStoreSize = load.getMemStoreSizeInMB();
				int storeFileSize = load.getStorefileSizeInMB();
				int storeFileIndexSize = load
						.getStorefileIndexSizeInMB();
				requestsCount += requests;
				regionsCount += regions;
				RSSList.add(new RSStatics(regions, requests, loads,
						serverInfo.getHostname(), storeFiles,
						memStoreSize, storeFileSize, storeFileIndexSize));
			}
		}

		public List<RSStatics> getRSStatics() {
			return this.RSSList;
		}
	}

	class TableBalance {
		private HMaster master;
		private Configuration conf;

		public TableBalance(HMaster master, Configuration conf) {
			this.master = master;
			this.conf = conf;
		}

		private List<TableStatics> TSList = new ArrayList<TableStatics>();

		public void updateStatics(HTableDescriptor[] tables)
				throws java.io.IOException {
			TSList.clear();
			Map<String, HServerInfo> serverToServerInfos = master
					.getServerManager().getOnlineServers();
			String[] serverNames = serverToServerInfos.keySet()
					.toArray(new String[serverToServerInfos.size()]);
			Arrays.sort(serverNames);
			int i = 0;
			int j = 0;

			int onlineServers = serverNames.length;
			for (HTableDescriptor tableDesc : tables) {
				String tableName = tableDesc.getNameAsString();
				HTable table = new HTable(conf, tableName);
				Map<HRegionInfo, HServerAddress> regions = table
						.getRegionsInfo();
				int regionCount = regions.size();
				int perRSRegion = 0;
				int perRSRegionMax = 0;
				if (regionCount <= onlineServers) {
					perRSRegion = 1;
					perRSRegionMax = 1;
				} else {
					perRSRegion = regionCount / onlineServers;
					perRSRegionMax = (regionCount % onlineServers == 0) ? perRSRegion
							: perRSRegion + 1;
				}
				i = 0;
				Map<String, List> rsCounts = new HashMap<String, List>();
				for (Map.Entry<HRegionInfo, HServerAddress> hriEntry : regions
						.entrySet()) {
					if (i == 0) {
						i = 1;
						continue;
					}
					HServerAddress addr = hriEntry.getValue();

					int infoPort = 0;
					String urlRegionServer = null;

					if (addr != null) {
						HServerInfo info = master.getServerManager()
								.getHServerInfo(addr);
						if (info != null) {
							infoPort = info.getInfoPort();
							urlRegionServer = "http://"
									+ addr.getHostname().toString()
									+ ":" + infoPort + "/";
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
						rsCounts.get(urlRegionServer).add(
								encodeRegionName);
					} else {
						List<String> regionNames = new ArrayList<String>();
						regionNames.add(encodeRegionName);
						rsCounts.put(urlRegionServer, regionNames);
					}
				}

				boolean needBalance = false;
				int maxRegionsInRS = 0;
				for (Map.Entry<String, List> rsCount : rsCounts
						.entrySet()) {
					int rsRegions = rsCount.getValue().size();
					if (rsRegions > perRSRegionMax) {
						needBalance = true;
					}
					if (rsRegions > maxRegionsInRS) {
						maxRegionsInRS = rsRegions;
					}
				}
				j++;
				TSList.add(new TableStatics(tableName, regionCount,
						maxRegionsInRS, perRSRegion, perRSRegionMax,
						needBalance));
			}
		}
	}
	HMaster master = (HMaster) getServletContext().getAttribute(
			HMaster.MASTER);
	Configuration conf = master.getConfiguration();
	RSBalance rsb = new RSBalance(master, conf);
	TableBalance tableBalance = new TableBalance(master, conf);
	%>

		<script type="text/javascript">
			var names=[];
			var requests=[];
			var totalRequests=0;
			var regions=[];
			var totalRegions=0;
			var loads=[];
			var totalLoads=0;
			var storeFiles=[];
			var minStoreFiles=0;
			var totalStoreFiles=0;
			var memStoreSize=[];
			var minMemStoreSize=0;
			var totalMemStoreSize=0;
			var storeFileSize=[];
			var minStoreFileSize=0;
			var totalStoreFileSize=0;
			var storeFileIndexSize=[];
			var minStoreFileIndexSize=0;
			var totalStoreFileIndexSize=0;
			dataInit();
			var chart;
			var regionsChart;
			var requestsChart;
			var usedHeapChart;
			var dynamicChart;
			var RSColumnChart;
			var show=true;
			var preValue=[];
			var preValueSum=0;
			var dynamicChartShowNum=20;
			var intervalTime=3*1000;
			$(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						margin: [50, 0, 0, 0],
						plotBackgroundColor: 'none',
						plotBorderWidth: 0,
						plotShadow: false				
					},
					title: {
						text: 'Current regionserver balance state',
						style: {color: '#3E576F',fontSize: '20px'}
					},
					subtitle: {
						text: 'outer regions mid requests inner usedHeapSize'
					},
					tooltip: {
						formatter: function() {
							return '<b>'+ this.series.name +'</b><br/>'+ 
								this.point.name +': '+ this.y +' %';
						}
					},
					credits: {
						enabled: true,
						text: 'View Detail',
						href: 'Javascript:showa()',
						position: {
							align: 'right',
							x: -10,
							verticalAlign: 'bottom',
							y: -5
										},
						style: {
							cursor: 'pointer',
							color: '#330000',
							fontSize: '15px'
								}
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: false
							},
							showInLegend: false
						}
					},
				    series: [{
						type: 'pie',
						name: 'regionserver usedHeapSize(MB)',
						size: '30%',
						innerSize: '10%',
						data: getUsedHeapData(),
						dataLabels: {
							enabled: false
						}
					},{
						type: 'pie',
						name: 'regionserver requests',
						size: '50%',
						innerSize: '30%',
						data: getRequestsData(),
						dataLabels: {
							enabled: false
						}
					}, {
						type: 'pie',
						name: 'regionserver regions',
						innerSize: '50%',
						data:getRegionsData(),
						dataLabels: {
							enabled: true,
							color: '#000000',
							connectorColor: '#000000'
						}
					}]
				});
				
				switchToMulti();
				dynamicChart=getDynamicChart("dynamicContainer");
				RSColumnChart=getRSColumnChart("RSColumnContainer");
			});
			
			
			
			function getRegionsData()
			{
				var colors=['#4572A7','#AA4643','#89A54E','#80699B','#3D96AE','#DB843D',"#EEEE00","#330033","#68228B","#8B6914","#FF33FF","#C71585","#FFFF00","#d01f3c","#356aa0","#C79810"];
				var regionsData=[];
				for(var i=0;i<names.length;i++)
				{
					regionsData.push({ name: names[i]+"-"+regions[i].toString(), y: Math.round(regions[i]*10000/totalRegions)/100, color: colors[i%colors.length]})
				}
				return regionsData;
				
			}
			
			function getRequestsData()
			{
				var colors=['#4572A7','#AA4643','#89A54E','#80699B','#3D96AE','#DB843D',"#EEEE00","#330033","#68228B","#8B6914","#FF33FF","#C71585","#FFFF00","#d01f3c","#356aa0","#C79810"];
				var requestsData=[];
				for(var i=0;i<names.length;i++)
				{
					requestsData.push({ name: names[i]+"-"+requests[i].toString(), y: Math.round(requests[i]*10000/(totalRequests+0.00000000001))/100, color: colors[i%colors.length]})
				}
				return requestsData;
				
			}
			
			function getUsedHeapData()
			{
				var colors=['#4572A7','#AA4643','#89A54E','#80699B','#3D96AE','#DB843D',"#EEEE00","#330033","#68228B","#8B6914","#FF33FF","#C71585","#FFFF00","#d01f3c","#356aa0","#C79810"];
				var loadsData=[];
				for(var i=0;i<names.length;i++)
				{
					loadsData.push({ name: names[i]+"-"+loads[i].toString(), y: Math.round(loads[i]*10000/(totalLoads))/100, color: colors[i%colors.length]})
				}
				return loadsData;
				
			}

			
			
			function getDynamicChart(containerName)
			{
				var chart = new Highcharts.Chart({
					chart: {
						renderTo: containerName,
						defaultSeriesType: 'spline',
						marginRight: 10,
						events: {
							load: function() {
								var series=[];
								series=this.series;
								setInterval(function() {
									var num=series.length;
									var x = (new Date()).getTime()+8*3600*1000; // current time
									var y=0;
									for(var k=0;k<num-1;k++)
									{
										y = preValue[k];
										//alert(names[k]);
									//series[k].addPoint([x, requests[k]], true, true);
									series[k].addPoint([x, y], true, true);
									}
									y=preValueSum;
									series[num-1].addPoint([x, y], true, true);
									process();
								}, intervalTime);
							}
						}
					},
					title: {
						text: 'Live regionserver requests'
					},
					xAxis: {
						type: 'datetime',
						tickPixelInterval: 150
					},
					yAxis: {
						title: {
							text: 'Request Num'
						},
						plotLines: [{
							value: 0,
							width: 1,
							color: '#808080'
						}]
					},
					tooltip: {
						formatter: function() {
				                return '<b>'+ this.series.name +'</b><br/>'+
								Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+ 
								Highcharts.numberFormat(this.y, 2);
						}
					},
					credits: {
						enabled: false
					},
					legend: {
						enabled: true,
						layout: 'vertical',
						align: 'left',
						verticalAlign: 'top',
						x: -10,
						y: 100,
						borderWidth: 0
					},
					exporting: {
						enabled: false
					},
					series: getSeries()
				});
				
				for(var k=0;k<chart.series.length-1;k++)
					chart.series[k].hide();
				//;
				return chart;
			}
			
			function getSeries()
			{
				process();
				var series=[];
				var time = (new Date()).getTime()+8*3600*1000;
				var requestsData=[];
				for(var j=0;j<names.length;j++)
				{
					requestsData=[];
					for (var i = 1-dynamicChartShowNum; i <= 0; i++) {
								requestsData.push({
									x: time + i * intervalTime,
									y: 0
								});
							}	
					series.push({name: names[j],data: requestsData});
					
				}
				series.push({name: "Cluster Total Requests",data: requestsData});
				return series;
			}
			
			function getData()
			{
				process();
				var time = (new Date()).getTime()+8*3600*1000;
					var data = [],i;
							for (i = 1-dynamicChartShowNum; i <= 0; i++) {
								data.push({
									x: time + i * 1000*15,
									y: Math.random()*0
								});
							}
							return data;
			}

			
			function getSingleChart(chartData,containerName)
			{
				var chart = new Highcharts.Chart({
					chart: {
						renderTo: containerName,
						margin: [40, 0, 0, 0],
						plotBackgroundColor: 'none',
						plotBorderWidth: 0,
						plotShadow: false				
					},
					title: {
						text: 'Current regionserver '+containerName.split("Container")[0]+' state',
						y: 30,
						style: {color: '#CC0000',fontSize: '14px'}
					},
					tooltip: {
						formatter: function() {
							return '<b>'+ this.series.name +'</b><br/>'+ 
								this.point.name +': '+ this.y +' %';
						}
					},
					credits: {
						enabled: false,
						text: 'Taobao.com',
						href: 'Javascript:switchToMulti()',
						position: {
							align: 'right',
							x: -10,
							verticalAlign: 'bottom',
							y: -5
										},
						style: {
							cursor: 'pointer',
							color: '#909090',
							fontSize: '10px'
								}
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: false
							},
							showInLegend: false
						}
					},
				    series: [{
						type: 'pie',
						name: 'regionserver '+containerName.split("Container")[0],
						data: chartData,
						dataLabels: {
							enabled: true,
							color: '#000000',
							connectorColor: '#000000'
						}
					}]
				});
				
				return chart;
			}
			
			function getRSColumnCategories()
			{
				var cate=[];
				cate.push('Storefiles-base:'+minStoreFiles.toString()+' total:'+totalStoreFiles.toString());
				cate.push('MemStoreSize(MB)-base:'+minMemStoreSize.toString()+' total:'+totalMemStoreSize.toString());
				cate.push('StorefileSize(MB)-base:'+minStoreFileSize.toString()+' total:'+totalStoreFileSize.toString());
				cate.push('StorefileIndexSize(MB)-base:'+minStoreFileIndexSize.toString()+' total:'+totalStoreFileIndexSize.toString());
				return cate;
			}
			
			function getRSColumnChart(containerName)
			{
				var chart = new Highcharts.Chart({
					chart: {
						renderTo: containerName,
						defaultSeriesType: 'column'
					},
					title: {
						text: 'Regionserver Load Comparison'
					},
					xAxis: {
						categories: getRSColumnCategories()
					},
					yAxis: {
						min: 0,
						title: {
							text: 'Comparison (the min value as 1)'
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
							return ''+
								this.series.name +': '+ this.y ;
						}
					},
					plotOptions: {
						column: {
							pointPadding: 0.2,
							borderWidth: 0
						}
					},
				        series: getColumnSeries()
				});
				return chart;
			}
			
			function getColumnSeries()
			{
				var series=[];
				var columnData=[];
				for(var j=0;j<names.length;j++)
				{
					columnData=[];
					columnData.push(Math.round(storeFiles[j]*100/minStoreFiles)/100);
					columnData.push(Math.round(memStoreSize[j]*100/minMemStoreSize)/100);
					columnData.push(Math.round(storeFileSize[j]*100/minStoreFileSize)/100);
					columnData.push(Math.round(storeFileIndexSize[j]*100/minStoreFileIndexSize)/100);
					series.push({name: names[j],data: columnData});
				}
				return series;
			}
			
			function switchToMulti()
			{
				regionsChart=getSingleChart(getRegionsData(),"regionsContainer");
				requestsChart=getSingleChart(getRequestsData(),"requestsContainer");
				usedHeapChart=getSingleChart(getUsedHeapData(),"usedHeapContainer");
				

			}
			function showa()
			{
				if(show)
				{
					document.getElementById("regionsContainer").style.display="block";
					document.getElementById("requestsContainer").style.display="block";
					document.getElementById("usedHeapContainer").style.display="block";
					show=false;
				}
				else
				{
					document.getElementById("regionsContainer").style.display="none";
					document.getElementById("requestsContainer").style.display="none";
					document.getElementById("usedHeapContainer").style.display="none";
					show=true;
				}
			}
			
			function swithrstable(showdoc)
			{
				if(showdoc=="table")
				{
					document.getElementById("rsbalance").style.display="none";
					document.getElementById("tablebalance").style.display="block";
				}
				else if(showdoc=="rs")
				{
					document.getElementById("rsbalance").style.display="block";
					document.getElementById("tablebalance").style.display="none";
				}
			}
			
			function dataInit()
			{
				<%
					HTableDescriptor[] tables = new IndexAdmin(conf).listTables();
					rsb.updateStatics(tables);
					List<RSStatics> RSSList=rsb.getRSStatics();
					for(RSStatics rss:RSSList)
					{
						int regions=rss.getRegionsCount();
						int requests=rss.getRequestsCount();
						int loads=rss.getLoads();
						String serverName=rss.getName();
						
						int storeFiles = rss.storeFiles;
       			int memStoreSize = rss.memStoreSize;
       			int storeFileSize = rss.storeFileSize;
       			int storeFileIndexSize =rss.storeFileIndexSize; 
				%>
				names.push("<%=serverName%>");
				requests.push(<%=requests%>);
				totalRequests=totalRequests+<%=requests%>;
				regions.push(<%=regions%>);
				totalRegions=totalRegions+<%=regions%>;
				loads.push(<%=loads%>);
				totalLoads=totalLoads+<%=loads%>;
				
				storeFiles.push(<%=storeFiles%>);
				totalStoreFiles=totalStoreFiles+<%=storeFiles%>;
				if(<%=storeFiles%>!=0)
				{
				if(minStoreFiles==0)minStoreFiles=<%=storeFiles%>;
				else
				{
					if(<%=storeFiles%><minStoreFiles)minStoreFiles=<%=storeFiles%>;
				}
				}
				memStoreSize.push(<%=memStoreSize%>);
				totalMemStoreSize=totalMemStoreSize+<%=memStoreSize%>;
				if(<%=memStoreSize%>!=0)
				{
				if(minMemStoreSize==0)minMemStoreSize=<%=memStoreSize%>;
				else
				{
					if(<%=memStoreSize%><minMemStoreSize)minMemStoreSize=<%=memStoreSize%>;
				}
				}
				storeFileSize.push(<%=storeFileSize%>);
				totalStoreFileSize=totalStoreFileSize+<%=storeFileSize%>;
				if(<%=storeFileSize%>!=0)
				{
				if(minStoreFileSize==0)minStoreFileSize=<%=storeFileSize%>;
				else
				{
					if(<%=storeFileSize%><minStoreFileSize)minStoreFileSize=<%=storeFileSize%>;
				}
				}
				storeFileIndexSize.push(<%=storeFileIndexSize%>);
				totalStoreFileIndexSize=totalStoreFileIndexSize+<%=storeFileIndexSize%>;
		if (<%=storeFileIndexSize%> != 0) {
			if (minStoreFileIndexSize == 0)
				minStoreFileIndexSize = <%=storeFileIndexSize%>	;
			else {
				if (<%=storeFileIndexSize%>	!= 0 && <%=storeFileIndexSize%>	< minStoreFileIndexSize)
					minStoreFileIndexSize = <%=storeFileIndexSize%>	;
			}
		}
	<%
	}
	%>
	if (minStoreFiles == 0)
			minStoreFiles = 1;
		if (minMemStoreSize == 0)
			minMemStoreSize = 1;
		if (minStoreFileSize == 0)
			minStoreFileSize = 1;
		if (minStoreFileIndexSize == 0)
			minStoreFileIndexSize = 1;
	}
	</script>

	</head>
  
  <body bgcolor="#FFFFFF">
  
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.maintenanceTools"/>
			</td>
		</tr>
	</table>
	
	<br><br>
  
  	<div class="demo">
  
	  	<div id="tabs">
	  		<ul>
	  			<li><a href="#tabs-1">Runtime State</a></li>
	  			<li><a href="#tabs-2">RegionServer State</a></li>
	  			<li><a href="#tabs-3">Table State</a>
	  			<li><a href="#tabs-4">Group State</a></li>
	  		</ul>
	  		
	  		<div id="tabs-1">
	  			<iframe src="/runtimeCondition.jsp" width="100%" height="100%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  		
	  		<div id="tabs-2">
	  			<div id="container" style="width: 600; height: 400px; margin: 0 auto; float:left;"></div>
				<div id="dynamicContainer" style="width: 600; height: 400px; margin: 0 auto;"></div>
				<table width="90%" border="1">
					<tr>
						<div id="regionsContainer" style="width: 390; height: 400px; margin: 0 auto; display:none; float:left;"></div>
						<div id="requestsContainer" style="width: 390; height: 400px; margin: 0 auto; display:none; float:left;"></div>
						<div id="usedHeapContainer" style="width: 390; height: 400px; margin: 0 auto; display:none; float:left;"></div>
					</tr>
					<tr>
						<div id="RSColumnContainer" style="width: 390; height: 400px; margin: 0 auto; display:block; float:left;"></div>
					</tr>
				</table>
	  		</div>
	  		
	  		<div id="tabs-3">
	  			<iframe src="/tableState.jsp" width="100%" height="100%" frameborder="0">
	  			</iframe>
	  		</div>
	  		<div id="tabs-4">
	  			<iframe src="/showgroup.jsp" width="100%" height="100%" frameborder="0">
	  			</iframe>
	  		</div>
	  	</div>
	  </div>
  </body>
</html>

<script type="text/javascript">
//ajax
var xmlHttpRequest = createXmlHttpRequestObject();

function handleServerResponse()
{
 if(xmlHttpRequest.readyState == 4)
 {
  if(xmlHttpRequest.status == 200)
  {
   xmlResponse = xmlHttpRequest.responseText;
   var values=xmlResponse.split(",");
   for(var k=0;k<values.length;k++)
   {
   	var tmp=parseInt(values[k]);
   	if(isNaN(tmp))
   	{
   		
   	}
   	else
   	{
   			preValue[k]=tmp;
   	}
  }
  
  preValueSum=0;
  for(var i=0;i<preValue.length;i++)
  	preValueSum=preValueSum+preValue[i];
  }
  else
  {
   //alert('There was a problem accessing the server: ' + xmlHttpRequest.statusText);
  }
 }
}



function process()
{
 if(xmlHttpRequest.readyState == 4 || xmlHttpRequest.readyState == 0)
 {
 	var rsNames="";
 	for(var t=0;t<names.length;t++)
 	{
 		rsNames=rsNames+names[t]+"/";
 	}
 	if(names.length>0)
 	{
  	xmlHttpRequest.open('GET','response.jsp?RS=' + rsNames,true);
  	xmlHttpRequest.onreadystatechange = handleServerResponse;
  	xmlHttpRequest.send(null);
	}
 }
 else
 {
  setTimeout('process()',1000);
 }
}



function createXmlHttpRequestObject()
{
 var xmlHttp;
 if(window.ActiveXObject)
 {
  try
  {
   xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
  }
  catch (e)
  {
   xmlHttp = false;
  }
 }
 else
 {
  try
  {
   xmlHttp = new XMLHttpRequest();
  }
  catch (e)
  {
   xmlHttp = false;
  }
 }
 if(!xmlHttp)
 {
  alert('Error creating the xmlHttpRequest object.');
 }
 else
 {
  return xmlHttp;
 }
}


</script>
