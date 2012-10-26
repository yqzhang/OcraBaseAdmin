<%@ page contentType="text/html;charset=gb2312"
  import="java.util.Map"
  import="org.apache.hadoop.io.Writable"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.hbase.client.HTable"
  import="org.apache.hadoop.hbase.HTableDescriptor"
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
  
<html>
	<body>
<h1>Balance Result:</h1><p>
<table align="top">
	<tr>
		<td>
<h>
<%
		List<String> moveRecord=new ArrayList<String>();
    String reqtableName=request.getParameter("tableName");
    HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
    List<HServerInfo> onlineServerInfos = master.getServerManager().getOnlineServersList();
    List<HServerAddress> onlineServerAddrs = new ArrayList<HServerAddress>();
    for(HServerInfo server: onlineServerInfos){
        onlineServerAddrs.add(server.getServerAddress());
    }
    int rsCount=onlineServerInfos.size();
    Configuration conf = master.getConfiguration();
    IndexAdmin hbadmin = new IndexAdmin(conf);
    List<String> balanceTables = new ArrayList<String>();
    if(reqtableName == null || "".equals(reqtableName.trim())){
        HTableDescriptor[] tables = hbadmin.listTables();
        for(HTableDescriptor tableDesc: tables){
            balanceTables.add(tableDesc.getNameAsString());
        }
    }
    else{
        balanceTables.add(reqtableName);
    }
    
    for(String tableName: balanceTables){
        reqtableName = tableName;
    HTable table = new HTable(conf, tableName);
    Map<HRegionInfo, HServerAddress> regions = table.getRegionsInfo();
    int perRSCount=regions.size()/rsCount;
    int perRSCountMax = perRSCount;
    if(regions.size() % rsCount !=0 ){
       perRSCountMax += 1;
    }
    int i=0;
    final Map<HServerAddress,List<HRegionInfo>> rsCounts=new HashMap<HServerAddress,List<HRegionInfo>>();
    for(Map.Entry<HRegionInfo, HServerAddress> hriEntry : regions.entrySet()) {
       /*if(i==0){
          i=1;
          continue;
       }*/
       HServerAddress addr = hriEntry.getValue();

       HRegionInfo regionInfo = hriEntry.getKey();
       
       if(rsCounts.containsKey(addr)){
           rsCounts.get(addr).add(regionInfo);
       }
       else{
           List<HRegionInfo> regionInfos=new ArrayList<HRegionInfo>();
           regionInfos.add(regionInfo);
           rsCounts.put(addr,regionInfos);
       }
    }
    


    
    
    // 按照Region Server的Region数进行排序，形成两个List，一个为顺序，一个为倒序    

    HServerAddress[] orderAddresses = onlineServerAddrs.toArray(new HServerAddress[onlineServerAddrs.size()]);
    Arrays.sort(orderAddresses,new Comparator<HServerAddress>(){
      
         public int compare(HServerAddress leftServer,HServerAddress rightServer){
             if(rsCounts.containsKey(rightServer) && !rsCounts.containsKey(leftServer)){
                 return -1;
             }
             if(rsCounts.containsKey(rightServer) && rsCounts.containsKey(leftServer)){
             	if( rsCounts.get(rightServer).size() >= rsCounts.get(leftServer).size() ){
                    return -1;
             	}
             }
             return 1;
         }             

    });
    HServerAddress[] reverseAddresses = rsCounts.keySet().toArray(new HServerAddress[rsCounts.keySet().size()]);
    Arrays.sort(reverseAddresses,new Comparator<HServerAddress>(){
             
         public int compare(HServerAddress rightServer,HServerAddress leftServer){
             if(rsCounts.containsKey(rightServer) && !rsCounts.containsKey(leftServer)){
                 return -1;
             }
             if(rsCounts.containsKey(rightServer) && rsCounts.containsKey(leftServer)){
             	if( rsCounts.get(rightServer).size() >= rsCounts.get(leftServer).size() ){
                    return -1;
             	}
             }
             return 1;
            }
         

    });
    // 遍历倒序的List
    for(HServerAddress serverAddress: reverseAddresses){
        int regionNums = rsCounts.get(serverAddress).size();
        if(regionNums > perRSCountMax){
        	if(regionNums==1)continue;
           for(i=0;i < regionNums-perRSCountMax; i++){
                // 这里为需要move的region，计算其目的地
                HRegionInfo regionInfo = rsCounts.get(serverAddress).get(i);
                for(HServerAddress toServerAddress: orderAddresses){
                     if(!rsCounts.containsKey(toServerAddress) || rsCounts.get(toServerAddress).size() < perRSCountMax){
                          String regionName=Bytes.toStringBinary(regionInfo.getRegionName());
                          String encodeRegionName=regionName.substring((regionName.lastIndexOf(".",regionName.length()-2))+1,regionName.length()-1);
                          HServerInfo serverInfo = master.getServerManager().getHServerInfo(toServerAddress);
                          String targetServer = toServerAddress.getHostname() + "," + toServerAddress.getPort() + "," + serverInfo.getStartCode();
                          try{
                          	hbadmin.move(Bytes.toBytes(encodeRegionName),Bytes.toBytes(targetServer));
                          	if(rsCounts.containsKey(toServerAddress)){
                              		rsCounts.get(toServerAddress).add(regionInfo);
                          	}
                          	else{
                              		List<HRegionInfo> regionInfos=new ArrayList<HRegionInfo>();
           		      		regionInfos.add(regionInfo);
           		      		rsCounts.put(toServerAddress,regionInfos);
                          	}
                          	rsCounts.get(serverAddress).remove(regionInfo);
                          moveRecord.add(reqtableName+" move region "+serverAddress.getHostname()+" -> "+toServerAddress.getHostname());
                         	
                          }catch (Exception t)
                          {
                          	//out.println(t.toString());
                          	out.println("move failed :"+serverAddress.getHostname()+" to "+toServerAddress.getHostname()+" <br>");
                          }
                          break;
                          
                     }
                }
                Arrays.sort(orderAddresses,new Comparator<HServerAddress>(){
							public int compare(HServerAddress leftServer,HServerAddress rightServer){
             if(rsCounts.containsKey(rightServer) && !rsCounts.containsKey(leftServer)){
                 return -1;
             }
             if(rsCounts.containsKey(rightServer) && rsCounts.containsKey(leftServer)){
             	if( rsCounts.get(rightServer).size() >= rsCounts.get(leftServer).size() ){
                    return -1;
             	}
             }
             return 1;
         }             

    });
                
                
           }
        }
        
        
    }
    
        //移动前
    		List<HServerAddress> serverAddressList = new ArrayList(rsCounts.keySet());
      	Collections.sort(serverAddressList, new Comparator<HServerAddress>(){
            	
            	public int compare(HServerAddress leftServer,HServerAddress rightServer)
            	{
                    return leftServer.getHostname().compareTo(rightServer.getHostname());
            	}
            	
            });
    
    out.println("balance "+tableName+" success,result is: <br>");
    
    for(HServerAddress serverAddress: serverAddressList){
       out.println(serverAddress.getHostname()+":"+serverAddress.getPort()+" regions: "+rsCounts.get(serverAddress).size()+"<br>");
    }
    out.println("<p>");
    }
    out.println("</td></h><td><h1>Move Record :</h1><p><h>");
    for(String record: moveRecord)
    	out.println(record+"<p>");
    //out.println("<script>setTimeout('backHome()',3000);</script>");
%>
</td>
</tr>
</table>


</body>
</html>
<script>
   function backHome(){
     window.location.href='showTableBalance.jsp?tableName='+"<%=reqtableName%>";
   }
</script>
