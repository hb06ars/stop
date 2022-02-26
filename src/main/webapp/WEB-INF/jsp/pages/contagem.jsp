<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
	

<script>
function aceitar(){
	document.getElementById("botaoFinal").innerHTML = '<span onclick="recusar()" class="btn btn-danger" id="titulo">Rejeitar</span>';
	document.getElementById("msg").innerHTML = '<br>Aguarde...';
	getAceitar()
}
function recusar(){
	document.getElementById("botaoFinal").innerHTML = '<span onclick="aceitar()" class="btn btn-primary" id="titulo">Aceitar</span>';
	document.getElementById("msg").innerHTML = '';
	getRecusar()
}



function aprovar(id){
	getAprovar(id)
}
function reprovar(id){
	getReprovar(id)
}
function empatar(id){
	getEmpatar(id)
}

function redirecionar(site){
	window.location.href=site;
}

window.onload = function () {
	refresh();
	setInterval(refresh, 2000);
}

function refresh(){
	getAtualizar();
	verificarAceites();
}


function verificarAceites(){
	if(todosAceitaram){
		redirecionar('/proximo')	
	}
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
var todosAceitaram = false;

var requisicoesQuantidadeInicio = 0;
function getAtualizar() {
	if(requisicoesQuantidadeInicio == 0){
		createRequest();
		var url = "/contagemPontos";
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
		try {
				var result = JSON.parse(json);
				var objeto = {};
				if(result.labels.length > 0){
					for (var i = 0, emp; i < result.labels.length; i++) {
						emp = result.labels[i];
						objeto[ emp.descricao ] = emp;
						try { 
							var lista_ajax = objeto[emp.descricao].participantes;
							todosAceitaram = objeto[emp.descricao].todosAceitaram;
							participantes_ajax = [];
							participantes_ajax = lista_ajax;
						} catch(err){
							console.log('Erro: '+err);
						}
					}	
				}
		
		document.getElementById("jogadoresPontuacao_1").innerHTML = '';
		document.getElementById("jogadoresPontuacao_2").innerHTML = '';
		document.getElementById("jogadoresPontuacao_3").innerHTML = '';
		document.getElementById("jogadoresPontuacao_4").innerHTML = '';
		if(lista_ajax != null && lista_ajax != ''){
			if( lista_ajax.length > 0){
				for(var i = 0; i < lista_ajax.length; i++ ){
					document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<br><br><b>' 
					+ lista_ajax[i].nome + '</b><br>';
					
					if(lista_ajax[i].resposta != null){
						for(var j = 0; j < lista_ajax[i].resposta.length; j++ ){
							if(lista_ajax[i].nome == '${usuarioSessao.nome }'){
								document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span onclick="reprovar('+lista_ajax[i].resposta[j].id+')" class="fa fa-minus-circle" style=color:red></span> &nbsp ';
								
								if( lista_ajax[i].resposta[j].resposta != ' ' && lista_ajax[i].resposta[j].resposta != ''){
									document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span onclick="aprovar('+lista_ajax[i].resposta[j].id+')" class="fa fa-plus-circle" style=color:green></span> &nbsp ';
									document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span onclick="empatar('+lista_ajax[i].resposta[j].id+')" class="fa fa-plus-circle" style=color:orange></span> &nbsp ';
								}
							}
							document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + lista_ajax[i].resposta[j].pergunta +': ';
							if( lista_ajax[i].resposta[j].pontuacaoAdicionada == 10 ){
								document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span style="color:green"> ' + lista_ajax[i].resposta[j].resposta +'</span><br>';	
							}
							else if( lista_ajax[i].resposta[j].pontuacaoAdicionada == 5 ){
								document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span style="color:#FF8000"> ' + lista_ajax[i].resposta[j].resposta +'</span><br>';	
							} else{
								document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span style="color:black" > ' + lista_ajax[i].resposta[j].resposta +'</span><br>';
							}
							
							
						}
						
						document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span><b> Total: ' + lista_ajax[i].pontuacao +'</b></span><br>';
						document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML = document.getElementById("jogadoresPontuacao_"+(i+1)).innerHTML + '<span><b> GERAL: ' + lista_ajax[i].pontuacaoGeral +'</b></span><br>';
							
					}
				}	
			} else{
				console.log('Lista vazia: lista_ajax')
			}
		} else{
			console.log('Lista nula: lista_ajax')
		}
		} catch(err){
			console.log('Erro: '+err);
		}
	requisicoesQuantidadeInicio = 0;
}
//Add ------------------------------------------------------------------------------------





// Aprovar ------------------------------------------------------------------------------------

function getAprovar(id) {
		createRequest();
		var url = "/aprovar_{"+id+"}";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaAprovar;
		request.send(null);
}
function atualizaPaginaAprovar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Aprovar(respostaDoServidor);
	}
}
function json_Aprovar(json) {
	console.log('ok')
}
//Aprovar ------------------------------------------------------------------------------------




// Reprovar ------------------------------------------------------------------------------------

function getReprovar(id) {
		createRequest();
		var url = "/reprovar_{"+id+"}";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaReprovar;
		request.send(null);
}
function atualizaPaginaReprovar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Reprovar(respostaDoServidor);
	}
}
function json_Reprovar(json) {
	console.log('ok 2')
}
//Reprovar ------------------------------------------------------------------------------------




// Empatar ------------------------------------------------------------------------------------
var empatar_ajax = [];


function getEmpatar(id) {
		createRequest();
		var url = "/empatar_{"+id+"}";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaEmpatar;
		request.send(null);
}
function atualizaPaginaEmpatar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Empatar(respostaDoServidor);
	}
}
function json_Empatar(json) {
	console.log('ok')
}
//Empatar ------------------------------------------------------------------------------------




// Aceitar ------------------------------------------------------------------------------------
var aceitar_ajax = [];
function getAceitar() {
		createRequest();
		var url = "/aceitar";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaAceitar;
		request.send(null);
}
function atualizaPaginaAceitar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Aceitar(respostaDoServidor);
	}
}
function json_Aceitar(json) {
	console.log('ok')
}
//Aceitar ------------------------------------------------------------------------------------


// Recusar ------------------------------------------------------------------------------------
var recusar_ajax = [];
function getRecusar() {
		createRequest();
		var url = "/recusar";
		request.open("GET", url, true);
		request.onreadystatechange = atualizaPaginaRecusar;
		request.send(null);
}
function atualizaPaginaRecusar() {
	if (request.readyState == 4) {
		var respostaDoServidor = request.responseText;
		json_Recusar(respostaDoServidor);
	}
}
function json_Recusar(json) {
	console.log('ok')
}
//Recusar ------------------------------------------------------------------------------------



</script>

<div class="row">
	<div class="col-12 text-center">
		<h2>${ usuarioSessao.nome }, seu tempo acabou.</h2>
		<br><h4>Pontuação:</h4>
	</div>
</div>

<div class="row" style="overflow:auto; min-width:800px">

	<div id="jogadoresPontuacao_1" class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xxl-4">
		<div class="text-center">
		</div>
	</div>
	<div id="jogadoresPontuacao_2" class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xxl-4">
		<div class="text-center">
		</div>
	</div>
	<div id="jogadoresPontuacao_3" class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xxl-4">
		<div class="text-center">
		</div>
	</div>
	<div id="jogadoresPontuacao_4" class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xxl-4">
		<div class="text-center">
		</div>
	</div>
	
	
	
</div>
            
<div class="row">
	<div class="col-12 text-center">
		<br>
		<span id="botaoFinal">
			<span onclick="aceitar()" class="btn btn-primary" id="titulo">Aceitar</span>
		</span>
		<span id="msg"></span>
	</div>
</div>



















<jsp:include page="includes/footer.jsp" />