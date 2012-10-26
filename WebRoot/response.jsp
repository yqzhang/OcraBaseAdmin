<%@ page contentType="text/html;charset=gb2312"
  import="java.util.Map"
  import="org.apache.hadoop.io.Writable"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.hbase.client.HTable"
  import="org.apache.hadoop.hbase.client.Get"
  import="org.apache.hadoop.hbase.HTableDescriptor"
  import="org.apache.hadoop.hbase.client.HBaseAdmin"
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
String paraValue=request.getParameter("RS");
String rsNames[]=paraValue.split("/");
HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
Configuration conf = master.getConfiguration();
Map<String, HServerInfo> serverToServerInfos = master.getServerManager().getOnlineServers();
String[] serverNames = serverToServerInfos.keySet().toArray(new String[serverToServerInfos.size()]);
for(String rsName:rsNames)
{
	boolean online=false;
	for(String serverName: serverNames)
	{
		if(serverName.indexOf(rsName)!=-1)
		{
			
			HServerInfo serverInfo = serverToServerInfos.get(serverName);
			HServerLoad load = serverInfo.getLoad();
			int requests = load.getNumberOfRequests();
			out.print(requests+",");
			online=true;
			break;
		}
	}
	if(!online)out.print("-1,");
}
%>



