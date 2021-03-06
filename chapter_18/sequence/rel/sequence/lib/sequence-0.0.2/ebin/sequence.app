{application,sequence,
             [{description,"sequence"},
              {vsn,"0.0.2"},
              {modules,['Elixir.Sequence','Elixir.Sequence.Server',
                        'Elixir.Sequence.Stash',
                        'Elixir.Sequence.SubSupervisor',
                        'Elixir.Sequence.Supervisor']},
              {applications,[kernel,stdlib,elixir,logger]},
              {mod,{'Elixir.Sequence',[]}},
              {env,[{initial_number,456}]},
              {registered,['Elixir.Sequence.Server']}]}.