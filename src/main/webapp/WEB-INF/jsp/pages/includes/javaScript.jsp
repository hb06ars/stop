<script type="text/javascript">

function fullScreen(){
	if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) { 
		if (document.documentElement.requestFullscreen) {
			document.documentElement.requestFullscreen();
		} else if (document.documentElement.msRequestFullscreen) {
			document.documentElement.msRequestFullscreen();
		} else if (document.documentElement.mozRequestFullScreen) {
			document.documentElement.mozRequestFullScreen();
		} else if (document.documentElement.webkitRequestFullscreen) {
			document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
		}
	}
}



function iniciando(){
	var msg = '${mensagem}' + '';
	if (msg != ''){
		if('${tipoMensagem}' == 'erro'){
			mensagemErro('Erro','${mensagem}');
		} else{
			mensagem('Aten��o','${mensagem}');
		}
	}

    var data = new Date(),
        dia  = data.getDate().toString(),
        diaF = (dia.length == 1) ? '0'+dia : dia,
        mes  = (data.getMonth()+1).toString(), //+1 pois no getMonth Janeiro come�a com zero.
        mesF = (mes.length == 1) ? '0'+mes : mes,
        anoF = data.getFullYear(),
    	valor = diaF+"/"+mesF+"/"+anoF;
	    var semana = ["Domingo", "Segunda-Feira", "Ter�a-Feira", "Quarta-Feira", "Quinta-Feira", "Sexta-Feira", "S�bado"];
		var dataVal = valor;
		var arr = dataVal.split("/").reverse();
		var teste = new Date(arr[0], arr[1] - 1, arr[2]);
		var dia = teste.getDay();
	    valor = valor + " - " + semana[dia];
    	//document.getElementById("dataHoje").innerHTML = valor;
		
    	
}    	
    	
    	
</script>