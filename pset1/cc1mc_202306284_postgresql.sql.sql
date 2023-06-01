/* Verificar existencia do banco de dados uvv, se existir, excluir */
DROP database IF EXISTS uvv;

/* Verificar a existencia do schema lojas, se existir, excluir */
DROP SCHEMA IF EXISTS lojas;

/* Verificar se o usuária daniela existe, se existir, excluir */
DROP USER IF EXISTS daniela;

/* Verificar se a role existe, se existir, excluir */
DROP ROLE IF EXISTS daniela;

/* Criar usuário daniela e senha */
CREATE USER daniela WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD '131922';

/* Criar banco de dados uvv */
CREATE database uvv
WITH
owner= daniela
template= 'template0'
encoding= "UTF8"
lc_collate= 'pt_BR.UTF-8'
lc_ctype= 'pt_BR.UTF-8'
allow_connections= TRUE
;

/* Definir a variável PGPASSWORD como a senha do usuário daniela */
\setenv PGPASSWORD 131922
/* Permissão total ao usuário daniela para o banco de dados uvv */

GRANT ALL ON database uvv TO daniela;

/* Usar banco de dados uvv com usuário daniela */
\c uvv daniela;

/* Comentário do banco de dados uvv */
comment ON database uvv
IS 'banco de dados uvv';

/* Criar schema lojas */
CREATE SCHEMA lojas AUTHORIZATION daniela;

/* Comentário do schema lojas */
comment ON SCHEMA lojas 
IS 'schema lojas do banco de dados uvv';

/* Definir o Search Path */
SET SEARCH_path TO lojas, "$user", public;
ALTER USER daniela
SET search_path TO lojas, "$user", public;
ALTER SCHEMA lojas owner TO daniela;

/* Criar tabela produtos */
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2) CHECK(preco_unitario > 0),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

/* Comentário da tabela produtos */
COMMENT ON TABLE lojas.produtos IS 'tabela de produtos do banco de dados Lojas UVV';

/* Comentários das colunas da tabela produtos */
COMMENT ON COLUMN lojas.produtos.produto_id IS 'coluna com id de cada produto';
COMMENT ON COLUMN lojas.produtos.nome IS 'coluna com o nome de cada produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'coluna com preco unitario de cada produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'coluna com detalhes dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem IS 'coluna com imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'coluna com tipo de imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'coluna com arquivo de imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'coluna com os caracteres da imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'coluna com ultima atualizacao da imagem de cada produto';


/* Criar tabela lojas */
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);

/* Comentário da tabela lojas */
COMMENT ON TABLE lojas.lojas IS 'tabela lojas do banco de dados Lojas UVV';

/* Cometários das colunas da tabela lojas */
COMMENT ON COLUMN lojas.lojas.loja_id IS 'coluna com id de cada loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'coluna com o nome de cada loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'coluna com o endereco web de cada loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'coluna com o endereco fisico de cada loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'coluna com a latitude de cada loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'coluna com a longitude de cada loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'coluna com o logo de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'coluna com o tipo de logo de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'coluna com o arquivo do logo de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'coluna com os caracteres do logo de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'coluna com a ultima atualizacao do logo de cada loja';


/* Criar tabela estoques */
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL CHECK(quantidade > 0),
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

/* Comentário da tabela estoques */
COMMENT ON TABLE lojas.estoques IS 'tabela de estoques do banco de dados Lojas UVV';

/* Comentários das colunas da tabela estoques */
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'coluna com id dos estoques';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'coluna com id de cada loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'coluna com id de cada produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'coluna com a quantidade de estoques';

/* Criar tabela clientes */
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

/* Comentário da tabela clientes */
COMMENT ON TABLE lojas.clientes IS 'tabela clientes do banco de dados Lojas UVV';

/* Comentários das colunas da tabela clientes */
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'coluna com id de cada cliente';
COMMENT ON COLUMN lojas.clientes.email IS 'coluna com email de cada cliente';
COMMENT ON COLUMN lojas.clientes.nome IS 'coluna com o nome de cada cliente';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'coluna com o telefone1 de cada cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'coluna com o telefone2 de cada cliente';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'coluna com o telefone3 de cada cliente';

/* Criar tabela pedidos */
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT null CHECK(status in('CANCELADO','COMPLETO','ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO')),
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);

/* Comentário da tabela pedidos */
COMMENT ON TABLE lojas.pedidos IS 'tabela pedidos do banco de dados Lojas UVV';

/* Comentários das colunas da tabela pedidos */
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'coluna com id de cada pedido';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'coluna com a data e a hora de cada pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'coluna com id de cada cliente';
COMMENT ON COLUMN lojas.pedidos.status IS 'coluna com o status de cada pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'coluna com id de cada loja';

/* Criar tabela envios */
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT null CHECK(status in('CRIADO','ENVIADO','TRANSITO', 'ENTREGUE')),
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);

/* Comentário da tabela envios */
COMMENT ON TABLE lojas.envios IS 'tabela de envios do banco de dados Lojas UVV';

/* Comentários das colunas da tabela envios */
COMMENT ON COLUMN lojas.envios.envio_id IS 'coluna com o id dos envios dos produtos';
COMMENT ON COLUMN lojas.envios.loja_id IS 'coluna com id de cada loja';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'coluna com id de cada cliente';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'coluna com endereco de entrega de cada envio';
COMMENT ON COLUMN lojas.envios.status IS 'coluna com status dos envios';

/* Criar tabela pedidos_itens */
CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL CHECK(numero_da_linha > 0),
                preco_unitario NUMERIC(10,2) NOT NULL CHECK(preco_unitario > 0),
                quantidade NUMERIC(38) NOT NULL CHECK(quantidade > 0),
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_item_id PRIMARY KEY (pedido_id, produto_id)
);

/* Comentário da tabela pedidos_itens */
COMMENT ON TABLE lojas.pedidos_itens IS 'tabela de pedidos e itens do banco de dados Lojas UVV';

/* Comentários das colunas da tabela pedidos_itens */
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'coluna com id de cada pedido';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'coluna com id de cada produto';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'coluna com numero da linha dos pedidos linhas';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'coluna com preco unitario do pedidos itens';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'coluna com quantidade de pedidos itens';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'coluna com o id dos envios dos produtos';

/* Chaves estrangeiras */

/* Adicionar uma FK da tabela lojas.produtos na tabela lojas.estoques */
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar uma FK da tabela lojas.produtos na tabela lojas.estoques */
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar uma FK da tabela lojas.lojas na tabela lojas.pedidos */
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar uma FK da tabela lojas.lojas na tabela lojas.envios */
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar uma FK da tabela lojas.produtos na tabela lojas.estoques */
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar uma FK da tabela lojas.cliente na tabela lojas.envios */
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar FK da tabela lojas.clientes na tabela lojas.pedidos */
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar FK na tabela lojas.pedidos na tabela lojas.pedidos_itens */
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Adicionar FK na tabela lojas.envios na tabela lojas.pedidos_itens */
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.lojas
ADD CONSTRAINT endereco_web_fisico_preenchido
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);
