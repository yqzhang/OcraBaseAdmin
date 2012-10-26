<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@page	import="ict.ocrabase.main.java.regionserver.statclient.SQLStatus"
		import="ict.ocrabase.main.java.regionserver.StatResult"
		import="ict.ocrabase.main.java.regionserver.CellResult"
		import="org.apache.hadoop.hbase.util.Bytes"
		import="java.util.*"
		import="ict.ocrabase.main.java.regionserver.StatField"
		import="ict.ocrabase.main.java.regionserver.StatUtils"
		import="com.ict.hbase.calserver.CalScan.Operator"%>

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

  </head>
  
  <body>
  	<%
	Object queryobj = request.getSession().getAttribute("QUERYTD");
	System.out.println("step1");
	if (queryobj == null) {
		System.out.println("No Running Query Thread.");
	}
	else {
		System.out.println("step2");
		SQLStatus querytd = (SQLStatus) queryobj;
		boolean finished = querytd.isIsfinished();
	    if (!finished) {
			out.println("Process not finished");
	    }
		else {
			System.out.println("step3");
			StatResult sr = querytd.getStatresult();
			if (sr == null) {
				System.out.println("Error occured.");
				out.println("Error occured.");
				
				return ;
			}

			final int RANGE = 30;
			int currentno = 0;
			String pageno = request.getParameter("pageno");
			if (pageno == null) {
				currentno = 0;
			}
			else {
				currentno = Integer.valueOf(pageno);
			}
			
			System.out.println("step4");
			
			out.println("<h2>Show Query Result</h2>");
			out.println("<br>Need Sort:" + sr.isNeedsort() + "<br>");
			out.println("<br>StartRow:" + Bytes.toString(sr.getStartrowkey()));
			out.println("<br>StopRow:" + Bytes.toString(sr.getStoprowkey()));
			out.println("<br>TotalRow:" + sr.getTotalrownum());
			
			System.out.println("step5");
			
			int groupsize = sr.getStatresult().size();
			out.println("<br>Group Length:" + groupsize+"<br>");
			int startno = currentno * RANGE;
			int stopno = (currentno + 1) * RANGE >= groupsize ? groupsize: (currentno + 1) * RANGE;
			out.println("<br>startno "+ startno);
			out.println("<br>stopno "+ stopno);
			out.println("<br>sort key size :"+sr.getSortedGroupKeys().size());
			
			System.out.println("step6");
			
			if (sr.isNeedsort()) {
				int index = 0;
				for (byte[] gp : sr.getSortedGroupKeys()) {
					if (index < startno) {
						index++;
						continue;
					}
					else if (index >= stopno) {
	            		break;
					}
					
	          		index++;
	          		
					out.println("<br>=====gpname:" + Bytes.toString(gp) + "<br>");
					
					for (CellResult cr : sr.getStatresult().get(gp)) {
						out.println(" Family:" + Bytes.toString(cr.family));
						out.println(" Field:" + Bytes.toString(cr.cellname));
						out.println(" DSum:" + cr.dsum);
						out.println(" Sum:" + cr.sum);
						out.println(" Count:" + cr.count);
					}
					
	          		if (sr.isNeeddistinct()) {
			          List<StatField> recordrules = StatUtils.getRecordRuleList(sr.getRules());
			          for (int j = 0; j < recordrules.size(); j++) {
			            if (recordrules.get(j).getOp().equals(Operator.distinct)) {
			              System.out.printf("\tdisCount:"
			                  + Bytes.toLong(sr.getRecordresultlist().get(gp)
			                      .get(j)));
			            }
			          }
			        }
				}
			}
			else {
				int index = 0;
				for (Map.Entry<byte[], List<CellResult>> entry : sr.getStatresult().entrySet()) {
					if (index < startno) {
						index++;
						continue;
					}
					else if (index >= stopno) {
	            		break;
	          		}
	          		
	          		index++;
	         		
            		out.println("<br>=====gpname:" + Bytes.toString(entry.getKey()) + "<br>");
	          		
	          		for (CellResult cr : entry.getValue()) {
	            		out.println(" Family:" + Bytes.toString(cr.family));
	            		out.println(" Field:" + Bytes.toString(cr.cellname));
	            		out.println(" DSum:" + cr.dsum);
	            		out.println(" Sum:" + cr.sum);
	            		out.println(" Count:" + cr.count);
	          		}
	          		if (sr.isNeeddistinct()) {
			          List<StatField> recordrules = StatUtils.getRecordRuleList(sr.getRules());
			          for (int j = 0; j < recordrules.size(); j++) {
			            if (recordrules.get(j).getOp().equals(Operator.distinct)) {
			              System.out.printf("\tdisCount:"
			                  + Bytes.toLong(sr.getRecordresultlist().get(entry.getKey())
			                      .get(j)));
			            }
			          }
			        }
	        	}
	      	}
			out.println("<br><br><a href='" + basePath + "testStatisticsResult.jsp?pageno=0'>First</a>");
			out.println("<a href='" + basePath + "testStatisticsResult.jsp?pageno="+((currentno>0)?currentno-1:0)+"'>Prev</a>");
			out.println("<a href='" + basePath + "testStatisticsResult.jsp?pageno="+((currentno<groupsize/RANGE-1)?currentno+1:groupsize/RANGE)+"'>After</a>");
			out.println("<a href='" + basePath + "testStatisticsResult.jsp?pageno="+groupsize/RANGE+"'>Last</a>");
		}
	}
	%>
  </body>
</html>
