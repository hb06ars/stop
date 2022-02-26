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
	getQuantidadeInicio();
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


// Participantes ------------------------------------------------------------------------------------
var participantes_ajax = [];

var requisicoesQuantidadeInicio = 0;
function getQuantidadeInicio() {
	if(requisicoesQuantidadeInicio == 0){
		createRequest();
		var url = "/quantidadeInicio";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaQuantidadeInicio;
		request.send(null);
		requisicoesQuantidadeInicio = 1;
	}
}
function atualizaPaginaQuantidadeInicio() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_QuantidadeInicio(respostaDoServidor);
	}
}
function json_QuantidadeInicio(json) {
	console.log(json)
	if(json != 'jogando'){
		var result = JSON.parse(json);
		var objeto = {};
		for (var i = 0, emp; i < result.labels.length; i++) {
			emp = result.labels[i];
			objeto[ emp.descricao ] = emp;
			try { 
				var lista_ajax = objeto[emp.descricao].participantes;
				participantes_ajax = [];
				participantes_ajax = lista_ajax;
			} catch(err){
				console.log('Erro: '+err);
			}
		}
		
		document.getElementById("jogadores").innerHTML = '';
		for(var i = 0; i < lista_ajax.length; i++ ){
			document.getElementById("jogadores").innerHTML = document.getElementById("jogadores").innerHTML + lista_ajax[i].nome + '<br>';
		}
		
		if(participantes_ajax.length > 1){
			document.getElementById("inicio").innerHTML = '<span onclick="redirecionar(\'jogar\')" class="btn btn-primary" >Iniciar</span>';
		} else{
			document.getElementById("inicio").innerHTML = '<span class="fa fa-spinner fa-spin fa-2x"></span>';
		}	
	} else{
		document.getElementById("inicio").innerHTML = 'Iniciando o jogo...<br><br><span  class="fa fa-spinner fa-spin fa-2x"></span>';
		redirecionar('\jogando');
	}
	
	requisicoesQuantidadeInicio = 0;
}
//Add ------------------------------------------------------------------------------------




</script>

<div class="row">
	<div class="col-12 text-center">
		<h2>${ usuarioSessao.nome }, aguarde ter ao menos dois participantes para iniciarmos o jogo.</h2>
		<br>
		<span id="inicio">
			<span  class='fa fa-spinner fa-spin fa-2x'></span>
		</span>
	</div>
	<div class="col-12 text-center">
	<br>
	<h3>Jogadores prontos até agora:</h3>
	<span id="jogadores"></span>
	</div>
</div>
            





















<jsp:include page="includes/footer.jsp" />