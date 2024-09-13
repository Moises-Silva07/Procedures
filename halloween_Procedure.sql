create database halloween;

use halloween;


CREATE TABLE USUARIOS (
    ID_USUARIO INTEGER PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(20),
    email VARCHAR(50),
    IDADE INTEGER
    
);

-- Defina o delimitador para evitar conflitos com ponto e vírgula
DELIMITER $$

CREATE PROCEDURE InsereUsuariosAleatorios()
BEGIN
    DECLARE i INT DEFAULT 0;
    
    -- Loop para inserir 10.000 registros
    WHILE i < 10000 DO
        -- Gere dados aleatórios para os campos
        SET @nome := CONCAT('Usuario', i);
        SET @email := CONCAT('usuario', i, '@exemplo.com');
        SET @idade := FLOOR(RAND() * 80) + 18;  -- Gera uma idade entre 18 e 97 anos
        
        -- Insira o novo registro na tabela de usuários
        INSERT INTO usuarios (nome, email, idade) VALUES (@nome, @email, @idade);
        -- Incrementa o contador
        SET i = i + 1;
    END WHILE;
END$$ 

-- Restaure o delimitador padrão
DELIMITER ;


drop procedure if exists InsereUsuariosAleatorios;
CALL InsereUsuariosAleatorios();

select * from usuarios;
