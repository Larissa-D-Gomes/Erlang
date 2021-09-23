-module (sample).
-export([listReverse/1, multiplicarListaPor2/1]).
listReverse(L) ->
    lists:reverse(L).

multiplicarListaPor2(L) ->
    F = fun (Val) -> Val * 2 end,
    lists:map(F, L).

soma

