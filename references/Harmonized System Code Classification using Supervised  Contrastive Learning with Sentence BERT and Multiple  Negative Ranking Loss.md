# Classificação de códigos do Sistema Harmonizado com aprendizagem contrastiva supervisionada, Sentence BERT e MNR Loss

**Autores:** Angga Wahyu Anggoro, Padraig Corcoran, Dennis De Widt e Yuhua Li.

**Publicação:** Data Technologies and Applications, v. 59, n. 2, p. 279-301, 2025.

**DOI:** 10.1108/DTA-01-2024-0052.

**Versão consultada:** manuscrito dos autores disponibilizado pelo repositório ORCA, com 37 páginas internas, além da capa do repositório e da folha de identificação. As referências a seções, tabelas e figuras abaixo correspondem a essa versão.

## Objetivo

O trabalho propõe melhorar a representação textual de transações comerciais para prever códigos do Sistema Harmonizado (HS). A ideia central é ajustar o Sentence BERT (SBERT) por aprendizagem contrastiva supervisionada e utilizar os vetores resultantes em classificadores tradicionais. O método pretende apoiar comerciantes na escolha de códigos e autoridades na validação das declarações, diante da ambiguidade das descrições e do volume de operações a analisar.

As descrições aduaneiras combinam nomes de produtos, marcas, modelos, números de série, medidas e condições de uso. Frequentemente são fragmentadas, contêm abreviações e não seguem a estrutura de frases em linguagem natural. O desafio consiste em aprender quais informações aproximam mercadorias de uma mesma categoria e quais distinguem categorias semelhantes.

O estudo amplia um trabalho anterior dos autores sobre ajuste de DistilBERT para classificação de transações. Sua contribuição é separar a aprendizagem da representação e a decisão classificatória: primeiro, o encoder aprende a organizar as descrições em um espaço vetorial; depois, SVM ou Random Forest aprendem a atribuir os códigos a partir desses vetores. A hipótese é que uma representação especializada no domínio pode melhorar o desempenho mesmo com classificadores tradicionais.

## Dados e delimitação da tarefa

São utilizados dois conjuntos públicos de transações de importação, apresentados na seção 3.1 e na Tabela I:

| Conjunto | Origem | Ano | Transações | Classes |
| --- | --- | --- | ---: | ---: |
| Índia | Zauba | 2016 | 66.522 | 172 |
| Estados Unidos | Enigma, registros de importação do Automated Manifest System | 2018 | 58.003 | 112 |

O recorte contempla os capítulos 84 e 85, que incluem máquinas, aparelhos mecânicos e equipamentos elétricos. A descrição do produto constitui a entrada textual, e o código declarado constitui o rótulo de referência. As classes são desbalanceadas, com proporção média de aproximadamente 30:1 entre classes majoritárias e minoritárias, segundo os autores.

Os dois capítulos delimitam o universo de mercadorias; a tarefa envolve as 172 ou 112 classes existentes em cada base, e não apenas uma escolha entre os capítulos 84 e 85. O texto apresenta o padrão internacional de seis dígitos e a possibilidade de extensões nacionais, enquanto a Tabela II exemplifica códigos de oito dígitos. A versão consultada não explicita de forma suficientemente clara uma normalização única do comprimento dos rótulos para os dois conjuntos, o que limita comparações diretas com tarefas definidas estritamente como HS6 ou NCM.

Ambos os conjuntos contêm descrições em inglês, compatíveis com os encoders utilizados. Os experimentos são realizados por conjunto, sem uma avaliação de transferência em que o treinamento ocorra em um país e o teste em outro.

## Método proposto

### Construção dos pares supervisionados

Cada descrição usada como âncora é pareada com outra transação que possui o mesmo código, formando um par positivo. A seleção dos positivos é aleatória e sem reposição. São comparadas configurações com um e três positivos por âncora; neste último caso, aumenta-se o número de pares disponíveis para treinamento, expondo o modelo a diferentes descrições da mesma categoria.

A supervisão decorre dos códigos já presentes nas bases. Essa construção evita depender de operações de aumento artificial dos textos, como remoção, substituição ou reordenação de palavras, que podem alterar características técnicas relevantes. O objetivo é aprender a proximidade entre descrições distintas de produtos da mesma classe, preservando seu conteúdo original.

### Encoder e agregação dos tokens

O SBERT é organizado como uma rede siamesa, ou bi-encoder, com compartilhamento de pesos entre os ramos que processam a âncora e o positivo. Os autores utilizam BERT e DistilBERT pré-treinados, nas versões base e uncased, e montam a arquitetura de representação com esses componentes. Portanto, a construção de um SBERT personalizado não significa pré-treinar um transformer desde pesos aleatórios.

Após o encoder, uma camada de agregação transforma a sequência de vetores dos tokens em um embedding de 768 dimensões. O artigo compara três estratégias: média dos vetores, máximo por dimensão e representação do token especial `[CLS]`. O ajuste contrastivo modifica o encoder para que os embeddings expressem relações úteis à classificação de mercadorias.

### Multiple Negative Ranking Loss

A função Multiple Negative Ranking Loss (MNR) utiliza lotes de pares positivos. Para cada âncora, o positivo correspondente deve obter maior similaridade do que os positivos associados às outras âncoras do mesmo lote, que funcionam como negativos. Assim, um lote de `n` pares permite construir uma matriz de similaridades `n × n`, com os pares correspondentes na diagonal. A aprendizagem favorece a similaridade desses pares em relação às demais combinações.

O artigo compara similaridade de cosseno e produto escalar. Com cosseno, um fator de escala multiplica os escores antes do cálculo da perda, alterando a intensidade das diferenças entre as similaridades. São avaliadas escalas de 20 e 50. Também é testada a MNR simétrica, que considera a média das perdas nos dois sentidos: da âncora para o positivo e do positivo para a âncora.

A descrição metodológica e o pseudocódigo do Apêndice II ajudam a entender o uso dos negativos do próprio lote. Entretanto, o texto não detalha um mecanismo para impedir que duas transações da mesma classe, pertencentes a pares diferentes, sejam tratadas como negativas entre si. Esse é um ponto de atenção para reprodução da abordagem, e não um efeito medido nos experimentos.

### Classificação a partir dos embeddings

Após o ajuste do SBERT, cada descrição é codificada em um vetor de tamanho fixo, utilizado como entrada de SVM ou Random Forest. Os classificadores são empregados com configurações padrão, sem ajuste adicional de seus hiperparâmetros. A Figura 1 resume o fluxo: descrições pareadas, encoder compartilhado, agregação, ajuste contrastivo, geração de embeddings e classificação.

## Protocolo experimental

O artigo destina aleatoriamente 70% das transações de cada conjunto ao ajuste do SBERT. Os 30% restantes são reservados ao treinamento e à validação dos classificadores, com validação cruzada estratificada de cinco partições. Essa divisão deve ser distinguida de um protocolo convencional em que os 30% seriam exclusivamente um teste final: aqui, eles alimentam a etapa de avaliação dos classificadores por validação cruzada. A estratificação preserva as proporções das classes nas partições, sem eliminar o desbalanceamento das bases.

As métricas incluem kappa de Cohen, precisão, revocação e F1 nas agregações macro, micro e ponderada. A média macro dá o mesmo peso a cada classe; a micro agrega as decisões globalmente; e a ponderada considera o número de exemplos de cada classe. A discussão dos autores enfatiza o F1 ponderado, que também é o indicador numérico priorizado neste resumo.

Os experimentos utilizam Python, PyTorch, Hugging Face, Sentence Transformers, scikit-learn e LIME, em infraestrutura com GPU. O ajuste emprega AdamW e compara lotes de 8 e 32 pares, 10 e 30 épocas e taxas de aprendizagem de `2e-5` e `5e-5`. Além dessas variações, são examinados o número de positivos, a agregação dos tokens, a função de similaridade, a escala da perda, a simetrização e o pré-processamento textual.

## Resultados principais

A Tabela III compara o ajuste direto dos transformers para classificação com a abordagem em duas etapas. Os valores abaixo reproduzem o F1 ponderado e o tamanho dos modelos reportados:

| Método | F1 ponderado: Índia | F1 ponderado: EUA | Tamanho: Índia | Tamanho: EUA |
| --- | ---: | ---: | ---: | ---: |
| BERT ajustado diretamente | 0,8406 | 0,7689 | 418 MB | 418 MB |
| DistilBERT ajustado diretamente | 0,8390 | 0,7630 | 255 MB | 255 MB |
| SBERT/BERT + SVM | 0,8620 | 0,8013 | 449 MB | 437 MB |
| SBERT/DistilBERT + SVM | 0,8603 | 0,7953 | 291 MB | 278 MB |
| SBERT/BERT + Random Forest | 0,8656 | 0,8005 | 631 MB | 512 MB |
| SBERT/DistilBERT + Random Forest | 0,8637 | 0,7958 | 511 MB | 371 MB |

Na Índia, o melhor resultado dessa comparação é obtido com SBERT/BERT e Random Forest: o F1 ponderado aumenta de 0,8406 para 0,8656, ganho absoluto de 2,50 pontos percentuais em relação ao BERT ajustado diretamente. Nos Estados Unidos, SBERT/BERT e SVM atingem 0,8013, ganho de 3,24 pontos percentuais sobre 0,7689. O aumento norte-americano corresponde a aproximadamente 4,21% em termos relativos; não deve ser confundido com quatro pontos percentuais.

As combinações com DistilBERT também superam os modelos ajustados diretamente. Na base indiana, SBERT/DistilBERT e SVM alcançam 0,8603 com 291 MB, enquanto SBERT/BERT e SVM chegam a 0,8620 com 449 MB. A pequena diferença de desempenho ilustra uma alternativa de menor tamanho. Random Forest pode elevar o desempenho, mas também amplia o tamanho reportado, chegando a 631 MB na combinação com BERT para a Índia.

Esses valores pertencem à comparação principal; as tabelas de variações experimentais contêm outras configurações, algumas com resultados superiores. Por exemplo, a Tabela VIII reporta F1 ponderado de 0,8673 para Random Forest na base indiana com lote de 32.

## Efeito do pré-processamento e interpretação com LIME

O pré-processamento avaliado inclui conversão para minúsculas, remoção de transações duplicadas, limpeza de caracteres alfanuméricos e retenção de tokens com pelo menos dois caracteres, usando Gensim. O procedimento reduz o total de tokens em aproximadamente 8% na Índia e 19% nos Estados Unidos. Os exemplos da Tabela II mostram que essa limpeza também remove partes de modelos, capacidades e outras especificações.

Na Tabela IV, preservar o texto original produz resultados superiores em todas as comparações:

| Base e classificador | F1 com texto original | F1 após pré-processamento | Queda absoluta |
| --- | ---: | ---: | ---: |
| Índia, SVM | 0,8603 | 0,7790 | 8,13 p.p. |
| Índia, Random Forest | 0,8637 | 0,8017 | 6,20 p.p. |
| EUA, SVM | 0,7953 | 0,7185 | 7,68 p.p. |
| EUA, Random Forest | 0,7958 | 0,7203 | 7,55 p.p. |

Uma análise ilustrativa com LIME, apresentada na Figura 3, compara a classificação de uma descrição de computador portátil antes e depois da limpeza. A menção à capacidade de armazenamento, como `512 GB`, participa da explicação da predição. No exemplo, a probabilidade atribuída à classe principal cai de aproximadamente 0,82 para 0,71 após o pré-processamento.

O resultado sugere que atributos técnicos não devem ser descartados apenas por parecerem ruído em uma tarefa de linguagem natural. A evidência, contudo, diz respeito ao conjunto de operações testado: não demonstra que qualquer forma de normalização seja prejudicial, nem isola a contribuição de cada operação. A explicação com LIME é local e ilustrativa, sem constituir uma validação global das decisões do modelo.

## Pares positivos, agregação e hiperparâmetros

O aumento de um para três positivos por âncora melhora o F1 ponderado nas quatro combinações da Tabela V:

| Base e classificador | Um positivo | Três positivos | Ganho absoluto |
| --- | ---: | ---: | ---: |
| Índia, SVM | 0,8360 | 0,8603 | 2,43 p.p. |
| Índia, Random Forest | 0,8410 | 0,8637 | 2,27 p.p. |
| EUA, SVM | 0,7735 | 0,7953 | 2,18 p.p. |
| EUA, Random Forest | 0,7688 | 0,7958 | 2,70 p.p. |

A diversidade de descrições da mesma classe ajuda o encoder a aprender relações úteis, ao custo de mais pares e maior duração de treinamento. Os autores sugerem que pode existir um número ótimo de positivos, mas não estabelecem esse limite experimentalmente.

As demais variações mostram efeitos menores ou dependentes da base:

- **Agregação dos tokens, Tabela VI:** média, máximo e `[CLS]` apresentam desempenho próximo. Na Índia, a média obtém 0,8637 com Random Forest, contra 0,8621 com `[CLS]` e 0,8605 com máximo. Nos EUA, `[CLS]` supera a média com SVM, passando de 0,7953 para 0,8006. Não há uma estratégia universalmente superior.
- **Configuração da perda, Tabela VII:** a MNR simétrica produz ganhos pequenos, entre 0,08 e 0,49 ponto percentual nas quatro comparações. A escala 50 apresenta resultados ligeiramente inferiores aos da escala 20. O produto escalar reduz o desempenho na Índia e permanece próximo do cosseno nos EUA.
- **Tamanho do lote, Tabela VIII:** aumentar de 8 para 32 produz ganhos de 0,14 a 0,36 ponto percentual, dependendo da base e do classificador. O benefício observado é modesto, embora lotes maiores disponibilizem mais negativos para a aprendizagem contrastiva.
- **Número de épocas, Tabela VIII:** passar de 10 para 30 melhora o F1 ponderado entre 1,19 e 2,01 pontos percentuais. Na Índia, por exemplo, SVM passa de 0,8402 para 0,8603.
- **Taxa de aprendizagem, Tabela VIII:** `2e-5` supera `5e-5` nas quatro comparações, com diferenças de 0,25 a 1,56 ponto percentual. O resultado indica vantagem de atualizações menores dentro do intervalo investigado.

## Conclusões, limitações e trabalhos futuros

O estudo sustenta que a aprendizagem contrastiva supervisionada pode produzir representações mais adequadas à classificação de transações comerciais do que as obtidas pelo ajuste direto dos transformers usados como referência. A combinação entre pares definidos pelos códigos, preservação de atributos técnicos e classificação sobre embeddings constitui a principal contribuição. Os resultados também mostram que a escolha do encoder e do classificador envolve um compromisso entre desempenho e tamanho do modelo.

Os autores reconhecem o custo computacional da geração de embeddings e propõem explorar sua aplicação à detecção de anomalias. A proximidade entre transações semelhantes permitiria investigar descrições distantes de outras associadas ao mesmo código. Essa utilização é uma perspectiva de trabalho futuro, sem avaliação experimental de detecção de anomalias no artigo.

Além dessas observações dos autores, a leitura do desenho experimental permite delimitar o alcance das evidências:

- **Cobertura restrita:** os resultados abrangem dois conjuntos em inglês e os capítulos 84 e 85. Não demonstram desempenho sobre toda a nomenclatura, descrições em português ou códigos novos ausentes do treinamento.
- **Dependência dos rótulos declarados:** os códigos das bases são tratados como referência para formar pares e avaliar predições. Não é descrita uma auditoria independente que assegure a correção aduaneira de todos esses rótulos.
- **Avaliação dentro de cada conjunto:** não há teste de transferência entre países ou avaliação temporal em declarações posteriores. A validação cruzada dos classificadores não demonstra, por si só, robustez a mudanças na distribuição dos produtos.
- **Incerteza dos resultados:** as tabelas apresentam valores pontuais, sem intervalos de confiança ou testes de significância. Diferenças pequenas entre agregações ou variantes da perda devem ser interpretadas com essa limitação.
- **Detalhamento para reprodução:** além da formação dos negativos, há uma discrepância na quantidade inicial de pares norte-americanos: a seção 4.3.1 informa 39.612 pares, número que não corresponde diretamente a 70% das 58.003 transações da Tabela I. O texto não esclarece essa diferença.

Para pesquisas sobre classificação fiscal, a contribuição mais diretamente aproveitável é o uso de rótulos para ajustar o espaço de representação antes de treinar o classificador. Sua aplicação a outros contextos requer validar a qualidade dos códigos, preservar as especificações relevantes e avaliar separadamente a generalização para novas descrições, períodos e categorias. O método aprende relações entre textos e classes observadas; o artigo não descreve uma incorporação explícita da hierarquia tarifária ou das regras legais de classificação.
