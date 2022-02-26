<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
	

<script>
function redirecionar(site){
	window.location.href=site;
}

window.onload = function () {
	refresh();
	setInterval(refresh, 2000);
}

function refresh(){
	getFinalizou();
}

function finalizar(){
	var assunto_0 = document.getElementById("pergunta_0").innerHTML + ': ' + document.getElementById("assunto_0").value;
	var assunto_1 = document.getElementById("pergunta_1").innerHTML + ': ' + document.getElementById("assunto_1").value;
	var assunto_2 = document.getElementById("pergunta_2").innerHTML + ': ' + document.getElementById("assunto_2").value;
	var assunto_3 = document.getElementById("pergunta_3").innerHTML + ': ' + document.getElementById("assunto_3").value;
	var assunto_4 = document.getElementById("pergunta_4").innerHTML + ': ' + document.getElementById("assunto_4").value;
	var assunto_5 = document.getElementById("pergunta_5").innerHTML + ': ' + document.getElementById("assunto_5").value;
	var assunto_6 = document.getElementById("pergunta_6").innerHTML + ': ' + document.getElementById("assunto_6").value;
	var assunto_7 = document.getElementById("pergunta_7").innerHTML + ': ' + document.getElementById("assunto_7").value;
	var assunto_8 = document.getElementById("pergunta_8").innerHTML + ': ' + document.getElementById("assunto_8").value;
	var assunto_9 = document.getElementById("pergunta_9").innerHTML + ': ' + document.getElementById("assunto_9").value;
	var conteudo = '';
	conteudo = assunto_0 + "_" + assunto_1 + "_" + assunto_2 + "_" + assunto_3 + "_" + assunto_4 + "_" + assunto_5 + "_";
	conteudo = conteudo + assunto_6 + "_" + assunto_7 + "_" + assunto_8 + "_" + assunto_9;
	getFinalizar(conteudo);
	
}

// AJAX ------------------------------------------------------------------------------------
// Requisicao no AJAX ----------------------------------------------------------------------
var request = null;
  function createRequest() {
    try {
      request = new XMLHttpRequest();
    } catch (trymicrosoft) {
      try {
        request = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (othermicrosoft) {
        try {
          request = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (failed) {
          request = null;
        }
      }
    }
    if (request == null)
      alert("Erro na requisição.");
  }
//Requisicao no AJAX ------------------------------------------------------------------------------------



// Finalizar ------------------------------------------------------------------------------------
var finalizar_ajax = [];

var requisicoesFinalizar = 0;
function getFinalizar(conteudo) {
	if(requisicoesFinalizar == 0){
		createRequest();
		console.log(''+conteudo)
		var url = "/finalizar_{"+conteudo+"}";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaFinalizar;
		request.send(null);
		requisicoesFinalizar = 0;
	}
}
function atualizaPaginaFinalizar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Finalizar(respostaDoServidor);
	}
}
function json_Finalizar(json) {
	if(json != null && json != ''){
			var result = JSON.parse(json);
			var objeto = {};
			for (var i = 0, emp; i < result.labels.length; i++) {
				emp = result.labels[i];
				objeto[ emp.descricao ] = emp;
				try { 
					var lista_ajax = objeto[emp.descricao].participantes;
					finalizar_ajax = [];
					finalizar_ajax = lista_ajax;
				} catch(err){
					console.log('Erro: '+err);
				}
			}
			
			document.getElementById("bt_finalizar").className = 'col-12 text-left';
			document.getElementById("bt_finalizar").innerHTML = '<br>Aguarde...<br>';
			document.getElementById("bt_finalizar").innerHTML = '<br>';
			for (var i = 0, emp; i < finalizar_ajax.length; i++) {
				document.getElementById("bt_finalizar").innerHTML = document.getElementById("bt_finalizar").innerHTML = 'Aguarde...';
			}
			
			redirecionar('/contagem');
			requisicoesFinalizar = 0;
	}
		
	
}
//Finalizar ------------------------------------------------------------------------------------





// Questiona se finalizou ------------------------------------------------------------------------------------
var finalizou_ajax = [];

var requisicoesFinalizou = 0;
function getFinalizou() {
	if(requisicoesFinalizou == 0){
		createRequest();
		var url = "/finalizou";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaFinalizou;
		request.send(null);
		requisicoesFinalizou = 1;
	}
}
function atualizaPaginaFinalizou() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Finalizou(respostaDoServidor);
	}
}
function json_Finalizou(json) {
	if(json == 'true'){
		finalizar();
	}
	requisicoesFinalizou = 0;
}

//Questiona se finalizou ------------------------------------------------------------------------------------




</script>

<div class="row">
	<div class="col-12 text-center">
		<h4>Letra aleatória escolhida: <span class="h1" style="color:red">${ letraAleatoria }</span> </h4>
	</div>
	<c:forEach items="${assuntos }" var="a" varStatus="loop">
		<div class="col-12 col-sm-6	 col-md-6 col-lg-6	col-xl-6 col-xxl-6  text-left">
			<label id="pergunta_${loop.index }" >${a }:</label>
			<input class="form-control" type="text" id="assunto_${loop.index }" name="assunto_${loop.index }" value="" />
		</div>
	</c:forEach>
	
	<div class="col-12 text-center">
		<span id="jogadores" class="h1" ></span>
	</div>
	
	<div class="col-12 text-center" id="bt_finalizar">
		<br>
		<span onclick="finalizar()" class="btn btn-primary" >Finalizar</span> 
	</div>
</div>
            





















<jsp:include page="includes/footer.jsp" />