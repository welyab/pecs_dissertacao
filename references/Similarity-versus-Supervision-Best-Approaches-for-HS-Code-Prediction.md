# Similaridade versus supervisão: melhores abordagens para prever códigos do Sistema Harmonizado

**Autores:** Sédrick Stassin, Otmane Amel, Sidi Ahmed Mahmoudi e Xavier Siebert.  
**Publicação:** ESANN, 2023.

## Objetivo e contexto

O artigo compara duas estratégias para recomendar códigos do Sistema Harmonizado a partir de descrições textuais: busca por similaridade semântica e classificação por rede neural supervisionada. Investiga os níveis de seis, oito e dez dígitos. Os seis primeiros correspondem à estrutura internacional; os níveis adicionais analisados pertencem ao contexto europeu e nacional considerado no estudo.

A motivação é apoiar representantes aduaneiros diante do crescimento do comércio eletrônico e dos riscos decorrentes de classificações incorretas. Como descrições curtas podem ser compatíveis com mais de um código, os autores valorizam listas de alternativas para escolha do usuário.

## Dados e metodologia

A base e-Origin contém 95.903 declarações, com 967 códigos HS6, 1.181 HS8 e 1.196 HS10 distintos. O pré-processamento remove pontuação, caracteres especiais e números, além de corrigir erros ortográficos e palavras concatenadas.

Na abordagem por similaridade, modelos pré-treinados transformam descrições em vetores. Uma nova descrição é comparada com descrições históricas já validadas por operadores aduaneiros, e os registros mais próximos fornecem as recomendações. O método depende desse histórico rotulado, embora não exija treinamento supervisionado adicional do codificador para a tarefa.

São avaliados MPNet, MiniLM, Universal Sentence Encoder e variantes de RoBERTa e DistilBERT, com distâncias euclidiana, Manhattan, Chebyshev, Minkowski e similaridade de cosseno. A abordagem supervisionada utiliza os mesmos embeddings como entrada para uma camada de classificação. O treinamento ocorre por 40 épocas, com divisão de 80% para treinamento, 10% para validação e 10% para teste. Diferentes limiares mínimos de exemplos por classe restringem o número de classes previstas.

As métricas top-1, top-3 e top-5 medem se o código correto está, respectivamente, na primeira recomendação ou entre as três ou cinco alternativas apresentadas.

## Principais resultados

A busca semântica apresenta bom desempenho para listas de candidatos. Em HS6, MiniLM com distância euclidiana alcança 64,4% em top-1, 91,0% em top-3 e 96,1% em top-5. Em HS8, essa combinação chega a 62,0%, 88,9% e 95,2%. Para HS10, MPNet com similaridade de cosseno obtém 61,7% em top-1, 89,0% em top-3 e 94,8% em top-5, considerando 1.196 classes.

A diferença entre top-1 e as listas maiores evidencia a utilidade do método como recomendador: frequentemente, a resposta correta aparece entre as alternativas, mesmo quando não ocupa o primeiro lugar. A passagem de HS6 para HS10 provoca uma redução relativamente pequena no desempenho da similaridade.

O classificador supervisionado perde desempenho quando aumenta o universo de classes e diminui a quantidade mínima de exemplos. Em HS10, com pelo menos 600 exemplos por classe e apenas 13 classes, alcança 89,5% em top-1. Com mínimo de 50 exemplos e 209 classes, os valores caem para 33,6% em top-1, 35,3% em top-3 e 36,4% em top-5. Essas diferenças de cobertura precisam ser consideradas ao comparar as estratégias.

## Conclusões e limitações

No experimento, a recomendação por similaridade é mais eficaz e flexível para trabalhar com muitas classes. Novos registros e códigos podem ser incorporados ao histórico sem retreinar um classificador com uma saída fixa. Os autores destacam a dificuldade dos modelos supervisionados em reconhecer produtos fora das classes aprendidas.

A similaridade também depende da cobertura e da qualidade do histórico: produtos novos ou códigos sem exemplos adequados podem não receber boas recomendações. O desempenho top-5 não equivale à correção de uma decisão automática única, e os resultados pertencem à base estudada. O artigo propõe explorar dados multimodais em trabalhos futuros, preservando a finalidade de apoiar a decisão aduaneira por meio de alternativas relevantes.
