<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- /chartjs/src/main/webapp/db/barline.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>막대/선 그래프로 게시글 작성자의 건수 출력하기</title>
<script type="text/javascript" 
src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
</head>
<body>
<sql:setDataSource var="conn" driver="org.mariadb.jdbc.Driver"
  url="jdbc:mariadb://localhost:3306/gdudb"
  user="gdu" password="1234" />
<sql:query var="rs" dataSource="${conn}">
SELECT writer,COUNT(*) cnt FROM board
GROUP BY writer
HAVING COUNT(*) > 1
ORDER BY 2 desc
</sql:query>
<div style="width:75%"><canvas id="canvas"></canvas></div>
<script type="text/javascript">
 let randomColorFactor = function(){
	 return Math.round(Math.random()*255) //0~255 사이의 임의의 수
 }
//rgb(255,255,255) => 흰색. #FFFFFF
//rgba(255,255,255,1) => 흰색. #FFFFFF1 => a: 투명도. 1:불투명,0:투명  
 let randomColor = function(opacity) { //rgba(10,255,5,0.3) 형태
	 return "rgba("+ randomColorFactor() + ","
			 + randomColorFactor() + ","
			 + randomColorFactor() + ","
			 +(opacity || '.3') +")"
 }
 let chartData = {
	labels:  //작성자이름
	[<c:forEach items="${rs.rows}" var="m">"${m.writer}",</c:forEach>],
	datasets: [
		{type: 'line',
		 borderWidth: 2,
		 borderColor:[<c:forEach items="${rs.rows}" var="m">
				randomColor(1),</c:forEach>],
		 label: '건수',
		 fill: false,
		 data: [<c:forEach items="${rs.rows}" var="m">
		             "${m.cnt}",</c:forEach>],
		},
		{type: 'bar',
		 label: '건수',
		 backgroundColor: [<c:forEach items="${rs.rows}" var="m">
				     randomColor(),</c:forEach>],
		 data: [<c:forEach items="${rs.rows}" var="m">
		        "${m.cnt}",</c:forEach>],
		 borderWidth: 2
		}]
		};
window.onload = function() {
	let ctx = document.getElementById('canvas').getContext('2d');
	new Chart(ctx, {
		type: 'bar',	data: chartData,
		options: {			
			responsive: true,
			title: {display: true,   text: '게시판 등록 건수'},
			legend : {display : false },
			scales: {
				xAxes: [{ display : true,
					      scaleLabel:  {
							  display : true,
							  labelString : "게시물 작성자"},
						      stacked : true}],			
				yAxes: [{ display : true,
						  scaleLabel:  {
							  display : true,
							  labelString : "게시물 작성 건수"
						  },
						  stacked : true
					     }]
			 }	}	})   }   
</script></body></html>