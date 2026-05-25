# Atividade-Ohata
Atividade persistência de dados e gerenciamento de volumes em containers

# Infraestrutura de Persistência com Docker

## 1. Introdução

Este projeto tem como objetivo demonstrar técnicas de persistência de dados em ambientes containerizados utilizando Docker.

Durante a atividade foram aplicados conceitos relacionados a:

- containers efêmeros;
- persistência de dados;
- Docker Volumes;
- Bind Mounts;
- backup e restauração;
- compartilhamento de volumes;
- automação de backups.

A atividade foi desenvolvida utilizando Ubuntu Linux e Docker, simulando práticas reais utilizadas em ambientes DevOps e infraestrutura moderna.

---

## 2. Ambiente Utilizado

### Sistema Operacional
- Ubuntu Server/Desktop

### Ferramentas
- Docker Engine
- Docker Compose
- Git
- GitHub

### Verificações Realizadas

```bash
docker --version
docker compose version
git --version
docker run hello-world
```

---

## 3. Estrutura do Projeto

```text
infra-persistencia-docker/
│
├── README.md
├── scripts/
├── screenshots/
├── backups/
├── docker/
└── observacoes/
```

---

# 4. Desenvolvimento da Atividade

# Cenário 1 — Persistência de Dados com MySQL e Named Volume

## Objetivo
Validar persistência de dados após remoção de containers.

## Etapas Executadas

### Criação do volume

```bash
docker volume create mysql-prod-data
```

### Criação do container MySQL

```bash
docker run -d \
--name mysql-container \
-e MYSQL_ROOT_PASSWORD=335412 \
-e MYSQL_DATABASE=meubanco \
-v mysql-prod-data:/var/lib/mysql \
-p 3306:3306 \
mysql:8
```

### Criação da tabela

```sql
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);
```

### Inserção de registros

```sql
INSERT INTO usuarios (nome, email)
VALUES
('Ana', 'ana@email.com'),
('Carlos', 'carlos@email.com'),
('Julia', 'julia@email.com');
```

## Resultado

Os dados permaneceram armazenados mesmo após a remoção e recriação do container utilizando o mesmo volume Docker.

---

# Cenário 2 — Backup e Restauração de Volume

## Objetivo
Compreender técnicas de backup e recuperação de dados.

## Etapas Executadas

- Backup lógico com mysqldump;
- Backup físico do volume com tar.gz;
- Remoção do volume;
- Restauração dos dados;
- Validação da recuperação.

## Comandos Utilizados

```bash
docker exec mysql-container2 \
mysqldump -u root -p335412 meubanco \
> backups/cenario2/meubanco.sql
```

```bash
docker run --rm \
-v mysql_data:/volume \
-v $(pwd)/backups/cenario2:/backup \
ubuntu \
tar czf /backup/mysql_volume_backup.tar.gz -C /volume .
```

## Resultado

Foi possível restaurar integralmente os dados após simulação de perda do volume.

---

# Cenário 3 — Bind Mount

## Objetivo
Validar compartilhamento entre diretório local e container.

## Resultado

Os arquivos criados no host Ubuntu foram acessados dentro do container em tempo real utilizando Bind Mount.

---

# Cenário 4 — Compartilhamento Entre Containers

## Objetivo
Compreender compartilhamento de armazenamento entre containers.

## Resultado

Múltiplos containers acessaram simultaneamente o mesmo volume Docker, validando compartilhamento em tempo real.

---

# Cenário 5 — Automação de Backup

## Objetivo
Automatizar processos de backup utilizando Bash Script.

## Script Utilizado

```bash
#!/bin/bash

DATA=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p backups/automaticos

docker exec mysql-restored \
mysqldump -u root -p335412 meubanco \
> backups/automaticos/meubanco_$DATA.sql
```

## Resultado

Os backups passaram a ser gerados automaticamente utilizando script Bash.

---

# 5. Evidências

As evidências da execução encontram-se na pasta:

```text
screenshots/
```

Separadas por cenário.

---

# 6. Problemas Encontrados

## Problemas enfrentados

- erro de permissão no Docker daemon;
- autenticação GitHub via token;
- dificuldades no push inicial do Git;
- caminhos incorretos durante geração de backups.

## Soluções aplicadas

- adição do usuário ao grupo docker;
- utilização de Personal Access Token;
- reorganização da estrutura do projeto;
- validação de diretórios com pwd e ls.

---

# 7. Conclusão

A atividade permitiu compreender na prática conceitos fundamentais de persistência de dados em ambientes containerizados.

Foi possível implementar volumes Docker, realizar backups, restaurar dados, compartilhar armazenamento entre containers e automatizar tarefas operacionais utilizando Bash.

Os cenários simulam situações reais utilizadas em ambientes DevOps, Cloud Computing e infraestrutura moderna.
