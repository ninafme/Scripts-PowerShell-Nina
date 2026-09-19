## Descrição

Este script foi desenvolvido para uso próprio e tem como objetivo ajudar na organização dos meus arquivos pessoais.

Ele localiza arquivos duplicados em uma ou duas pastas e permite:

- verificar quais arquivos são duplicados;
- mover os arquivos duplicados para outra pasta;
- remover os arquivos duplicados do computador.

A comparação dos arquivos é feita usando o hash SHA256, além do tamanho e da data de modificação dos arquivos.

## Aviso importante

Este script altera arquivos reais do computador.

- `V` — apenas verifica os arquivos duplicados;
- `M` — move os arquivos duplicados para `D:\Duplicata`;
- `R` — remove os arquivos duplicados permanentemente.

O script foi criado para meu uso próprio. Antes de utilizar as opções `M` ou `R`, é recomendável testar primeiro com a opção `V` e conferir os arquivos que podem acabar sendo excluídos.

## Programas e Permissões 

- Windows PowerShell
- Permissões adequadas para leitura/escrita nos diretórios escolhidos

## Atenção

A opção de remoção exclui arquivos reais do computador. Antes de utilizar essa opção, é recomendável:
- fazer backup dos arquivos
- testar primeiro com a opção `V`
- usar a opção `M` se quiser apenas separar os arquivos antes de excluir

Arquivos visualmente semelhantes, mas com tamanhos ou conteúdos diferentes, não são considerados duplicatas. O script identifica arquivos com conteúdo idêntico, comparando-os por meio do hash SHA256, de forma semelhante a uma assinatura digital.

## Funcionamento 

O script analisa uma ou duas pastas, incluindo suas subpastas, e compara os arquivos utilizando o hash SHA256, o tamanho e a data de modificação.

Depois da análise, é possível escolher entre apenas verificar, mover ou remover os arquivos duplicados encontrados.

Para executar o script, abra o PowerShell na pasta onde ele está salvo e utilize o comando:

```powershell
.\Organizar_Duplicata.ps1
```

Ao iniciar, o script limpa a tela e pergunta se serão verificadas duas pastas:

```text
Você deseja verificar duas pastas? (S/N)
```

- `S` — permite informar duas pastas para comparação;
- `N` — permite informar apenas uma pasta.

Em seguida, o script solicita o caminho da pasta que será analisada. A pasta precisa existir e conter arquivos. Caso o caminho não seja válido ou não contenha arquivos, será solicitada uma nova pasta.

Depois, o script pergunta qual ação deverá ser realizada:

```text
Digite R para remover, V para verificar ou M para mover os arquivos encontrados
```

As opções são:

- `V` — mostra os arquivos duplicados, sem movê-los ou removê-los;
- `M` — move os arquivos duplicados para `D:\Duplicata`;
- `R` — remove os arquivos duplicados permanentemente.

Durante a execução, as informações são exibidas em tempo real no PowerShell, utilizando cores para facilitar a identificação:

- **Vermelho:** arquivo identificado como duplicata;
- **Ciano escuro:** duplicata relacionada ao arquivo mais recente;
- **Magenta:** arquivo diferente, usado como referência na comparação;
- **Azul:** arquivo que não foi identificado como duplicata;
- **Amarelo:** mensagens relacionadas à opção de mover ou a avisos;
- **Verde:** confirmações e conclusão da execução.

Ao escolher a opção `M`, a pasta `D:\Duplicata` será criada automaticamente caso ainda não exista. Porém para que isso ocorra, a unidade `D:` precisa estar disponível no computador.

## Observações

Este script foi desenvolvido para meu uso próprio e deve ser utilizado com cuidado, principalmente nas opções `M` e `R`, pois elas alteram a localização ou excluem arquivos do computador.

## Segurança na identificação de duplicatas

O script utiliza o hash SHA256 para comparar o conteúdo dos arquivos. Esse processo funciona de maneira semelhante a uma impressão digital do arquivo: se qualquer informação for alterada, mesmo um único bit no cabeçalho ou no conteúdo, o hash também será alterado.

Por isso, arquivos apenas semelhantes, com nomes iguais ou com pequenas diferenças não são considerados duplicatas. O arquivo só é tratado como duplicata quando possui o mesmo conteúdo do arquivo de referência.

Essa abordagem é mais segura do que uma comparação baseada apenas no nome, na extensão ou no tamanho do arquivo, reduzindo o risco de excluir arquivos diferentes por engano.
