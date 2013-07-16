-module( event_manager ).

-export ([ start_link/0, add_handler/2, delete_handler/2, tick/0, collision/0]).

-define(SERVER,?MODULE).

start_link()-> gen_event:start_link({local,?SERVER}).

add_handler( Handler, Args) -> gen_event:add_handler(?SERVER, Handler, Args).

delete_handler( Handler, Args ) -> gen_event:delete_handler(?SERVER, Handler, Args).

tick() -> gen_event:notify(?SERVER, tick).

collision() -> gen_event:notify(?SERVER, collide).

