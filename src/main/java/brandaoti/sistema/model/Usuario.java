package brandaoti.sistema.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;

@Entity
public class Usuario {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id; //Esse número é o ID automático gerado.
	
	@Column
	private Boolean finalizou = false;
	
	@Column
	private String nome;
	
	@ManyToMany
	private List<PerguntasRespostas> resposta;
	
	@Column
	private Integer pontuacao = 0;
	
	@Column
	private Integer pontuacaoGeral = 0;
	
	@Column
	private Integer vitorias = 0;
	
	@Column
	private Boolean aceitou = false;

	
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public Integer getPontuacao() {
		return pontuacao;
	}

	public void setPontuacao(Integer pontuacao) {
		this.pontuacao = pontuacao;
	}

	public Integer getVitorias() {
		return vitorias;
	}

	public void setVitorias(Integer vitorias) {
		this.vitorias = vitorias;
	}

	

	public List<PerguntasRespostas> getResposta() {
		return resposta;
	}

	public void setResposta(List<PerguntasRespostas> resposta) {
		this.resposta = resposta;
	}

	public Boolean getFinalizou() {
		return finalizou;
	}

	public void setFinalizou(Boolean finalizou) {
		this.finalizou = finalizou;
	}

	public Boolean getAceitou() {
		return aceitou;
	}

	public void setAceitou(Boolean aceitou) {
		this.aceitou = aceitou;
	}

	public Integer getPontuacaoGeral() {
		return pontuacaoGeral;
	}

	public void setPontuacaoGeral(Integer pontuacaoGeral) {
		this.pontuacaoGeral = pontuacaoGeral;
	}

	
	
	
	
}
