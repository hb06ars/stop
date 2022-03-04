<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
       	<meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Sistema para Senhas">
        <meta name="author" content="Henrique Brandão">
        <meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <link rel="shortcut icon" href="/assets/images/avatar-1.jpg">
        <title>STOP!</title>
        
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
	    <link rel="stylesheet" href="/css/style3.css">
	    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">
	    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
	        
        <link rel="shortcut icon" href="/assets/images/avatar-1.jpg">
		<script src="assets/outros/jqueryLoader.min.js"></script>
        
        <script>
			//Loading ---------------------------------------
			jQuery(function($){
				$(".loader").fadeOut("slow"); //retire o delay quando for copiar!
			});
			// Loading ---------------------------------------
		</script>
		
    </head>
    
    <style>
    .loader {
			position: fixed;
			left: 0px;
			top: 0px;
			width: 100%;
			height: 100%;
			z-index: 9999;
			background-color: white;
		}
	</style>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
	<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
	
	<jsp:include page="mensagens.jsp" />    
    <jsp:include page="javaScript.jsp" />
    
    
    <body class="fixed-left" onload="iniciando()" >
    
    	<div id="loader" class="loader">
				<div class="col-sm-12 text-center" style="top:30%; color: #302010">
					<div class="col-sm-12 text-center">
						<img src="/assets/images/avatar-1.webp" onerror="this.src='/assets/images/avatar-1.jpg" style="max-width:100px" />
						<br>
						Aguarde...
						<br>
					</div>
					<div class="col-sm-12 text-center">
						<span class='fa fa-spinner fa-spin fa-2x'></span>
					</div>
				</div>
		</div>
		

    <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <div id="dismiss">
                <i class="fas fa-arrow-left"></i>
            </div>

            <div class="sidebar-header">
                <h3>${usuarioSessao.nome }</h3>
            </div>

            <ul class="list-unstyled components">
                <li>
                    <a>${usuarioSessao.pontuacaoGeral } pontos.</a>
                </li>
                <li>
                    <a href="/zerar">Deslogar todos</a>
                </li>
                <li>
                    <a href="/deslogar">Sair</a>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">

            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">

                    <button type="button" id="sidebarCollapse" class="btn btn-info">
                        <i class="fas fa-align-left"></i>
                        <span>Menu</span>
                    </button>
                </div>
            </nav>
