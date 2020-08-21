# benchmark-bulk-update-rb
A benchmark script to measure the performances of:
- raw SQL
- activerecord's `.update`
- activerecord's `.update_all`
- activerecord's `.upsert_all`
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

## Sample output with 10000 records
```
                   user     system      total        real
SQL            0.004943   0.001863   0.006806 (  0.073905)
.update_all    0.004373   0.001748   0.006121 (  0.030592)
.update        3.521553   0.384492   3.906045 (  6.273358)
.import        1.227868   0.005164   1.233032 (  1.369131)
.upsert_all    0.612802   0.003780   0.616582 (  0.746107)
Calculating -------------------------------------
                 SQL     2.156k memsize (     0.000  retained)
                        25.000  objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
         .update_all     4.554k memsize (     0.000  retained)
                        79.000  objects (     0.000  retained)
                         9.000  strings (     0.000  retained)
             .update   148.247M memsize (     0.000  retained)
                         1.961M objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
             .import    64.103M memsize (     0.000  retained)
                       852.992k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         .upsert_all    48.003M memsize (     0.000  retained)
                       502.469k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)

Comparison:
                 SQL:       2156 allocated
         .update_all:       4554 allocated - 2.11x more
         .upsert_all:   48002916 allocated - 22264.80x more
             .import:   64102738 allocated - 29732.25x more
             .update:  148246828 allocated - 68760.12x more
```

## Sample output with 100000 records
```
                   user     system      total        real
SQL            0.007130   0.001779   0.008909 (  0.528804)
.update_all    0.003410   0.001380   0.004790 (  0.531165)
.import       11.368732   0.046732  11.415464 ( 13.442671)
.upsert_all    6.080694   0.033248   6.113942 (  8.202625)
Calculating -------------------------------------
                 SQL     2.156k memsize (     0.000  retained)
                        25.000  objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
         .update_all     4.546k memsize (     0.000  retained)
                        79.000  objects (     0.000  retained)
                         9.000  strings (     0.000  retained)
             .import   639.046M memsize (     0.000  retained)
                         8.529M objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         .upsert_all   480.149M memsize (     0.000  retained)
                         5.023M objects (     0.000  retained)
                        50.000  strings (     0.000  retained)

Comparison:
                 SQL:       2156 allocated
         .update_all:       4546 allocated - 2.11x more
         .upsert_all:  480148638 allocated - 222703.45x more
             .import:  639045643 allocated - 296403.36x more
```
