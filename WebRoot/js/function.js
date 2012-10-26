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