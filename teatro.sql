CREATE DATABASE TEATRO;

USE TEATRO;


-- criando a tabela
CREATE TABLE PECAS_TEATRO(
ID_PECA INT PRIMARY KEY AUTO_INCREMENT,
NOME_PECA VARCHAR(100),
DESCRICAO VARCHAR(200),
DURACAO INT(40),
DISPONIBILIDADE DATETIME

);
-- inserindo dados
INSERT INTO PECAS_TEATRO (NOME_PECA, DESCRICAO, DURACAO, DISPONIBILIDADE) VALUES
('O Casamento do Pequeno Burguês', 'Peça de teatro clássica em três atos.', 120, '2024-09-20 20:00:00'),
('A Tempestade', 'Uma peça mágica de William Shakespeare.', 150, '2024-10-05 19:30:00'),
('O Guarani', 'Tragédia brasileira com um romance épico.', 140, '2024-11-01 21:00:00'),
('Hamlet', 'Tragédia de Shakespeare sobre vingança e loucura.', 180, '2024-09-15 20:00:00'),
('O Auto da Compadecida', 'Comédia brasileira com elementos de folclore.', 110, '2024-10-10 19:00:00'),
('A Ceia dos Cardeais', 'Drama psicológico com reviravoltas intrigantes.', 130, '2024-11-20 20:30:00'),
('O Jardim das Cerejeiras', 'Peça russa sobre mudanças e perda.', 160, '2024-12-01 19:00:00'),
('O Mambembe', 'Comédia popular brasileira sobre teatro.', 100, '2024-09-25 18:00:00'),
('A Caverna', 'Peça moderna explorando o tema da auto-descoberta.', 140, '2024-10-15 20:00:00'),
('O Homem de La Mancha', 'Musical baseado na história de Dom Quixote.', 155, '2024-11-10 19:00:00'),
('Macbeth', 'Tragédia de Shakespeare sobre ambição e culpa.', 170, '2024-12-10 20:00:00'),
('A Casa de Bernarda Alba', 'Drama sobre a opressão feminina em uma família.', 120, '2024-09-30 19:30:00'),
('O Pagador de Promessas', 'Peça brasileira que lida com religião e fé.', 135, '2024-10-25 18:30:00'),
('O Doente Imaginário', 'Comédia de Molière sobre hipocondria.', 115, '2024-11-15 20:00:00'),
('A Menina de Ouro', 'Peça que explora temas de infância e esperança.', 125, '2024-12-05 19:00:00');



DELIMITER //
-- criando a funcao
CREATE FUNCTION CALCULAR_MEDIA_DURACAO(A_ID_PECA INT(100))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
-- declarando variavel que vai armazenar o select
    DECLARE MEDIA_DURACAO DECIMAL(5,2);

    -- calculo da media de duração
    SELECT AVG(DURACAO)
    INTO media_duracao
    FROM PECAS_TEATRO
    WHERE ID_PECA = A_ID_PECA;

   
    RETURN MEDIA_DURACAO;
END //
DELIMITER ;

select CALCULAR_MEDIA_DURACAO(1);
select CALCULAR_MEDIA_DURACAO('5');


-- criando a procedure PROFESSOR NÃO CONSEGUI ADICIONAR A FUNÇÃO DE MEDIA QUE EU CRIEI E NEM CONSEGUI CRIAR A DISPONIBILIDADE, POREM ESSA PROCEDURE ADICIONA OS DAODS :(
DELIMITER //

CREATE PROCEDURE AGENDAR_PECA(
    IN a_nome_peca VARCHAR(100),
    IN a_descricao VARCHAR(200),
    IN a_duracao INT,
    IN a_disponibilidade DATETIME
)
BEGIN
    -- Declarar variável para armazenar a média de duração
    DECLARE v_media_duracao DECIMAL(5,2);

    -- Inserir nova peça na tabela PECAS_TEATRO
    INSERT INTO PECAS_TEATRO (NOME_PECA, DESCRICAO, DURACAO, DISPONIBILIDADE)
    VALUES (a_nome_peca, a_descricao, a_duracao, a_disponibilidade);

    -- tentando adicionar media 
    SELECT AVG(DURACAO) FROM PECAS_TEATRO;

    -- Exibir informações sobre a peça agendada e tentei colocar média de duração
    SELECT 
        'Peça agendada com sucesso!' AS Mensagem,
        a_nome_peca AS Nome_Peca,
        a_descricao AS Descricao,
        a_duracao AS Duracao,
        a_disponibilidade AS Disponibilidade,
        v_media_duracao AS Media_Duracao;
END //

DELIMITER ;

-- chamando a procedure, nao saiu do jeito que deveria :(
CALL AGENDAR_PECA(
    'O Homem Que Não Sabia Andar',
    'Peça de teatro clássica',
    120,
    '2025-09-20 19:00:00'
);
