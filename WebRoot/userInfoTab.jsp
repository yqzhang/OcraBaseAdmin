<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="java.util.*" %>
<%
	String tableName = request.getParameter("tableName");
	String type = request.getParameter("type");
	HttpSession hs = request.getSession();
	String username = (String)hs.getAttribute("username");
%>
<table width="100%">
	<tr>
		<td align="right">
			<bean:message key="prompt.user"/>
			: 
			<b>
				<%= username %>
			</b>
			&nbsp;
			<a href="/logout.do">
				<bean:message key="prompt.logout"/>
			</a>
		</td>
	</tr>
</table>

<%
	if(tableName != null && (type==null || !type.equals("dropTable") || !type.equals("emptyTable"))) {
%>
	<br><br>
	<table align="center" width="100%" cellspacing="2" cellpadding="2">
		<tr>
			<td class="title" align="center" colspan="2" style="background-color: threedface">
				<%= tableName %>
			</td>
		</tr>
	</table>
<%
	}
%>