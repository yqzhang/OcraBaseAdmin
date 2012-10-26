<%@ page contentType="text/html;charset=gb2312"
  import="java.util.Map"
  import="org.apache.hadoop.io.Writable"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.hbase.client.HTable"
  import="org.apache.hadoop.hbase.client.Get"
  import="org.apache.hadoop.hbase.HTableDescriptor"
  import="org.apache.hadoop.hbase.HRegionInfo"
  import="org.apache.hadoop.hbase.HRegionLocation"
  import="org.apache.hadoop.hbase.HServerAddress"
  import="org.apache.hadoop.hbase.HServerInfo"
  import="org.apache.hadoop.hbase.HServerLoad"
  import="org.apache.hadoop.hbase.io.ImmutableBytesWritable"
  import="org.apache.hadoop.hbase.master.HMaster"
  import="org.apache.hadoop.hbase.util.Bytes"
  import="org.apache.hadoop.hbase.util.FSUtils"
  import="java.util.*"
  import="org.apache.hadoop.hbase.HConstants"%>
<head>
   <title>Region Servers & Tables Balance Summary</title>
<script type="text/javascript"> 
	var mesg="";
 </script>
</head>
<html>
	<body>
<%
Enumeration parameterEnum=request.getParameterNames();
if(parameterEnum.hasMoreElements())
{
	String para=(String)parameterEnum.nextElement();
	if(para.indexOf("RSLocation_")!=-1)
	{
		
		String key=request.getParameter(para);
		String tableName=para.split("RSLocation_")[1];
		out.println("表：");
		out.println(tableName);
		out.println("<p>Key：");
		if(key=="")out.println("请输入key啊");
		else
		{
				
				out.println(key);
				HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
				Configuration conf = master.getConfiguration();
				HTable table= new HTable(conf, tableName);
				try
				{
					HRegionLocation hrl=table.getRegionLocation(key);
					String rsname=hrl.getServerAddress().getHostname();
					HRegionInfo regionInfo=hrl.getRegionInfo();
					out.println("<p>落在RS：");
					out.println(rsname);
					out.println("<p>落在Region：");
					out.println(regionInfo.getRegionNameAsString());
					String detailInfo=regionInfo.toString();
					%>
					<script>
					mesg="<%=detailInfo%>";
					</script>
					<input type="button" onClick="showMsg();" value="详细信息" /> 
					<%
				}catch (java.io.IOException e)
				{
					e.printStackTrace();
				}
		}
	}
	else if(para.indexOf("Query_")!=-1)
	{
		String key=request.getParameter(para);
		String tableName=para.split("Query_")[1];
		out.println("表：");
		out.println(tableName);
		out.println("<p>Key：");
		if(key=="")out.println("请输入key");
		else
		{
				out.println(key);
				HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
				Configuration conf = master.getConfiguration();
				HTable table= new HTable(conf, tableName);
				try
				{
					String result=table.get(new Get(Bytes.toBytes(key))).toString();
					out.println("<p>结果：");
					out.println(result);
				}catch (java.io.IOException e)
				{
					e.printStackTrace();
				}
		}
	}
	
	
} 
%>


<div id="divbackblack" style="position:absolute; left:0; top:0; width:100%; height:100%; z-index:100; background:#000; display:none; filter:alpha(opacity=30);-moz-opacity:.7;opacity:0.7;"></div> 



<div id="alertautoshow" style="position:absolute; left:100px; top:100px; width:330px; height:120px; display:none; z-index:1000;background:#FFFFFF;"> 
<table border="0" width="100%" cellpadding="0" cellspacing="0"> 
   <tr> 
    <td height="30" bgcolor="#b6cdfb">   提示：</td> 
   </tr> 
   <tr> 
    <td height="90" align="center"><span id="outstr1"></span></td> 
   </tr> 
</table> 
</div> 




<div id="alertshow" style="position:absolute; left:100px; top:100px; width:95%; height:95%; display:none; z-index:1000;background:#FFFFFF;"> 
<table border="0" width="100%" cellpadding="0" cellspacing="0"> 
   <tr> 
    <td height="30" bgcolor="#b6cdfb">   Region Info：</td> 
   </tr> 
   <tr> 
    <td height="50" align="center"><span id="outstr2"></span></td> 
   </tr> 
   <tr> 
    <td height="30" align="center"><input id="buttonshow" type="button" value=" 确 定 " onClick="cencelDiv()"></td> 
   </tr> 
</table> 
</div> 


<script type="text/javascript"> 
/*function showMsg()
{
	alert(mesg);
}*/
function alertAutoOut(str){ 
   document.getElementById("outstr1").innerHTML=str; 
   var h = window.document.body.scrollHeight; 
   if(h<document.body.clientHeight){ 
    h=document.body.clientHeight; 
   } 
   var div_type = document.getElementById("alertautoshow"); 
   var div_hei = document.getElementById("divbackblack"); 
   
   div_type.style.left = (document.body.offsetWidth-300)/2; 
   div_type.style.top = document.body.scrollTop+20; 
   
   var s = document.getElementsByTagName("select"); 
   for( var i=0;i<s.length;i++){ 
    s.style.display="none"; 
   }   
    div_hei.style.height=h; 
    div_hei.style.display = "block"; 
    div_type.style.display = "block"; 
    div_type.focus(); 
    window.setTimeout("cencelDiv()", 3000); 
} 
function showMsg(){ 
   document.getElementById("outstr2").innerHTML=mesg; 
   var h = window.document.body.scrollHeight; 
   if(h<document.body.clientHeight){ 
    h=document.body.clientHeight; 
   } 
   var div_type = document.getElementById("alertshow"); 
   var div_hei = document.getElementById("divbackblack"); 
   //(document.body.offsetWidth-300)/2
   div_type.style.left = 20; 
   div_type.style.top = document.body.scrollTop+20; 
   
   var s = document.getElementsByTagName("select"); 
   for( var i=0;i<s.length;i++){ 
    s.style.display="none"; 
   }   
    div_hei.style.height=h; 
    div_hei.style.display = "block"; 
    div_type.style.display = "block"; 
    document.getElementById("buttonshow").focus(); 
} 
function cencelDiv(){   //放弃 
    var alertautoshow = document.getElementById("alertautoshow"); 
    var alertshow = document.getElementById("alertshow"); 
    var divbackblack = document.getElementById("divbackblack"); 
    var s = document.getElementsByTagName("select"); 
   
    for( var i=0;i<s.length;i++){ 
    s.style.display="inline"; 
   } 
   alertautoshow.style.display="none"; 
   alertshow.style.display="none"; 
   divbackblack.style.display="none"; 
   } 
</script> 


	</body>
</html>



