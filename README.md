# Peer-To-Peer Freechains Simulation
A proposta deste script é simular o funcionamento de um fórum público durante 3 meses de uso com vários usuários e nós.

Foram divididos em 4 tipos de usuários:
- Pioneer
- Active
- Troll
- Newbie

As mensagens que cada um pode enviar, com exceção do Troll que só pode enviar mensagens do tipo bad, foram dividas em 3 tipos:
- VIRAL
- NORMAL
- BAD

**Pioneiro** - Ele é o responsável por criar o fórum e com a chave pública dele é feito o join no fórum, e também é considerado o que mais posta no fórum, a cada 2 dias.

**Active** - Ele é o mais ativo no fórum tirando o pioneiro, ele posta a cada 3 dias.

**Troll** - Ele é só manda mensagens consideradas ruins, e só está no sistema para causar spam. Ele posta a cada 5 dias.

**Newbie** - Ele é um usuário que não frequenta muito o sistema, então ele só posta a cada 7 dias.

O script de simulação conta com 90 iterações (para simular 3 meses, aproximadamente cada mês com 30 iterações). Em cada iteração é feito a atualização dos timestamps de todos os nós, para manter a data igual em todos dias.

Foi utilizado um número randomico de 0 a 2 para dizer qual mensagem o usuário irá enviar (com exceção do Troll que só irá enviar mensagens BAD):
- 0 para VIRAL
- 1 para NORMAL
- 2 para BAD.

As mensagens do tipo VIRAL irão receber likes dos outros usuários, e as BAD irão receber dislike, contudo há algumas regras para dar like e dislike.

Regras de Like:
- Pioneiro só irá dar like se ele tiver com mais de 5 reps.
- Active só irá dar like se ele tiver com mais de 10 reps.
- Newbie só irá dar like se ele tiver com mais de 15 reps.
- Troll não da like

Regras de Dislike:
- Pioneiro só irá dar dislike se ele tiver com mais de 10 reps.
- Active só irá dar dislike se ele tiver com mais de 14 reps.
- Newbie só irá dar dislike se ele tiver com mais de 18 reps.
- Troll não da dislike

Para rodar o script só é necessário clonar o repositório, entrar na pasta, dar permissão ao script `chmod +755 ./simul.sh` e rodar `./simul.sh`