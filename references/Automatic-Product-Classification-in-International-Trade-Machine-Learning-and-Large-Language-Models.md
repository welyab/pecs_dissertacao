# Classificação automática de produtos no comércio internacional: aprendizagem de máquina e grandes modelos de linguagem

**Autores:** Ignacio Marra de Artiñano, Franco Riottini Depetris e Christian Volpe Martincus.  
**Versão analisada:** agosto de 2024.

## Objetivo e contexto

O estudo investiga a classificação automática de produtos no Sistema Harmonizado (HS) a partir de descrições textuais, comparando algoritmos tradicionais de aprendizagem de máquina com grandes modelos de linguagem (LLMs). Seu foco principal é a validade externa: verificar se um modelo que funciona bem em uma base também consegue classificar descrições provenientes de outros países ou contextos. A classificação correta é relevante para arrecadação, estatísticas comerciais, regras de origem e fiscalização aduaneira.

## Dados e metodologia

A análise abrange produtos agrícolas, animais e alimentícios dos capítulos 1 a 22, correspondentes a 866 classes HS6, 185 posições HS4 e 22 capítulos HS2. A base aduaneira chilena, de 2009 a 2021, fornece uma amostra de um milhão de descrições distintas, dividida em 70% para treinamento e 30% para teste. A generalização é avaliada em 10 mil descrições aduaneiras paraguaias e mil descrições de produtos orgânicos certificados pelo Departamento de Agricultura dos Estados Unidos (USDA). Estas últimas recebem códigos atribuídos manualmente para permitir a avaliação.

Os modelos tradicionais incluem SVM, Rocchio, regressão logística, k-vizinhos mais próximos, Random Forest, Naive Bayes e árvore de decisão. Seu processamento envolve limpeza, normalização, tokenização, remoção de termos pouco informativos e lematização. GPT-3.5, GPT-4, Claude 3 Sonnet e Claude 3.5 Sonnet são utilizados por API, sem treinamento específico nas bases estudadas e sem essa limpeza prévia. Os prompts solicitam um código HS6, inclusive uma estimativa quando a descrição é insuficiente. A avaliação considera acurácia, precisão, revocação e F1, além de códigos inexistentes gerados pelos LLMs.

## Principais resultados

No teste chileno, os algoritmos tradicionais apresentam desempenho elevado: a árvore de decisão alcança 97% de acurácia em HS6, enquanto regressão logística e SVM atingem 95%. Claude 3.5 Sonnet obtém 81% e GPT-4, 75%. Porém, essa vantagem desaparece nos dados externos.

No Paraguai, a acurácia HS6 dos modelos tradicionais varia de 15% a 28%, enquanto Claude 3.5 Sonnet alcança 88% e GPT-4, 74%. Na amostra USDA, o melhor modelo tradicional chega a 15%, contra 73% do Claude 3.5 e 72% do GPT-4. Em níveis menos detalhados, os LLMs melhoram: no USDA, GPT-4 chega a 82% em HS4 e 92% em HS2.

A robustez é examinada pelo balanceamento dos capítulos e pela inversão das bases de treinamento e teste. Essas alterações preservam a conclusão de baixa generalização dos métodos tradicionais. A classificação sequencial por prompts, de HS2 para HS4 e HS6, reduz a acurácia no experimento, mostrando que decompor a tarefa não garante melhoria.

Os LLMs também geram códigos inexistentes. No teste chileno, as taxas HS6 são 0,31% para Claude 3.5 Sonnet e 1,70% para GPT-4. Esses erros diminuem em HS4. O reconhecimento de diferentes nomes regionais de um mesmo produto ajuda a explicar a generalização superior dos LLMs.

## Conclusões e limites

A principal contribuição é demonstrar que elevada acurácia dentro de uma base não assegura desempenho em outras fontes. Os LLMs avaliados oferecem maior capacidade de transferência e menor necessidade de preparação textual, com aplicações em integração de bases, sugestões de códigos e identificação de inconsistências em declarações.

Os resultados se restringem aos capítulos analisados, às amostras e às versões dos modelos utilizadas. Descrições ambíguas, classes raras e códigos inexistentes continuam sendo problemas. O estudo propõe ampliar a avaliação para outros produtos e modelos e investigar ajustes específicos para o domínio.
