<%
	HttpSession hs = request.getSession();
	if(hs.getAttribute("username") == null) {
		//out.println("<script>alert('Please login first.');window.location='login.jsp';</script>");
	}
%>