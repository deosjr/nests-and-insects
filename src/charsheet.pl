﻿:-module(charsheet, [print_charsheet/1]).

/** <module> Print character sheets in glorious ASCII.

*/

%!      pad_length(?Where,?Pad) is semidet.
%
%       A character that turns into a Pad in the full moon.
%
%       Length of lines that need to be padded with spaces or other
%       characters, smart arse.
%
pad_length(class_name, 91).


%!      print_charsheet(+Class) is det.
%
%       Print a Class' character sheet in glorious ASCII.
%
print_charsheet(Id):-
        print_class_name(Id)
        ,print_attributes(Id)
        ,print_combat_stats(Id)
        ,print_attacks(Id)
        ,print_survival(Id)
        ,print_abilities(Id)
        ,print_effects_inventory(Id).


%!      print_class_name(+Class) is det.
%
%       Print the Class name.
%
print_class_name(Id):-
        pad_length(class_name, L)
        % Length of the Class Id
        ,atom_length(Id, N)
        ,N_ is ceil(N/2)
        % Padding string offset to make space for half of Id string.
        % Because we want to print the class Id in the middle of the padded line.
        ,P is ceil(L/2) + N_ + 1
        ,upcase_atom(Id,ID)
        ,format('╔►Nests and Insects◄~|~`═t~55+►Character Sheet◄╗~n',[])
        ,format('║~`.t ~w~*| ~`.t~92|║▓~n',[ID,P]).


%!      print_class_name(+Class) is det.
%
%       Print the Class Attributes and their ratings.
%
print_attributes(Id):-
        chargen:features(Id,attribute,FRs)
        ,pairs_keys_values(FRs,_,[Sp,Sk,Str,Sta,Sm,Ch,Ke,Pa])
        ,format('╠►Attributes◄~|~`═t~79+╣▓~n',[])
        ,format('║ ┌~|~`─t~87+┐ ║▓~n')
        ,format('║ │ □ Speed.....:[__~w%] □ Skill....:[__~w%] □ Strength....:[__~w%] □ Stamina....:[__~w%] │ ║▓~n', [Sp,Sk,Str,Sta])
        ,format('║ │ □ Smarts....:[__~w%] □ Charms...:[__~w%] □ Ken.........:[__~w%] □ Passions...:[__~w%] │ ║▓~n',[Sm,Ch,Ke,Pa])
        ,format('║ └<^XP>────────────────<^XP>───────────────<^XP>──────────────────<^XP>──────────────────┘ ║▓~n').


%!      print_combat_stats(+Class) is det.
%
%       Print the Class' Combat Conditions and Disposition Track.
%
print_combat_stats(Id):-
% Lots of distortion in this predicate because of missing fonts in
% Courrier. Use Deja Vu Sans Mono to display correctly in editor.
        chargen:features(Id,condition,FRs)
        ,pairs_keys_values(FRs,_,[Init,TR,SR,Ws])
        ,format('╠►Combat Stats◄~|~`═t~77+╣▓~n',[])
        ,format('║┌[Condition]~|~`─t~14+<Rules Reminder>~|~`─t~47+┐ ║▓~n',[])
        ,format('║│ □ Initiative...:[__~w%] (Match/Beat to start Combat in Holding/Recoiling Disposition). │ ║▓~n',[Init])
        ,format('║│ □ Threat Rate..:[__~w%] (Match/Beat Attacker''s TR to Hit/Miss Target)................. │ ║▓~n',[TR])
        ,format('║│ □ Survival Rate:[__~w%] (Match/Beat Target''s SR to Hit/Miss with Base/Special Attack). │ ║▓~n',[SR])
        ,format('║│ □ Wounds/Max...:[__/_~w] (1 Wound = 1 Shift Down. When Wounds ≥ Max, character dies)... │ ║▓~n',[Ws])
	,format('║│ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧  │ ║▓~n',[])
        ,format('║├─<Disposition Track>────────────────────────────────────────────────────────────────────┤ ║▓~n',[])
	,format('║│ (Advance this way -->) ......................................... (<-- Recoil this way) │ ║▓~n',[])
	,format('║│ ○ Retreating...... ○ Recoiling...... ○ Holding...... ○ Advancing...... ○ Charging......│ ║▓~n',[])
	,format('║└<^Cant Attack>─────<^-30%>───────────<^Doing Good>───<^+30%>───────────<^Shift Up>──────┘ ║▓~n',[])
	,format('║ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ✧ ║▓~n',[])
	.


%!      print_attacks(+Class) is det.
%
%       Print a Class' Attack descriptions.
%
%       I warn you now, before you look at the code: this is gonna hurt.
%
print_attacks(Id):-
% Comments show examples of expected input to ease the pain.
% The pain... THE PAIN!
        chargen:features(Id,attacks,[BA,SA])
        ,BA = [%name-'Pincer Attack'
               name-BA_Name
              %,keywords-['Crushing','Shredding']
              ,keywords-BA_Keywords
              %,wounds-1
              ,wounds-BA_Ws
              %,max_range-'Close'
              ,max_range-BA_Max_Range
              %,hit-'Taregt Recoils'
              ,hit-BA_Hit1
              %,hit_2-['(Alt)','']
              ,hit_2-[Rem1,BA_Hit2]
              %,hit_3-['(Add)','']
              ,hit_3-[Rem2,BA_Hit3]
              %,miss_1-'Attacker Recoils'
              ,miss_1-BA_Miss1
              %,miss_2-['(Alt)','']
              ,miss_2-[Rem3,BA_Miss2]
         ]
        ,SA = [%name-'Stinger Attack'
               name-SA_Name
              %,keywords-['Piercing','Venomous','Lethal']
              ,keywords-SA_Keywords
              %,wounds-2
              ,wounds-SA_Ws
              %,max_range-'Close'
              ,max_range-SA_Max_Range
              %,hit-'Taregt in Agony: d60'
              ,hit-SA_Hit1
              %,hit_2-['(Alt)','']
              ,hit_2-[Rem4, SA_Hit2]
              %,hit_3-['(Crit)','Enemy Killed']
              ,hit_3-[Rem5,SA_Hit3]
              %,miss_1-'Attacker Recoils'
              ,miss_1-SA_Miss1
              %,miss_2-['(Alt)','']
              ,miss_2-[Rem6,SA_Miss2]
         ]
        ,maplist(atomic_list_concat,[BA_Keywords,SA_Keywords],[',',','],[BAK,SAK])
        % This is the bit that really hurts.
        % There's no way to line up these format strings without messing up formatting.
        % But the way they look I'm not sure I'll be ever capable of debugging this.
        ,format('║┌[Base Attack]──────────────────────────────┐┌[Special Attack]───────────────────────────┐ ║▓~n',[])
        ,format('║│ ~|Name:~`.t~w~41+ ││ ~|Name:~`.t~w~41+ │ ║▓~n',[BA_Name,SA_Name])
        ,format('║│ ~|Keywords:~`.t~w~41+ ││ ~|Keywords:~`.t~w~41+ │ ║▓~n',[BAK,SAK])
        ,format('║│ ~|Wounds:~`.t~w~41+ ││ ~|Wounds~`.t~w~41+ │ ║▓~n',[BA_Ws,SA_Ws])
        ,format('║│ ~|Max. Range:~`.t~w~41+ ││ ~|Max. Range:~`.t~w~41+ │ ║▓~n',[BA_Max_Range,SA_Max_Range])
        ,format('║│ ~|Hit:~`.t~w~41+ ││ ~|Hit:~`.t~w~41+ │ ║▓~n',[BA_Hit1,SA_Hit1])
	,format('║│ ~|Hit ~w:~`.t~w~41+ ││ ~|Hit ~w:~`.t~w~41+ │ ║▓~n',[Rem1,BA_Hit2,Rem4,SA_Hit2])
        ,format('║│ ~|Hit ~w:~`.t~w~41+ ││ ~|Hit ~w:~`.t~w~41+ │ ║▓~n',[Rem2,BA_Hit3,Rem5,SA_Hit3])
        ,format('║│ ~|Miss:~`.t~w~41+ ││ ~|Miss:~`.t~w~41+ │ ║▓~n',[BA_Miss1,SA_Miss1])
        ,format('║│ ~|Miss ~w:~`.t~w~41+ ││ ~|Miss ~w:~`.t~w~41+ │ ║▓~n',[Rem3,BA_Miss2,Rem6,SA_Miss2])
        ,format('║└───────────────────────────────────────────┘└───────────────────────────────────────────┘ ║▓~n',[]).

%!      print_survival(+Class) is det.
%
%       Print a Class' Survival Features and their ratings.
%
print_survival(_Id):-
         format('╠►Survival◄═════════════════════════════════════════════════════════════════════════════════╣▓~n',[])
        ,format('║┌[Food]───────────────────┐┌[Luck]───────────────────────────────────────────────────────┐ ║▓~n',[])
        ,format('║│ ○ Hunger........[___0%] ││ [11%].[22%].[33%].[44%].[55%].[66%].[77%].[88%].[99%].[00%].│ ║▓~n',[])
        ,format('║└<^Starving>──────────────┘└──^──────────────────────────────────────────────────────────┘ ║▓~n',[]).


%!      print_abilities(+Class) is det.
%
%       Print a Class' Specific and Common Abilities and their ratings.
%
print_abilities(Id):-
        maplist(chargen:features(Id),[specific_ability,common_ability],[SAs,CAs])
        ,maplist(pairs_keys_values,[SAs,CAs],[_,_],[SA_Rs%[Ca,Fl,Sw,Ven,Web]
                                                   ,[Con,Eus,Exp,For,Hea,Hun,Lea,Per,Sig,Sne]])
        ,findall(W
                ,(member(SA,SA_Rs)
                 ,(   SA == 0
                  ->  W = '_0'
                  ;   W = SA
                  )
                 )
                ,[Car,Fly,Swa,Ven,Web])
	,format('╠►Abilities◄════════════════════════════════════════════════════════════════════════════════╣▓~n',[])
        ,format('║┌[Specific Abilities]────────┐┌[Common Abilities]────────────────────────────────────────┐ ║▓~n',[])
        ,format('║│ Carapace..........:[__~w%] ││ □ Construction.....:[__~w%] □ Hunting...........:[__~w%] │ ║▓~n',[Car,Con,Hun])
        ,format('║│ Flying............:[__~w%] ││ □ Eusociology......:[__~w%] □ Leadership........:[__~w%] │ ║▓~n',[Fly,Eus,Lea])
        ,format('║│ Swarming..........:[__~w%] ││ □ Exploration......:[__~w%] □ Perception........:[__~w%] │ ║▓~n',[Swa,Exp,Per])
        ,format('║│ Venomous..........:[__~w%] ││ □ Foraging.........:[__~w%] □ Signalling........:[__~w%] │ ║▓~n',[Ven,For,Sig])
        ,format('║│ Web Weaving.......:[__~w%] ││ □ Healing..........:[__~w%] □ Sneaking..........:[__~w%] │ ║▓~n',[Web,Hea,Sne])
        ,format('║└────────────────────────────┘└<^XP>───────────────────────<^XP>─────────────────────────┘ ║▓~n',[]).


%!      print_effects_inventory(+Class) is det.
%
%       Print starting Effects and Inventory Items and their ratings.
%
%       @bug Currently this can only print a single inventory item. I
%       don't think there's any class that has more than one starting
%       item so far but if one does, then this better be fixed.
%
print_effects_inventory(Id):-
        maplist(chargen:features(Id),[effect,inventory_item],[Es,Is])
        ,maplist(pairs_keys_values,[Es,Is],[_,[It]],[E_Rs ,[R] ])
        ,findall(W
                ,(member(SA,E_Rs)
                 ,(   SA == 0
                  ->  W = '__'
                  ;   W = SA
                  )
                 )
                ,[Ago,Ble,Bli,Cha,Con,Imm,Inf,Par,Poi,Stu])
        ,character:inventory_item(It,Nm)
        ,atom_length(Nm, N)
        ,Pad is 30 - N
        ,format('║┌[Effects]───────────────────────────────────┐┌[Inventory]───────────────────────────────┐ ║▓~n',[])
        ,format('║│ ○ Agony....:[__~w%] ○ Immobilised.:[__~w%] ││ ○ ~w~|~`_t~*+:[__~w%] │ ║▓~n',[Ago,Imm,Nm,Pad,R])
        ,format('║│ ○ Bleeding.:[__~w%] ○ Infected....:[__~w%] ││ ○ ______________________________:[____%] │ ║▓~n',[Ble,Inf])
        ,format('║│ ○ Blind....:[__~w%] ○ Paralysed...:[__~w%] ││ ○ ______________________________:[____%] │ ║▓~n',[Bli,Par])
        ,format('║│ ○ Charmed..:[__~w%] ○ Poisoned....:[__~w%] ││ ○ ______________________________:[____%] │ ║▓~n',[Cha,Poi])
        ,format('║│ ○ Confused.:[__~w%] ○ Stunned.....:[__~w%] ││ ○ ______________________________:[____%] │ ║▓~n',[Con,Stu])
        ,format('║└<^Applies>──────────<^Applies>──────────────┘└<^Edible>─────────────────────────────────┘ ║▓~n',[])
        ,format('╚═══════════════════════════════════════════════════════════════════════════════════════════╝▓~n',[])
        ,format(' ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀~n',[])
        .


