# HSGraphAgent: grandes modelos de linguagem guiados por grafo de conhecimento para classificação no Sistema Harmonizado

**Autores:** Qiang Xia, Zijian Zhang, Ao Wang, Wenhan Wang, Xiangyu Wang e Jian Li.  
**Publicação:** anais da ACL, 2026.

## Problema e proposta

A classificação no Sistema Harmonizado (HS) exige interpretar descrições de produtos e respeitar uma hierarquia e regras de exclusão. Um código semanticamente plausível pode ser inadequado segundo notas tarifárias. LLMs que geram códigos diretamente podem inventar códigos, ignorar restrições ou produzir trajetórias inconsistentes. A recuperação de documentos relevantes (RAG) oferece contexto, mas não impõe, por si só, as regras ao processo decisório.

O HSGraphAgent combina um LLM com um grafo explícito e trata a classificação como percurso hierárquico sujeito a restrições. Além do código, produz uma trajetória de raciocínio rastreável.

## Construção do grafo e inferência

O grafo utiliza a nomenclatura HS 2022 e notas oficiais, complementadas pela pauta tarifária chinesa. Contém relações de pertencimento hierárquico e relações regulatórias que associam condições a exclusões ou redirecionamentos. Uma extração assistida por LLM converte textos tarifários em elementos estruturados. Resumos dos nós são preparados previamente para apresentar seus critérios de inclusão e exclusão durante a inferência.

A estrutura reportada inclui 22 seções, 97 capítulos, 1.231 posições e 5.615 subposições. Na etapa Select, o agente escolhe entre os filhos válidos do nó atual, considerando a descrição, o caminho percorrido e os resumos. Na etapa Redirect, verifica se regras exigem abandonar a escolha e seguir uma alternativa. Quando necessário, pode retornar a um nível anterior. O processo se repete até atingir a profundidade desejada ou não existir continuação compatível.

O exemplo de pescado processado ilustra a proposta: a semelhança com peixes pode favorecer o capítulo 03, mas uma regra de exclusão pode exigir o capítulo 16. O redirecionamento procura corrigir esse tipo de decisão durante a classificação.

## Avaliação e resultados

A avaliação ocorre sem exemplos de treinamento específicos para a tarefa (zero-shot). Um conjunto contém 1.231 descrições e cobre todas as posições de quatro dígitos consideradas; outro reúne 450 descrições para classificação em seis dígitos. Os rótulos são verificados manualmente. O estudo compara geração direta, RAG com nomes, RAG com janelas de texto e HSGraphAgent usando DeepSeek-V3.2, Kimi-K2, GPT-OSS-120B e Qwen2.5-32B.

Em HS6, o HSGraphAgent melhora o desempenho frente à melhor alternativa RAG em todos os modelos. As acurácias passam de 72,2% para 90,2% com DeepSeek, de 78,9% para 90,9% com Kimi, de 69,6% para 78,9% com GPT-OSS e de 67,6% para 77,8% com Qwen. No conjunto de quatro dígitos, o DeepSeek alcança 96,9% em HS4. Entretanto, o método não supera RAG em todas as métricas e modelos, sobretudo nos níveis mais amplos.

As ablações reforçam a contribuição dos componentes: com DeepSeek, remover o redirecionamento reduz a acurácia HS6 de 90,2% para 66,9%; remover os resumos globais a reduz para 69,8%.

O ganho envolve maior custo. Com DeepSeek, a latência HS6 aumenta de 8,68 segundos no melhor RAG para 24,97 segundos no HSGraphAgent. Assim, a classificação detalhada mais precisa exige mais etapas de inferência e consumo de recursos.

## Conclusões e limitações

O trabalho indica que impor estrutura e regras durante a inferência melhora a classificação detalhada, especialmente quando categorias semelhantes diferem por critérios regulatórios. A trajetória explícita também favorece a auditoria das decisões.

A eficácia depende da completude das regras extraídas e da capacidade do LLM de interpretar suas condições. O sistema utiliza anotações regulatórias chinesas; a aplicação a outras jurisdições exige substituir ou ampliar essa camada. Os testes não demonstram cobertura integral das extensões nacionais além de seis dígitos. Os autores apontam otimização de eficiência e estratégias adaptativas de raciocínio como caminhos futuros.
