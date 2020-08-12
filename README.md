# benchmark-bulk-update-rb
A benchmark script to measure the performances of:
- raw SQL
- activerecord's `.update_all`
- activerecord-import's `import` with `on_duplicate_key_update` option


## Setup
```
% rake db:create
% rake db:migrate

% bundle exec ruby app/setup.rb # run once to prepare data
```

## Run
```
% bundle exec ruby app/main.rb
```

## Sample output
```
                   user     system      total        real
SQL            0.007339   0.001870   0.009209 (  0.096955)
.update_all    0.003729   0.001579   0.005308 (  0.044793)
.import        3.338551   0.012670   3.351221 (  3.362855)
Calculating -------------------------------------
                 SQL     2.156k memsize (     0.000  retained)
                        25.000  objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
         .update_all     4.546k memsize (    40.000  retained)
                        79.000  objects (     1.000  retained)
                         9.000  strings (     0.000  retained)
             .import   278.546M memsize (     0.000  retained)
                         2.582M objects (     0.000  retained)
                        39.000  strings (     0.000  retained)

Comparison:
                 SQL:       2156 allocated
         .update_all:       4546 allocated - 2.11x more
             .import:  278546248 allocated - 129195.85x more
```
