function $() 
{ 
      var elements = new Array(); 
      for (var i = 0; i < arguments.length; i++) 
      { 
        var element = arguments[i]; 
        if (typeof element == 'string') 
          element = document.getElementById(element); 
        if (arguments.length == 1) 
          return element; 
        elements.push(element); 
      } 
      return elements; 
}


function Show(message){
    HideElement();
    var eSrc=(document.all)?window.event.srcElement:arguments[1];
    var shield = document.createElement("DIV");//产生一个背景遮罩层
    shield.id = "shield";
    shield.style.position = "absolute";
    shield.style.left = "0px";
    shield.style.top = "0px";
    shield.style.width = "100%";
    shield.style.height = ((document.documentElement.clientHeight>document.documentElement.scrollHeight)?document.documentElement.clientHeight:document.documentElement.scrollHeight)+"px";
    //shield.style.height =document.body.scrollHeight;
    shield.style.background = "#333";
    shield.style.textAlign = "center";
    shield.style.zIndex = "10000";
    shield.style.filter = "alpha(opacity=0)";
    shield.style.opacity = 0;

    var alertFram = document.createElement("DIV");//产生一个提示框
    var height="50px";
    alertFram.id="alertFram";
    alertFram.style.position = "absolute";
    alertFram.style.width = "200px";
    alertFram.style.height = height;
    alertFram.style.left = "35%";
    alertFram.style.top = "30%";
   // alertFram.style.marginLeft = "-225px" ;
   // alertFram.style.marginTop = -75+document.documentElement.scrollTop+"px";
    alertFram.style.background = "#fff";
    alertFram.style.textAlign = "center";
    alertFram.style.lineHeight = height;
    alertFram.style.zIndex = "10001";

   strHtml =" <div style=\"width:100%; border:#58a3cb solid 1px; text-align:center;padding-top:10px \">";
   strHtml+="";
   if (typeof(message)=="undefined"){
        strHtml+=" 正在服务器上执行, 请稍候";
    } 
    else{
        strHtml+=message;
    }
   strHtml+=" </div>";

    strHtml+="<iframe src=\"\" style=\"position:absolute; visibility:inherit;top:0px; left:0px; width:300px; height:100px; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';\"></iframe>";//加个iframe防止被drowdownlist等控件挡住

    alertFram.innerHTML=strHtml;
    document.body.appendChild(alertFram);
    document.body.appendChild(shield);

    this.setOpacity = function(obj,opacity){
        if(opacity>=1)opacity=opacity/100;
        try{ obj.style.opacity=opacity; }catch(e){}
        try{ 
            if(obj.filters.length>0&&obj.filters("alpha")){
            obj.filters("alpha").opacity=opacity*100;
            }else{
            obj.style.filter="alpha(opacity=\""+(opacity*100)+"\")";
            }
        }
        catch(e){}
    }

    var c = 0;
    this.doAlpha = function(){
    if (++c > 20){clearInterval(ad);return 0;}
    setOpacity(shield,c);
    }
    var ad = setInterval("doAlpha()",1);//渐变效果

    eSrc.blur();
    document.body.onselectstart = function(){return false;}
    document.body.oncontextmenu = function(){return false;}
}

   //隐藏页面上一些特殊的控件
function HideElement(){
    var HideElementTemp = new Array('IMG','SELECT','OBJECT','IFRAME');
    for(var j=0;j<HideElementTemp.length;j++){
        try{
                var strElementTagName=HideElementTemp[j];
                for(i=0;i<document.all.tags(strElementTagName).length; i++){
                    var objTemp = document.all.tags(strElementTagName)[i];
                    if(!objTemp||!objTemp.offsetParent)
                             continue;
                   //objTemp.style.visibility="hidden";
                   objTemp.disabled="disabled"
                }
        }
        catch(e){}
    }
}

function Close(){
    var shield= $("shield");
    var alertFram= $("alertFram");
    if(shield!=null) {
        document.body.removeChild(shield);
    }
    if(alertFram!=null) {
        document.body.removeChild(alertFram);
    } 
    document.body.onselectstart = function(){return true};
    document.body.oncontextmenu = function(){return true};
}