# BulkiSwap
Batched swapps made easy!

The idea is to batch multiple swap transactions into one.

If a user swaps out n tokes for n different tokens on a dex he'd end up having to execute 2n transactions.

BulkiSwap aims to execute all the swaps by batching 'em all into a single txn saving (2n-1)*21000 gas (That's a lot of money!).

This would mean the tokens would have to inherently supposort the Permit functionality else for every outlier we'd have a transaction added to approve the token to be spent first.
