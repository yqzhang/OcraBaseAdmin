<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="/loginCheck.jsp" />
<jsp:include page="/userInfoTab.jsp"/>

	<script type="text/javascript">
		function areYouSure(theUrl,theMessage) {
		  var rs;
		  if(arguments.length==0) {
		    return confirm('Are you sure?');
		  }
		  else if(arguments.length==1) {
		    rs = confirm('Are you sure?');
		    if(rs) {
		      document.location.href = theUrl;
		    }
		  }
		  else {
		    rs = confirm(theMessage);
		    if(rs) {
		      document.location.href = theUrl;
		    }
		  }
		}
	</script>

	<%
		String section = request.getParameter("section");
		String tableName = request.getParameter("tableName");
	%>
	<br>
	
	<bean:message key="prompt.blank"/>
	
  	<table cellpadding="5" cellspacing="0">
  		<tr>
  		<%
  			// ----- View Descriptor -----
  			if (section.equals("viewDescriptor")) {
  		%>
  			<td style="background-color: threedface">
	  			<B>
					<bean:message key="prompt.viewDescriptor"/>
				</B>
			</td>
  		<%
  			}
  			else {
  		%>
  			<td>
				<a href="/viewTableDetail.do?tableName=<%=tableName%>&type=viewDescriptor">
					<bean:message key="prompt.viewDescriptor"/>
				</a>
			</td>
		<%
			}
		%>
  		<%
  			// ----- Browse Table -----
  			if (section.equals("browseTable")) {
  		%>
  			<td style="background-color: threedface">
	  			<B>
					<bean:message key="prompt.browseTable"/>
				</B>
			</td>
  		<%
  			}
  			else {
  		%>
  			<td>
				<a href="/viewTableDetail.do?tableName=<%=tableName%>&type=browseTable">
					<bean:message key="prompt.browseTable"/>
				</a>
			</td>
		<%
			}
		%>
  		<%
  			// ----- Insert Data -----
  			if (section.equals("insertData")) {
  		%>
  			<td style="background-color: threedface">
	  			<B>
					<bean:message key="prompt.insertData"/>
				</B>
			</td>
  		<%
  			}
  			else {
  		%>
  			<td>
				<a href="/viewTableDetail.do?tableName=<%=tableName%>&type=insertData">
					<bean:message key="prompt.insertData"/>
				</a>
			</td>
		<%
			}
		%>
  		<%
  			// ----- Import Data -----
  			if (section.equals("importData")) {
  		%>
  			<td style="background-color: threedface">
	  			<B>
					<bean:message key="prompt.importData"/>
				</B>
			</td>
  		<%
  			}
  			else {
  		%>
  			<td>
				<a href="/viewTableDetail.do?tableName=<%=tableName%>&type=importData">
					<bean:message key="prompt.importData"/>
				</a>
			</td>
		<%
			}
		%>
		<%
  			// ----- Query Data -----
  			if (section.equals("queryData")) {
  		%>
  			<td style="background-color: threedface">
	  			<B>
					<bean:message key="prompt.queryData"/>
				</B>
			</td>
  		<%
  			}
  			else {
  		%>
  			<td>
				<a href="/viewTableDetail.do?tableName=<%=tableName%>&type=queryData">
					<bean:message key="prompt.queryData"/>
				</a>
			</td>
		<%
			}
		%>
  		<%
  			// ----- Empty Table -----
  		%>
  			<td>
				<a href="javascript:areYouSure('/viewTableDetail.do?tableName=<%= tableName %>&type=emptyTable')">
					<bean:message key="prompt.emptyTable"/>
				</a>
			</td>
		<%
  			// ----- Drop Table -----
  		%>
  			<td>
				<a href="javascript:areYouSure('/viewTableDetail.do?tableName=<%= tableName %>&type=dropTable')">
					<bean:message key="prompt.dropTable"/>
				</a>
			</td>
		</tr>
	</table>
