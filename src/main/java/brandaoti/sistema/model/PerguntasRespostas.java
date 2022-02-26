package brandaoti.sistema.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class PerguntasRespostas {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id; //Esse número é o ID automático gerado.
	
	@Column
	private Boolean calculado = false;
	
	@Column
	private String pergunta;
	
	@Column
	private String resposta;
	
	@Column
	private Integer pontuacaoAdicionada = 0;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Boolean getCalculado() {
		return calculado;
	}

	public void setCalculado(Boolean calculado) {
		this.calculado = calculado;
	}

	public String getPergunta() {
		return pergunta;
	}

	public void setPergunta(String pergunta) {
		this.pergunta = pergunta;
	}

	public String getResposta() {
		return resposta;
	}

	public Integer getPontuacaoAdicionada() {
		return pontuacaoAdicionada;
	}

	public void setPontuacaoAdicionada(Integer pontuacaoAdicionada) {
		this.pontuacaoAdicionada = pontuacaoAdicionada;
	}

	public void setResposta(String resposta) {
		this.resposta = resposta;
	}

	
	
	
}
