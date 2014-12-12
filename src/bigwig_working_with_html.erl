-module(bigwig_working_with_html).
-compile(export_all).
%====================================================================================================================================================================================
-define(Header, lists:append(["<html><head><title></title></head><body bgcolor=",get_random_color(),">"])).
-define(Footer, "</body></html>").
%====================================================================================================================================================================================
-spec list_to_html(_) -> binary() | [#exchange_rec{good_id::0,new_good_id::0,brand_id::0,new_brand_id::0,undef_int::0,good_name::<<>>,new_good_name::<<>>,brand_name::<<>>,new_brand_name::<<>>,error::binary(),undef_bin::<<>>},...].
list_to_html(List) when is_pid(List) -> list2binary_ex([?Header, pid_to_list(List),?Footer]);
list_to_html(List) when is_list(List) ->
  case is_simple_list(List) of
    true  -> list2binary_ex([?Header, List,?Footer]);
    false -> list2binary_ex([?Header,list_to_html_table(List),?Footer])
  end;
list_to_html(List) when is_tuple(List) -> list_to_html(tuple_to_list(List));
list_to_html(List) when is_atom(List) -> list2binary_ex([?Header,atom_to_list(List),?Footer]);
list_to_html(_List) -> list2binary_ex([?Header, "error!!!",?Footer]);
%*****************************************************************************************************************************************************************************************	
-spec list_to_html_table(maybe_improper_list()) -> binary().
list_to_html_table(List) ->
  case is_string(List) of
    true  -> list2binary_ex(["<table bgcolor=",get_random_color(),"><tr><td>",List,"</td></tr></table>"]);
    false -> list_to_html_table(List, [])
  end.
%*****************************************************************************************************************************************************************************************
-spec list_to_html_table([any()],[any()]) -> binary().
list_to_html_table([], ANS) -> list2binary_ex(["<table bgcolor=",get_random_color(),">", lists:reverse(ANS), "</table>"]);
list_to_html_table([Head | Tail], ANS) ->list_to_html_table(Tail, [get_row(Head)| ANS]).
%*****************************************************************************************************************************************************************************************
-spec get_row(_) -> binary().
get_row(Row) when is_tuple(Row)->get_row(tuple_to_list(Row));
get_row(Row) when is_pid(Row)->list2binary_ex(["<tr><td>",pid_to_list(Row),"</td></tr>"]);
get_row(Row) ->
  case is_list(Row) of
    true->case is_string(Row) of
            true->list2binary_ex(["<tr><td>",Row,"</td></tr>"]);
            false->get_row(Row,[])
          end;
    false->list2binary_ex(["<tr><td>",Row,"</td></tr>"])
  end.
-spec get_row([any()],[any()]) -> binary().
get_row([],ANS)->list2binary_ex(["<tr>", lists:reverse(ANS), "</tr>"]);
get_row([H|T],ANS)when is_list(H)->
  case is_string(H) of
    true  -> get_row(T,[list2binary_ex(["<td>", H, "</td>"])|ANS]);
    false -> get_row(T,[list2binary_ex(["<td>",list_to_html_table(H), "</td>"])|ANS])
  end;
get_row([H|T],ANS)when is_tuple(H)->get_row([tuple_to_list(H)|T],ANS);
get_row([H|T],ANS)->get_row(T,[list2binary_ex(["<td>", H , "</td>"])|ANS]).
%====================================================================================================================================================================================
-spec get_random_color() -> [any()].
get_random_color()->
  lists:append(["#",integer_to_list(random:uniform(245)+10, 16),integer_to_list(random:uniform(245)+10, 16),integer_to_list(random:uniform(245)+10, 16)]).
%====================================================================================================================================================================================
list2binary_ex(ListOfTerms) -> list_to_binary([list2binary_convert(E) || E <- ListOfTerms]).
list2binary_convert(X) when is_atom(X) -> atom_to_list(X);
list2binary_convert(X) when is_integer(X) -> integer_to_list(X);
list2binary_convert(X) when is_float(X) -> float_to_list(X);
list2binary_convert(X) when is_pid(X) -> pid_to_list(X);
list2binary_convert(X) -> X.
%====================================================================================================================================================================================
is_string([]) -> true;
is_string([H | T]) when is_integer(H)->
         case H < 256 of
           true -> is_string(T);
           false-> false
         end;
is_string([_H | _T]) -> false.
%=============================================================================================================================================================================================
is_simple_list([]) -> true;
is_simple_list([_H | _T]) when is_list(_H) -> false;
is_simple_list([_H | _T]) when is_tuple(_H) -> false;
is_simple_list([H | T]) ->
  case array:is_array(H) of
    true -> false;
    _ -> is_simple_list(T)
  end.
