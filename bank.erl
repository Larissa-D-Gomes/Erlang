-module(bank).

-export([abrir/0]).
-export([main_loop/1]).
-export([fechar/0]).
-export([init/0]).
-export([depositar/2]).
-export([saldo/1]).
-export([saldoAtual/2]).

abrir() ->   
    io:format("Aplicativo Bank aberto.~n"),
    %Criando processo para o modulo%
    Pid = spawn(?MODULE, init, []),
    register(?MODULE, Pid).

fechar() -> 
    ?MODULE ! fechar.

saldo(ContaID) -> 
    ?MODULE ! {saldo, self(), ContaID},
    receive
        Reply -> Reply
    end.

init() -> 
    %Contas armazenadas em uma estrutura de dicionario%
    Contas = dict:new(),
    main_loop(Contas).

depositar(ContaID, Valor) -> 
    ?MODULE ! {dep, self(), ContaID, Valor},
    receive
        Reply -> Reply
    end.

saldoAtual(ContaID, Contas) ->
            case dict:find(ContaID, Contas) of
                error -> 0;
                {ok, Valor0} -> Valor0 
            end.

main_loop(Contas) ->
    receive
        {dep, Caller, ContaID, Valor} -> 
            SaldoAtual = case dict:find(ContaID, Contas) of
                error -> 0;
                {ok, Valor0} -> Valor0
            end,
            Conta1 = dict:store(
                ContaID,
                SaldoAtual + Valor,
                Contas 
            ),
            Caller ! ok,
            io:format("~p depositou ~p reais.~n", [ContaID, Valor]),
            main_loop(Conta1);
        
        {saldo, Caller, ContaID} -> 
            Caller ! {ok, saldoAtual(ContaID, Contas)},
            main_loop(Contas);
        fechar -> 
            io:format("Aplicativo Bank fechado.~n")
    end.