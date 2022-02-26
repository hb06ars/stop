package brandaoti.sistema.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import brandaoti.sistema.model.Usuario;

public interface UsuarioDao extends JpaRepository<Usuario, Integer> {
	@Query(" select sum(pr.pontuacaoAdicionada) from Usuario u inner join u.resposta pr where u.id like (:id)")
	Integer calcular(@Param("id") Integer id);
	
	
}
