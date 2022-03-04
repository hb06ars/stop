package brandaoti.sistema.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import brandaoti.sistema.dao.PerguntasRespostasDao;
import brandaoti.sistema.dao.UsuarioDao;
import brandaoti.sistema.model.ListaAssunto;
import brandaoti.sistema.model.PerguntasRespostas;
import brandaoti.sistema.model.Usuario;


@RestController
@RequestMapping("/")
@CrossOrigin("*")
public class SistemaController extends HttpServlet {

		@Autowired
		UsuarioDao usuarioDao;
		
		@Autowired
		PerguntasRespostasDao perguntasRespostasDao;
	
		private static final long serialVersionUID = 1L;
		private static Integer total = 0;
		private static Boolean jogando = false;
		private static List<Usuario> participantes = new ArrayList<Usuario>();
		
		private static String letraAleatoria = "-";
		private static List<String> assuntos = new ArrayList<String>();
		private static Boolean finalizou = false;
		private static Boolean todosAceitaram = false;
		
		public void limpar() {
			jogando = false;
			letraAleatoria = "-";
			assuntos.clear();
			assuntos = new ArrayList<String>();
			todosAceitaram = false;
			finalizou = false;
		}
		
		public void gerarLetra() {
			if(letraAleatoria.equals("-")) {
				String letra = "A";
				String[] valor = {"A", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
			    Integer randomNum = 0 + (int)(Math.random() * 26);
			    letra = valor[randomNum];
			    letraAleatoria = letra;
			}
		}
		
		public void gerarAssunto() {
			if(assuntos.size() == 0) {
				assuntos.clear();
				assuntos = new ArrayList<String>();
				String[] assunto = ListaAssunto.gerar();
			    String[] valor = {"","","","","","","","","",""};
				Set<String> set = new HashSet<>();
				while(set.size() < 10){
					Integer randomNum = 0 + (int)(Math.random() * (assunto.length-1));
					valor[0] = assunto[randomNum];
					set.add(assunto[randomNum]);
				}
				Object[] lis = set.toArray();
				for(int i = 0 ; i < 10 ; i++ ){
					assuntos.add(""+lis[i]);
				}
			}
		}
		
		
		@RequestMapping(value = {"/zerar"}, produces = "text/plain;charset=UTF-8", method = RequestMethod.GET) // Pagina de Vendas
		public void zerar(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", required = false, defaultValue = "Henrique Brandão") String nome) throws SQLException, ServletException, IOException { //Funcao e alguns valores que recebe...
			HttpSession session = request.getSession();
			total = 0;
			jogando = false;
			participantes.clear();
			letraAleatoria = "-";
			assuntos.clear();
			finalizou = false;
			todosAceitaram = false;
			
			
			if(perguntasRespostasDao.findAll().size() > 0) {
				for(PerguntasRespostas pr : perguntasRespostasDao.findAll()) {
					perguntasRespostasDao.delete(pr);
				}
			}
			if(usuarioDao.findAll().size() > 0) {
				for(Usuario usr : usuarioDao.findAll()) {
					usuarioDao.delete(usr);
				}
			}
			session.invalidate();
			response.sendRedirect("/index");
		}
		
		
		
		@RequestMapping(value = {"/","/index"}, produces = "text/plain;charset=UTF-8", method = RequestMethod.GET) // Pagina de Vendas
		public void login(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", required = false, defaultValue = "Henrique Brandão") String nome) throws SQLException, ServletException, IOException { //Funcao e alguns valores que recebe...
			//Caso não haja registros
			gerarAssunto();
			gerarLetra();
			
			HttpSession session = request.getSession();
			if(session.getAttribute("usuarioSessao") != null) {
				response.sendRedirect("/home");
			} else {
				request.setAttribute("total", total);
				request.getRequestDispatcher("/WEB-INF/jsp/index.jsp").forward(request, response); //retorna a variavel
			}
		}
		
		@RequestMapping(value = {"/","/index"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.POST}) // Pagina de Vendas
		public void index_post(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", defaultValue = "") String nome) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "index";
			Boolean valido = true;
			if(total < 5) {
				for(Usuario part : participantes) {
					if(part.getNome().equals(nome)) {
						valido = false;
					}
				}
				if(valido) {
					Usuario u = new Usuario();
					u.setNome(nome);
					usuarioDao.save(u);
					session.setAttribute("usuarioSessao",u);
					participantes.add(u);
					total = participantes.size();
					if(!jogando) {
						response.sendRedirect("/home");
					} else {
						response.sendRedirect("/jogando");
					}
				} else {
					request.setAttribute("total", total);
					request.setAttribute("mensagem", "Já existe outra pessoa com este nome.");
					request.getRequestDispatcher("/WEB-INF/jsp/"+link+".jsp").forward(request, response); //retorna a variavel
				}
			} else {
				request.setAttribute("total", total);
				request.setAttribute("mensagem", "O limite é de 5 participantes.");
				request.getRequestDispatcher("/WEB-INF/jsp/"+link+".jsp").forward(request, response); //retorna a variavel
			}
			
		}
		
		@RequestMapping(value = "/deslogar", method = {RequestMethod.GET}) // Link que irÃ¡ acessar...
		public void deslogar(HttpServletRequest request, HttpServletResponse response ) throws IOException { //Funcao e alguns valores que recebe...
			HttpSession session = request.getSession();
			participantes.remove(session.getAttribute("usuarioSessao"));
			total = participantes.size();
			session.invalidate();
			response.sendRedirect("/");
		}
		
		
		@RequestMapping(value = {"/home"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void home(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", defaultValue = "") String usuarioVal, @RequestParam(value = "senhaVal", defaultValue = "") String senhaVal) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				link = "pages/home";
			}
			request.getRequestDispatcher("/WEB-INF/jsp/"+link+".jsp").forward(request, response); //retorna a variavel
		}

		@RequestMapping(value = {"/jogar"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void jogar(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", defaultValue = "") String usuarioVal, @RequestParam(value = "senhaVal", defaultValue = "") String senhaVal) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			
			jogando = false;
			
			System.out.println("LETRA: "+letraAleatoria);
			System.out.println("Assunto: "+assuntos.size());
			
			if(session.getAttribute("usuarioSessao") != null) {
				for(Usuario u : participantes) {
					System.out.println("-----------------------------------------");
					System.out.println("User: " + u.getNome());
					u.setResposta(null);
					u.setAceitou(false);
					u.setFinalizou(false);
					usuarioDao.save(u);
				}
				if(perguntasRespostasDao.findAll().size() > 0) {
					for(PerguntasRespostas pre : perguntasRespostasDao.findAll()){
						perguntasRespostasDao.delete(pre);
					}
				}
				
				
				if(!jogando && participantes.size() > 1) {
					link = "/jogando";
					jogando = true;
				} else {
					jogando = false;
				}
			}
			response.sendRedirect(link);
		}
		
		
		@RequestMapping(value = {"/proximo"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void proximo(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			if(session.getAttribute("usuarioSessao") != null) {
				letraAleatoria = "-";
				assuntos.clear();
				limpar();
				response.sendRedirect("/index");
			} else {
				response.sendRedirect("/deslogar");
			}
		}
		
		@RequestMapping(value = {"/jogando"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void jogando(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", defaultValue = "") String usuarioVal, @RequestParam(value = "senhaVal", defaultValue = "") String senhaVal) throws SQLException, ServletException, IOException {
			System.out.println("jogand");
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				if(jogando && participantes.size() > 1) {
					link = "pages/jogando";
				} else {
					jogando = false;
				}
			}
			request.setAttribute("assuntos", assuntos);
			request.setAttribute("letraAleatoria", letraAleatoria);
			request.getRequestDispatcher("/WEB-INF/jsp/"+link+".jsp").forward(request, response); //retorna a variavel
		}
		
		
		
		@RequestMapping(value = "/quantidadeInicio", produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET}) // Pagina de Vendas
		public String quantidadeInicio(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
			String retorno = "";
			if(!jogando) {
				JSONObject jsonObj = new JSONObject();
				try {
					JSONObject objeto = new JSONObject();
					objeto = new JSONObject();
					objeto.put("participantes", participantes);
					jsonObj.append("labels", objeto);
				} catch (Exception e) {
					e.printStackTrace();
				}
				retorno = ""+jsonObj;
			} else {
				retorno = "jogando";
			}
			return retorno;
		}
		
		
		
		@RequestMapping(value = "/finalizar_{conteudo}", produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET}) // Pagina de Vendas
		public String finalizar(HttpServletRequest request, HttpServletResponse response, @PathVariable("conteudo") String conteudo) throws SQLException, ServletException, IOException {
			System.out.println("Finalizando.");
			HttpSession session = request.getSession();
			String retorno = "";
			conteudo = conteudo.replace("{", "").replace("}", "");
			conteudo = conteudo.replace("::", ":");
			conteudo = conteudo.replace("_", ",");
			finalizou = true;
			Usuario u = (Usuario) session.getAttribute("usuarioSessao");
			if(!u.getFinalizou()) {
				u.setFinalizou(true);
				usuarioDao.save(u);
				String[] conteudoArray = conteudo.split(",");
				List<PerguntasRespostas> respostas = new ArrayList<PerguntasRespostas>();
				for(String s : conteudoArray) {
					PerguntasRespostas pr = new PerguntasRespostas();
					String[] pergRes = s.split(":");
					try { pr.setPergunta(pergRes[0]); } catch(Exception e) { pr.setPergunta(""); }
					try { pr.setResposta(pergRes[1]); } catch(Exception e) { pr.setResposta(""); }
					perguntasRespostasDao.save(pr);
					respostas.add(pr);
				}
				u.setResposta(respostas);
				u.setFinalizou(true);
				usuarioDao.save(u);
			}
			JSONObject jsonObj = new JSONObject();
			try {
				JSONObject objeto = new JSONObject();
				objeto = new JSONObject();
				objeto.put("participantes", participantes);
				jsonObj.append("labels", objeto);
			} catch (Exception e) {
				e.printStackTrace();
			}
			retorno = ""+jsonObj;
			System.out.println("Retorno: "+retorno);
			return retorno;
		}
		
		
		@RequestMapping(value = "/finalizou", produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET}) // Pagina de Vendas
		public String finalizou(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
			return ""+finalizou;
		}
		
		
		@RequestMapping(value = {"/contagemPontos"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public String contagemPontos(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
				String retorno = "";
				JSONObject jsonObj = new JSONObject();
				try {
					JSONObject objeto = new JSONObject();
					objeto = new JSONObject();
					objeto.put("participantes", participantes);
					objeto.put("todosAceitaram", todosAceitaram);
					jsonObj.append("labels", objeto);
				} catch (Exception e) {
					e.printStackTrace();
				}
				retorno = ""+jsonObj;
				System.out.println("Contagem: "+retorno);
				return retorno;
		}
		
		@RequestMapping(value = {"/contagem"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void contagem(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "nome", defaultValue = "") String usuarioVal, @RequestParam(value = "senhaVal", defaultValue = "") String senhaVal) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				if(jogando && participantes.size() > 1) {
					link = "pages/contagem";
					request.setAttribute("participantes", participantes);
					request.setAttribute("usuarioSessao", u);
				} else {
					jogando = false;
				}
			}
			
			request.getRequestDispatcher("/WEB-INF/jsp/"+link+".jsp").forward(request, response); //retorna a variavel
		}
		
		
		
		@RequestMapping(value = {"/aprovar_{id}"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void aprovar(HttpServletRequest request, HttpServletResponse response, @PathVariable("id") String id) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				System.out.println("ID: "+id);
				id = id.replace("{", "").replace("}", "");
				Integer valor = Integer.parseInt(id);
				for(PerguntasRespostas r : u.getResposta()) {
					if(r.getId() == valor) {
						r.setCalculado(true);
						r.setPontuacaoAdicionada(10);
						perguntasRespostasDao.save(r);
					}
				}
				Integer pontuacaoTotal = 0;
				pontuacaoTotal = usuarioDao.calcular(u.getId());
				u.setPontuacao(pontuacaoTotal);
				usuarioDao.save(u);
			}
		}
		
		
		@RequestMapping(value = {"/reprovar_{id}"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void reprovar(HttpServletRequest request, HttpServletResponse response, @PathVariable("id") String id) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				System.out.println("ID: "+id);
				id = id.replace("{", "").replace("}", "");
				Integer valor = Integer.parseInt(id);
				for(PerguntasRespostas r : u.getResposta()) {
					if(r.getId() == valor) {
						r.setCalculado(true);
						r.setPontuacaoAdicionada(0);
						perguntasRespostasDao.save(r);
					}
				}
				Integer pontuacaoTotal = 0;
				pontuacaoTotal = usuarioDao.calcular(u.getId());
				u.setPontuacao(pontuacaoTotal);
				usuarioDao.save(u);
			}
		}
		
		
		
		@RequestMapping(value = {"/empatar_{id}"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void empatar(HttpServletRequest request, HttpServletResponse response, @PathVariable("id") String id) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			String link = "pages/deslogar";
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				System.out.println("ID: "+id);
				id = id.replace("{", "").replace("}", "");
				Integer valor = Integer.parseInt(id);
				for(PerguntasRespostas r : u.getResposta()) {
					if(r.getId() == valor) {
						r.setPontuacaoAdicionada(5);
						perguntasRespostasDao.save(r);
					}
				}
				Integer pontuacaoTotal = 0;
				pontuacaoTotal = usuarioDao.calcular(u.getId());
				u.setPontuacao(pontuacaoTotal);
				usuarioDao.save(u);
			}
		}
		
		
		
		@RequestMapping(value = {"/aceitar"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void aceitar(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				u.setAceitou(true);
				u.setPontuacaoGeral(u.getPontuacaoGeral() + u.getPontuacao());
				u.setPontuacao(0);
				usuarioDao.save(u);
				
				Boolean todos = true;
				for(Usuario us : usuarioDao.findAll()) {
					if(!us.getAceitou()) {
						todos = false;
					}
				}
				todosAceitaram = todos;
			}
		}
		
		@RequestMapping(value = {"/recusar"}, produces = "text/plain;charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST}) // Pagina de Vendas
		public void recusar(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
			HttpSession session = request.getSession();
			if(session.getAttribute("usuarioSessao") != null) {
				Usuario u = (Usuario)session.getAttribute("usuarioSessao");
				u.setAceitou(false);
				usuarioDao.save(u);
				todosAceitaram = false;
			}
		}
		
		
		
		
}
	
	
	




