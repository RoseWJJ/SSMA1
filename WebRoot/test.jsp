<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>Query</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
		<script type="text/javascript">
		//无刷新调用 http://localhost:8080/springmvc/showFood3获取到数据 通过dom方式添加到table中
				//ajax（异步）+json
				//同步会发生假死
				//兼容所有的浏览器来创建对象；
				//用来接收数据  回调函数
				/*
					存有XMLHttpRequest的状态，从0到4
					0 请求未初始化（没有调用send）方法
					1 服务器链接已建立（socket已连接）方法
					2 请求已处理（已经在执行action 方法，未执行完）
					3请求已完成，切响应已就绪（已经响应  并且能够获取到最终的数据）
					status   200 成功
				 */
			function sendAjax(url, param, method, returnFunction) {
				var xmlhttp;
				//兼容所有的浏览器来创建对象；
				if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
					xmlhttp = new XMLHttpRequest();
				} else {// code for IE6, IE5
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
			
				//用来接收数据  回调函数
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						return returnFunction(xmlhttp.responseText);
					}
				}
				if (method == "GET" || method == "get") {
					xmlhttp.open("GET", url + "?" + param, true);
					xmlhttp.send();
				} else {
					xmlhttp.open("POST", url, true);
					xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded;charset=UTF-8");
					xmlhttp.send(param);
				}
			}
			function query() {
				
				var foodname = document.getElementsByName("foodname")[0].value;
				sendAjax("${pageContext.request.contextPath}/queryFood","foodname="+foodname,"GET",function(responseText){
				var table = document.getElementById("mytable");
				//返回的是字符串的json
				var resultJson = responseText;
				//将字符串转成对象；
				var resultObj = JSON.parse(resultJson);
				//获取表格对象；
				var dataTr = document.getElementsByName("dataTr");
				var xlength = dataTr.length;
				for ( var i = 0; i < xlength; i++) {
					table.removeChild(dataTr[0]);
				}
			
				for ( var i = 0; i < resultObj.length; i++) {
					var obj = resultObj[i];
					var tr = document.createElement("tr");
					tr.setAttribute("name", "dataTr");
					var td1 = document.createElement("td");
					var td2 = document.createElement("td");
					var td3 = document.createElement("td");
					var td4 = document.createElement("td");
			
					td1.innerText = obj.foodname;
					td2.innerText = obj.price;
					//创建按钮
					var ib = document.createElement("button");
					ib.innerText = "x";
					//将当前对象绑定到按钮上不然永远取到最后一个值
					ib.foodObj = obj;
					ib.myTr = tr;
					ib.addEventListener("click", function() {
						var enentSrc = event.srcElement;
						
						table.removeChild(enentSrc.myTr);
						sendAjax("${pageContext.request.contextPath}/deleteFood/"+ib.foodObj.foodid,"_method=delete","POST",function(responseText){
							if(responseText==1){
								alert("删除成功");
							}else{
								alert("删除失败");
							}
						});
					});
					td3.appendChild(ib);
					var ib1 = document.createElement("button");
					ib1.innerText = "u";
					ib1.foodObj=obj;
				  	ib1.addEventListener("click",function(){
				       var eventSrc=event.srcElement;
				       document.getElementById('updateDiv').style.display='block';
				       document.getElementsByName("uFoodName")[0].value=eventSrc.foodObj.foodname;
				       document.getElementsByName("uFoodPrice")[0].value=eventSrc.foodObj.price;
				       document.getElementsByName("uFoodId")[0].value=eventSrc.foodObj.foodid;
				       
				   })
					
					td4.appendChild(ib1);
					tr.appendChild(td1);
					tr.appendChild(td2);
					tr.appendChild(td3);
					tr.appendChild(td4);
					table.appendChild(tr);
				}
			})
		}
		function saveFood() {
			var foodname = document.getElementsByName("myfoodname")[0].value;
			var price = document.getElementsByName("price")[0].value;
			
			sendAjax("${pageContext.request.contextPath}/saveFood/","foodname="+foodname+"&price="+price,"POST",function(responseText){
			         if(responseText==1){ 
			            document.getElementById('addDiv').style.display='none';
			            query();
			            alert("新增成功");
			            
			         }else{
			            alert("新增失败");
			         }
			});
		}		
		function updateFood(){
			   var foodname=document.getElementsByName("uFoodName")[0].value;
			   var price=document.getElementsByName("uFoodPrice")[0].value;
			   var foodid=  document.getElementsByName("uFoodId")[0].value;
			sendAjax("${pageContext.request.contextPath}/updateFood/"+foodid,"_method=put&foodname="+foodname+"&price="+price,"POST",function(responseText){
			         if(responseText==1){ 
			            document.getElementById('updateDiv').style.display='none';
			            query();
			            alert("修改成功");
			            
			         }else{
			            alert("修改失败");
			         }
			});
			}
</script>
	</head>

	<body>

		<input type='text' name="foodname" />
		<input type="submit" value="查询" onclick="query()" /><input type="button" value="增加" onclick="document.getElementById('addDiv').style.display='block'" />
		<table id="mytable">
			<tr>
				<th>
					菜名
				</th>
				<th>
					价格
				</th>
				<th>
					操作
				</th>
			</tr>
		</table>

	</body>
	<div id="addDiv" style="display:none;position:absolute;left:40%;top:40%;z-index:100;border:1px solid black;width:250px;height:200px" >
			菜名:<input type='text' name="myfoodname"/><br/>
			价格:<input type='text' name="price"/><br/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="添加" onclick="saveFood()" />
			&nbsp;&nbsp;&nbsp;<input type="button"  value="关闭" onclick="document.getElementById('addDiv').style.display='none';" />
	</div>
	<div id="updateDiv" style="display:none;position: absolute;left:40%;top:40%;z-index: 100;border:1px solid black; width:250px;height:100px ">
	 <input type="hidden" name="uFoodId" >
	 菜品名：<input type="text" name="uFoodName"><br/>
	 价&nbsp;&nbsp;&nbsp;格：<input type="text" name="uFoodPrice"><br/>
	 <input type="button" value="修改" onclick="updateFood()">&nbsp;&nbsp;&nbsp;<input type="button" value="关闭" onclick="document.getElementById('updateDiv').style.display='none';" ><br/>
	</div>
</html>
