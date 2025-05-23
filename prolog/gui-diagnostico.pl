 :- use_module(library(pce)).

  % Base de conocimientos de síntomas y enfermedades
  sintoma(fiebre).
  sintoma(tos).
  sintoma(dolor_de_garganta).
  sintoma(cansancio).
  sintoma(dolor_muscular).

  enfermedad(gripe, [fiebre, tos, cansancio]).
  enfermedad(resfriado, [tos, dolor_de_garganta]).
  enfermedad(otra_enfermedad, [dolor_muscular]).

  % Predicado principal para iniciar el sistema de diagnóstico
  main :-
      new(@main, dialog('Sistema de Diagnóstico de Enfermedades')),
      send(@main, append, new(@sintomas, menu('Síntomas'))),
      forall(sintoma(Sintoma), send(@sintomas, append, Sintoma)),
      send(@main, append, button('Diagnosticar', message(@prolog, diagnosticar))),
      send(@main, append, button(cancel, message(@main, destroy))),
      send(@main, open).

  % Predicado para realizar el diagnóstico basado en los síntomas seleccionados
  diagnosticar :-
      get(@sintomas, selection, SintomasSeleccionados),
      findall(Enfermedad, (enfermedad(Enfermedad, SintomasEnfermedad), subset(SintomasEnfermedad, SintomasSeleccionados)), Enfermedades),
      mostrar_resultado(Enfermedades).

  % Predicado para mostrar el resultado del diagnóstico
  mostrar_resultado([]) :-
      new(@resultado, dialog('Resultado del Diagnóstico')),
      send(@resultado, append, label('No se pudo determinar la enfermedad con los síntomas proporcionados.')),
      send(@resultado, append, button('Aceptar', message(@resultado, destroy))),
      send(@resultado, open).
 
  mostrar_resultado(Enfermedades) :-
      length(Enfermedades, NumEnfermedades),
      atomic_list_concat(Enfermedades, ', ', EnfermedadesAtom),
      format(atom(Mensaje), 'Las posibles enfermedades son: ~w', [EnfermedadesAtom]),
      new(@resultado, dialog('Resultado del Diagnóstico')),
      send(@resultado, append, label(Mensaje)),
      send(@resultado, append, button('Aceptar', message(@resultado, destroy))),
      send(@resultado, open).