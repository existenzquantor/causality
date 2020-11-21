effect('move_rob-a_kitchen_living-room', ['in_rob-a_kitchen'], [not('in_rob-a_kitchen'),'in_rob-a_living-room']).
effect('move_rob-a_living-room_kitchen', ['in_rob-a_living-room'], ['in_rob-a_kitchen',not('in_rob-a_living-room')]).
effect('make_coffee_rob-a', ['in_rob-a_kitchen',not('carry_rob-a-coffee')], ['carry_rob-a-coffee']).
effect('serve_coffee_rob-a_mrssmith', ['carry_rob-a-coffee','in_rob-a_living-room'], [not('carry_rob-a-coffee'),'has_coffee_mrssmith']).
effect('wait', [], []).
effect(0, ['has_coffee_mrssmith'], ['p']).
init([not('in_rob-a_kitchen'),'in_rob-a_living-room','carry_rob-a-coffee',not('has_coffee_mrssmith'), not('p')]).
goal(['has_coffee_mrssmith']).