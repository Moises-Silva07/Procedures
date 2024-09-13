use biblioteca;

CREATE TABLE LIVROS(
	ID_LIVRO INT PRIMARY KEY AUTO_INCREMENT,
    NOME_LIVRO VARCHAR(100),
    DATA_PUBLICACAO DATE
);

CREATE TABLE AUTOR(
	ID_AUTOR INT PRIMARY KEY AUTO_INCREMENT,
    NOME_AUTOR VARCHAR(100),
    ID_LIVRO INT,
    CONSTRAINT FK_LIVROS FOREIGN KEY(ID_LIVRO) REFERENCES LIVROS(ID_LIVRO)
);

CREATE TABLE LIVROS_AUTOR(
	ID_AUTOR INTEGER,
    ID_LIVRO INTEGER,
    PRIMARY KEY (ID_AUTOR, ID_LIVRO),
    CONSTRAINT FK_AUTOR FOREIGN KEY(ID_AUTOR) REFERENCES AUTOR(ID_AUTOR),
    CONSTRAINT FK_LIVRO FOREIGN KEY(ID_LIVRO) REFERENCES LIVROS(ID_LIVRO)
);

CREATE TABLE USUARIOS(
	ID_USUARIO INT PRIMARY KEY auto_increment,
    NOME_USUARIO VARCHAR(50),
    DATA_NASCIMENTO DATE,
    CPF VARCHAR(12),
    TELEFONE VARCHAR(20)
);

CREATE TABLE LOCACAO (
	ID_LOCACAO INT PRIMARY KEY AUTO_INCREMENT,
    DATA_LOCACAO DATE,
    ID_USUARIO INT,
    ID_LIVRO INT,
    
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO),
    FOREIGN KEY (ID_LIVRO) REFERENCES LIVROS(ID_LIVRO)
);

CREATE TABLE DEVOLUCOES(
	ID_DEVOLUCAO INT AUTO_INCREMENT PRIMARY KEY,
    ID_LIVRO INT,
    ID_USUARIO INT,
    DATA_DEVOLUCAO DATE,
    DATA_DEVOLUCAO_ESPERADA DATE,
    FOREIGN KEY (ID_LIVRO) REFERENCES LIVROS(ID_LIVRO),
    FOREIGN KEY(ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO)
);

CREATE TABLE MULTAS (
	ID_MULTAS INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT,
    VALOR_MULTAS DECIMAL (10,2),
    DATA_MULTA DATE,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO)
);



CREATE TABLE Livros_Excluidos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Livro INT NOT NULL,
    Titulo VARCHAR(255) NOT NULL,
    Autor VARCHAR(255),
    DataExclusao DATETIME DEFAULT CURRENT_TIMESTAMP
);




-- INSERT

INSERT INTO LIVROS (NOME_LIVRO, DATA_PUBLICACAO) VALUES
('Dom Quixote', '1605-01-16'),
('Orgulho e Preconceito', '1813-01-28'),
('1984', '1949-06-08'),
('O Hobbit', '1937-09-21'),
('A Revolução dos Bichos', '1945-08-17');

INSERT INTO AUTOR (NOME_AUTOR, ID_LIVRO) VALUES
('Miguel de Cervantes', 1),
('Jane Austen', 2),
('George Orwell', 3),
('J.R.R. Tolkien', 4),
('George Orwell', 5);

INSERT INTO LIVROS_AUTOR (ID_AUTOR, ID_LIVRO) VALUES
(1, 1),  -- Miguel de Cervantes escreveu Dom Quixote
(2, 2),  -- Jane Austen escreveu Orgulho e Preconceito
(3, 3),  -- George Orwell escreveu 1984
(4, 4),  -- J.R.R. Tolkien escreveu O Hobbit
(5, 5);  -- George Orwell escreveu A Revolução dos Bichos

INSERT INTO USUARIOS (NOME_USUARIO, DATA_NASCIMENTO, CPF, TELEFONE) VALUES
('João Silva', '1980-05-15', '12345678901', '(11) 98765-4321'),
('Maria Oliveira', '1992-07-22', '10987654321', '(21) 97654-3210'),
('Pedro Santos', '1985-12-01', '32109876543', '(31) 96543-2109'),
('Ana Costa', '1990-03-10', '45678912345', '(41) 95432-1098'),
('Lucas Almeida', '1995-09-29', '56789012345', '(51) 94321-0987');

INSERT INTO LOCACAO (DATA_LOCACAO, ID_USUARIO, ID_LIVRO) VALUES
('2024-09-01', 1, 1),
('2024-09-02', 2, 2),
('2024-09-03', 3, 3),
('2024-09-04', 4, 4),
('2024-09-05', 5, 5);


INSERT INTO DEVOLUCOES (ID_LIVRO, ID_USUARIO, DATA_DEVOLUCAO, DATA_DEVOLUCAO_ESPERADA) VALUES
(1, 1, '2024-09-10', '2024-09-09'),
(2, 2, '2024-09-12', '2024-09-11'),
(3, 3, '2024-09-14', '2024-09-13'),
(4, 4, '2024-09-16', '2024-09-15'),
(5, 5, '2024-09-18', '2024-09-17');

INSERT INTO MULTAS (ID_USUARIO, VALOR_MULTAS, DATA_MULTA) VALUES
(1, 2.00, '2024-09-10'),
(2, 4.00, '2024-09-12'),
(3, 6.00, '2024-09-14'),
(4, 8.00, '2024-09-16'),
(5, 10.00, '2024-09-18');


-- FUNCTIONS
SELECT COUNT(ID_LIVRO) AS TOTAL_LIVROS FROM LIVROS ;
SELECT AVG(VALOR_MULTAS) AS MEDIA_MULTA FROM MULTAS;
SELECT MAX(VALOR_MULTAS) AS MAIOR_VALOR_MULTA FROM MULTAS;
SELECT MIN(VALOR_MULTAS) AS MENOR_VALOR_MULTA FROM MULTAS;
SELECT SUM(VALOR_MULTAS) AS VALOR_TOTAL_MULTAS FROM MULTAS;
SELECT DATEDIFF(DATA_DEVOLUCAO_ESPERADA , DATA_DEVOLUCAO) AS DIFERENCA_DIAS_DEVOLUCAO FROM DEVOLUCOES;
SELECT COUNT(NOME_USUARIO) AS QUANTIDADE_USUARIO FROM USUARIOS;
SELECT COUNT(ID_AUTOR) AS QUANTIDADE_AUTORES FROM AUTOR;
SELECT COUNT(ID_LOCACAO) AS QUANTIDADE_LOCACOES FROM LOCACAO;
SELECT COUNT(DATA_DEVOLUCAO) FROM DEVOLUCOES;



-- PROCEDURES

DELIMITER //
-- CALCULA QUANTOS USUARIOS TEM COM NASCIMENTO EM TAL ANO
CREATE PROCEDURE CalcularUsuariosPorAno(IN ano INT)
BEGIN
    SELECT COUNT(ID_USUARIO) AS TotalUsuarios 
    FROM USUARIOS 
    WHERE YEAR(DATA_NASCIMENTO) = ano;
END //

call CalcularUsuariosPorAno(2000)


DELIMITER // 
-- calcular o valor da multa do usuario
CREATE PROCEDURE CalcularTotalMultasUsuario(IN id_usuario INT)
BEGIN
    
    SELECT 
        U.NOME_USUARIO, 
        -- Seleciona o nome do usuário da tabela "USUARIOS".
        SUM(M.VALOR_MULTAS) AS TotalMultas 
    FROM 
        MULTAS M 
    JOIN 
        USUARIOS U ON M.ID_USUARIO = U.ID_USUARIO 
        -- Realiza um JOIN entre as tabelas "multas" e "usuario"
    WHERE 
        M.ID_USUARIO = id_usuario 
    -- selecionando apenas o parametro usado no começo (id_usuario).
    GROUP BY 
        U.NOME_USUARIO; 
        -- agrupando.
END //

call CalcularTotalMultasUsuario(4);


-- nesse aqui pedi ajuda para o gpt por que não estava conseguindo vincular locacao e devolucao :(
DELIMITER //
-- verificar disponibilidade dos livros
CREATE PROCEDURE ListarLivrosDisponibilidade()
BEGIN
    SELECT 
        L.ID_LIVRO, 
        L.NOME_LIVRO,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM LOCACAO L2
                     -- Faz uma junção à esquerda com a tabela DEVOLUCOES
                LEFT JOIN DEVOLUCOES D ON L2.ID_LIVRO = D.ID_LIVRO AND L2.ID_USUARIO = D.ID_USUARIO
                  -- Filtra locações para o livro específico
                WHERE L2.ID_LIVRO = L.ID_LIVRO
                -- se devolucao for vazia esta alugado
                AND D.ID_DEVOLUCAO IS NULL
            ) THEN 'Alugado'
            ELSE 'Disponível'
        END AS Status
    FROM LIVROS L;
END //

DELIMITER ;
-- testei antes
call ListarLivrosDisponibilidade(); 
-- testei depois
INSERT INTO LOCACAO (DATA_LOCACAO, ID_USUARIO, ID_LIVRO) VALUES
('2024-12-25', 3, 4 );



DELIMITER //
-- conta quantos livros foram excluidos
CREATE PROCEDURE ContarLivrosExcluidos()
BEGIN
    -- contagem de registros na tabela Livros_Excluidos
    SELECT COUNT(*) AS Total_Livros_Excluidos
    FROM Livros_Excluidos;
END //
DELIMITER ;

CALL ContarLivrosExcluidos()

DELIMITER //
-- automatizando a exclusao de um livro
CREATE PROCEDURE ExcluirLivroCompleto(IN id_livro INT)
BEGIN
    -- 1. Exclui o livro na tabela LIVROS_AUTOR
    DELETE FROM LIVROS_AUTOR
    WHERE ID_LIVRO = id_livro;

    -- 2. Exclui o livro na tabela LOCACAO
    DELETE FROM LOCACAO
    WHERE ID_LIVRO = id_livro;

    -- 3. Exclui o livro na tabela DEVOLUCOES
    DELETE FROM DEVOLUCOES
    WHERE ID_LIVRO = id_livro;
    
     -- 4. excluir livro do AUTOR
    DELETE FROM AUTOR
    WHERE ID_LIVRO = id_livro;

    -- 4. Exclui o livro da tabela LIVROS
    DELETE FROM LIVROS
    WHERE ID_LIVRO = id_livro;
END //
DELIMITER ;

-- testando pra ver se exclui
INSERT INTO LIVROS (NOME_LIVRO, DATA_PUBLICACAO)
VALUES ('O Senhor dos Anéi', '1954-07-29');
CALL ExcluirLivroCompleto(6);


