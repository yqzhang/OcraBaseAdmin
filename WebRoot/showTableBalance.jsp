<%@ page contentType="text/html;charset=UTF-8"
  import="java.util.Map"
  import="org.apache.hadoop.io.Writable"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.hbase.client.HTable"
  import="ict.ocrabase.main.java.client.webinterface.IndexAdmin"
  import="org.apache.hadoop.hbase.HRegionInfo"
  import="org.apache.hadoop.hbase.HServerAddress"
  import="org.apache.hadoop.hbase.HServerInfo"
  import="org.apache.hadoop.hbase.io.ImmutableBytesWritable"
  import="org.apache.hadoop.hbase.master.HMaster" 
  import="org.apache.hadoop.hbase.util.Bytes"
  import="org.apache.hadoop.hbase.util.FSUtils"
  import="java.util.*"
  import="org.apache.hadoop.hbase.HConstants"%>
<%
    String tableName=request.getParameter("tableName");
    HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
    Configuration conf = master.getConfiguration();
    HTable table = new HTable(conf, tableName);
    IndexAdmin hbadmin = new IndexAdmin(conf);
    Map<HRegionInfo, HServerAddress> regions = table.getRegionsInfo();
    int i=0;
    Map<String,List> rsCounts=new HashMap<String,List>();
    for(Map.Entry<HRegionInfo, HServerAddress> hriEntry : regions.entrySet()) {
       /*if(i==0){
          i=1;
          continue;
       }*/
       HServerAddress addr = hriEntry.getValue();

       int infoPort = 0;
       String urlRegionServer = null;

       if (addr != null) {
          HServerInfo info = master.getServerManager().getHServerInfo(addr);
          if (info != null) {
             infoPort = info.getInfoPort();
             urlRegionServer =
                  "http://" + addr.getHostname().toString() + ":" + infoPort + "/";
          }
       }
       HRegionInfo regionInfo = hriEntry.getKey();
       String regionName=Bytes.toStringBinary(regionInfo.getRegionName());
       String encodeRegionName=regionName.substring((regionName.lastIndexOf(".",regionName.length()-2))+1,regionName.length()-1);
       if(rsCounts.containsKey(urlRegionServer)){
           rsCounts.get(urlRegionServer).add(encodeRegionName);
       }
       else{
           List<String> regionNames=new ArrayList<String>();
           regionNames.add(encodeRegionName);
           rsCounts.put(urlRegionServer,regionNames);
       }
    }
    //out.println("<a href='history.go(-1)'><h3>Home</h3></a>");
    out.println("Regions Count: "+regions.size()+"&nbsp;&nbsp;");
    int onlineServers=master.getServerManager().getOnlineServersList().size();
    out.println("Online servers: "+onlineServers);
    out.println("<br>");
    boolean isNeedBalance = false;
    int perRegions=0;
    int perRegionsMax=0;
    if(regions.size() <= onlineServers){
       perRegions = 1;
       perRegionsMax = 1;
    } 
    else{
       perRegions = regions.size()/onlineServers;
       if(regions.size() % onlineServers==0){
           perRegionsMax = perRegions;
       }
       else{
           perRegionsMax = perRegions+1;
       }
    }
    out.println("Table used region servers: "+rsCounts.size()+", per region server's regions should be: ["+perRegions+","+perRegionsMax+"]");
    out.println("<br>");
    out.println("<table><tr><td width=230>Region Server Url</td><td>Region Counts</td></tr>");
    String[] serverNames = rsCounts.keySet().toArray(new String[rsCounts.size()]);
    Arrays.sort(serverNames);
    for(String serverName: serverNames){
       out.println("<tr><td>");
       out.println(serverName);
       out.println("</td><td><table border=0><tr>");
       int rsCountSize = rsCounts.get(serverName).size();
       for(int j=0;j<rsCountSize;j++){
          if(j > perRegionsMax-1){
            isNeedBalance = true;
            out.println("<td width=2 bgcolor=red>&nbsp;</td>");
          }
          else{
            out.println("<td width=2 bgcolor=green>&nbsp;</td>");
          }
       }
       out.println("</tr></table></td></tr>");
    }
    out.println("</table>");
    if(isNeedBalance){
        out.println("<br><font color=red>it seems table not balance well</font>,do u need do table balance,just <a href=makebalance.jsp?tableName="+tableName+">click here!</a>");
    }
%>

<script>
	function doBalance()
	{
		window.location="dobalance.jsp?tableName="+"<%=tableName%>";
	}
</script>
