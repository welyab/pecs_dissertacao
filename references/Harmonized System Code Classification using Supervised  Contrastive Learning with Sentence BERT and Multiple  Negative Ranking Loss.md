# Classificação de códigos do Sistema Harmonizado com aprendizagem contrastiva supervisionada, Sentence BERT e MNR Loss

**Autores:** Angga Wahyu Anggoro, Padraig Corcoran, Dennis De Widt e Yuhua Li.  
**Publicação:** Data Technologies and Applications, 2025. O PDF contém a versão dos autores disponibilizada pelo repositório ORCA.

## Objetivo

O trabalho propõe melhorar a representação textual de transações comerciais para prever códigos do Sistema Harmonizado (HS). A ideia central é ajustar o Sentence BERT (SBERT) por aprendizagem contrastiva supervisionada e utilizar os vetores resultantes em classificadores tradicionais. O método pretende apoiar comerciantes na escolha de códigos e autoridades na validação das declarações.

## Dados e método

São utilizados dois conjuntos públicos de importações: Índia, de 2016, com 66.522 transações e 172 classes; e Estados Unidos, de 2018, com 58.003 transações e 112 classes. O recorte contempla os capítulos 84 e 85, que incluem máquinas, aparelhos mecânicos e equipamentos elétricos. As classes são desbalanceadas, com proporção média de aproximadamente 30:1 entre classes majoritárias e minoritárias. Esse recorte por capítulos delimita o universo de produtos; a tarefa prevê os códigos das classes existentes nas bases.

Para treinar o SBERT, cada descrição usada como âncora é pareada com outra transação do mesmo código, formando um par positivo. A função Multiple Negative Ranking Loss (MNR) aproxima esses pares no espaço vetorial e utiliza outros elementos do lote como negativos. A escolha de pares pelos rótulos evita modificar artificialmente descrições que contêm informações técnicas importantes.

BERT e DistilBERT servem como codificadores. Camadas de agregação por média, máximo ou token [CLS] produzem embeddings de 768 dimensões, utilizados posteriormente por SVM e Random Forest. O artigo destina 70% das transações ao ajuste do SBERT e os 30% restantes ao treinamento e à validação dos classificadores, avaliados com validação cruzada estratificada de cinco partições. As métricas incluem kappa de Cohen, precisão, revocação e F1 com diferentes formas de agregação.

Os experimentos variam o número de pares positivos por âncora, a função de similaridade, a escala da MNR, a versão simétrica da perda, o tamanho dos lotes, as épocas e a taxa de aprendizagem. Também comparam textos originais com descrições submetidas a limpeza.

## Resultados

Na base indiana, o F1 ponderado passa de 0,8406 no BERT ajustado diretamente para 0,8620 com SBERT/BERT e SVM, e 0,8656 com SBERT/BERT e Random Forest. Na base norte-americana, o valor passa de 0,7689 para 0,8013 com SVM e 0,8005 com Random Forest. Os resultados sustentam a utilidade de aprender representações específicas antes da classificação.

Preservar a descrição original é relevante: o pré-processamento reduz o F1 ponderado em aproximadamente seis a oito pontos percentuais nas configurações comparadas. Uma análise ilustrativa com LIME mostra que atributos técnicos, como a capacidade de armazenamento, influenciam a decisão e podem ser perdidos durante a limpeza.

Usar três positivos por âncora, em vez de um, melhora o F1 ponderado em cerca de dois a três pontos percentuais. As estratégias de agregação apresentam resultados próximos, sem uma vencedora universal. A MNR simétrica e a ampliação da escala trazem mudanças pequenas. Mais épocas e lotes maiores favorecem algumas configurações, enquanto a taxa de aprendizagem menor apresenta melhores resultados nos experimentos.

## Conclusões e limites

O estudo mostra que embeddings ajustados por aprendizagem contrastiva podem melhorar SVM e Random Forest em relação ao ajuste direto dos transformers utilizados como referência. A qualidade da representação e a preservação de informações técnicas são componentes decisivos.

Há um custo computacional para gerar os embeddings e uma troca entre desempenho e tamanho do modelo. A evidência abrange dois conjuntos em inglês e dois capítulos, sem demonstrar cobertura de toda a nomenclatura ou transferência de um país para outro sem novo treinamento. Os autores apontam a detecção de anomalias como aplicação futura, explorando a proximidade entre transações semelhantes no espaço vetorial.
