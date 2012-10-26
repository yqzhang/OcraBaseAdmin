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

  </head>
  
  <body bgcolor="#FFFFFF">
  
  	<jsp:include page="/userInfoTab.jsp"/>
  	<br>
  	<br>
  
  	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
  			<td class="title" align="center" colspan="2" style="background-color: threedface">
  				<bean:message key="prompt.performanceTest"/>
			</td>
		</tr>
	</table>
	
	<br><br>
  
  	<div class="demo">
  
	  	<div id="tabs">
	  		<ul>
	  			<li><a href="#tabs-1">Data Generation</a></li>
	  			<li><a href="#tabs-2">BulkLoad</a></li>
	  			<li><a href="#tabs-3">Index Import</a>
	  			<li><a href="#tabs-4">Statistics Query</a></li>
	  			<li><a href="#tabs-5">Benchmark</a></li>
	  		</ul>
	  		
	  		<div id="tabs-1">
	  			<html:form action="/testDataGeneration" target="testDataGenerationFrame">
	  				<b>Data Set</b>
	  				<html:select property="dataSet">
	  					<html:option value="testA">testA</html:option>
	  					<html:option value="testB">testB</html:option>
	  					<html:option value="testC">testC</html:option>
	  				</html:select>
					
					<br><br>
					
					<b>Data Size</b>
					<html:text property="dataSize"></html:text>
					<br>
	  				(Example:10000000)
					
					<br><br>
					
					<b>Thread Number</b>
					<html:text property="threadNumber"></html:text>
					<br>
	  				(Example:4)
	  				
	  				<br><br>
	  				
	  				<html:submit>
						<bean:message key="prompt.submit"/>
					</html:submit>
					<html:reset>
						<bean:message key="prompt.reset"/>
					</html:reset>
	  			</html:form>
	  			
	  			<iframe id="testDataGenerationFrame" width="100%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  		
	  		<div id="tabs-2">
	  			<html:form action="/testBulkLoad" target="testBulkLoadFrame">
	  				<b>Table Name</b>
	  				<html:text property="tableName"></html:text>
	  				<br>
	  				(Example:CCIndextestA)
	  				
	  				<br><br>
	  				
	  				<b>Data Resource</b>
	  				<html:text property="dataRes"></html:text>
	  				<br>
	  				(Example:hdfs://wanhao-pc:8020/ccindex/testA)
	  				
	  				<br><br>
	  				
	  				<html:submit>
						<bean:message key="prompt.submit"/>
					</html:submit>
					<html:reset>
						<bean:message key="prompt.reset"/>
					</html:reset>
	  			</html:form>
		  			
		  		<iframe id="testBulkLoadFrame" width="100%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  		
	  		<div id="tabs-3">
	  			<html:form action="/testIndexImport" target="testIndexImportFrame">
	  				<b>HBASE_HOME</b>
	  				<html:text property="hbaseHome"></html:text>
	  				<br>
	  				(Example:/opt/ccindex/hbase-0.90.2-ccindex/)
	  				
	  				<br><br>
	  				
	  				<b>Clients / Host</b>
	  				<html:text property="clientsPerHost"></html:text>
	  				<br>
	  				(Example:4)
	  				
	  				<br><br>
	  				
	  				<b>Threads / Client</b>
	  				<html:text property="threadsPerClient"></html:text>
	  				<br>
	  				(Example:10)
	  				
	  				<br><br>
	  				
	  				<b>Index Array</b>
	  				<html:text property="indexArray"></html:text>
	  				<br>
	  				(Example:1,3,6)
	  				
	  				<br><br>
	  				
	  				<html:submit>
						<bean:message key="prompt.submit"/>
					</html:submit>
					<html:reset>
						<bean:message key="prompt.reset"/>
					</html:reset>
	  			</html:form>
	  			
	  			<iframe id="testIndexImportFrame" width="100%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  		
	  		<div id="tabs-4">
	  			<html:form action="/testStatisticsQuery" target="testStatisticsQueryFrame">
	  				<b>Query</b>
	  				<br>
	  				<br>
	  				<html:textarea property="query" style="width:100%; height:20%" ></html:textarea>
	  				<br><Br>
	  				(Example [CCIndex Query]:select cf1:c2 cf2:c1 from CCIndextestA where  (cf1:c2>'0a' and cf1:c2<'0z' )  and  (cf2:c1>'01' and cf2:c1<'09' ))
	  				<br><br>
	  				(Example [Statistics]:)
	  				
	  				<br><br>
	  				
	  				<html:submit>
						<bean:message key="prompt.submit"/>
					</html:submit>
					<html:reset>
						<bean:message key="prompt.reset"/>
					</html:reset>
	  			</html:form>
	  			
	  			<iframe id="testStatisticsQueryFrame" width="100%" height="50%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  		
	  		<div id="tabs-5">
	  			<html:form action="/testBenchmark" target="testBenchmarkFrame">
	  				<b>HBASE_HOME</b>
	  				<html:text property="hbaseHome"></html:text>
	  				<br>
	  				(Default run one client on region server,client list on $HBASE_HOME/conf/regionservers)
	  				
	  				<br><br>
	  				
	  				<b>Thread number</b>
	  				<html:text property="threadNumber"></html:text>
	  				<br>
	  				(If method is set to scan , thread number will be set to 37 automaticly !)
	  				
	  				<br><br>
	  				
	  				<b>Table Descriptor</b>
	  				<html:text property="tableDescriptor"></html:text>
	  				<br>
	  				(Example: "testAA;cf1,c1,30;cf1,c2,30;cf2,c1,30")
	  				
	  				<br><br>
	  				
	  				<b>Method</b>
	  				<html:select property="method">
	  					<html:option value="Write">Write</html:option>
	  					<html:option value="Read">Read</html:option>
	  				</html:select>
	  				
	  				<br><br>
	  				
	  				<b>Data Source</b>
	  				<html:text property="dataResource"></html:text>
	  				<br>
	  				(Example: "hdfs://node22:8020/ccindex/testA" )
	  				
	  				<br><br>
	  				
	  				<b>Data Type</b>
	  				<html:select property="dataType">
	  					<html:option value="A">A</html:option>
	  					<!-- 
	  					<html:option value="B">B</html:option>
	  					<html:option value="C">C</html:option>
	  					 -->
	  				</html:select>
	  				
	  				<br><br>
	  				
	  				<html:submit>
						<bean:message key="prompt.submit"/>
					</html:submit>
					<html:reset>
						<bean:message key="prompt.reset"/>
					</html:reset>
	  			</html:form>
	  			
	  			<iframe id="testBenchmarkFrame" width="100%" frameborder=”no” marginwidth=”0″ marginheight=”0″ scrolling=”no”>
	  			</iframe>
	  		</div>
	  	</div>
	  </div>
  </body>
</html>
