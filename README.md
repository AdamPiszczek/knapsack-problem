# [Knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem)
The Knapsack problem and the subset sum problem (NP-Hard Problem). 

## Simulation
![busy population of individuals](https://github.com/AdamPiszczek/knapsack-problem/blob/main/simulation.gif)

## About
The discreet backpack problem comes to the maximization of the problem of selecting items so that their total value is as significant as possible and, at the same time, they fit into the specific weight of the backpack. To facilitate the understanding of the problem, the weight of items was generated in the range of 0.1-1, and item values in the range of 1-100 (these are random values with an even distribution).

| item no. | item values | weight of items |
| ------------- | ------------- | ------------- |
| 1 | 70 | 0.79 |
| 2 | 40 | 0.67 | 
| 3 | 45 | 0.59 |
| 4 | 33 | 0.18 | 
| 5 | 1 | 0.94 |
| 6 | 15 | 0.8 |
| ... | ... | ... | 

## How to Run

```sh
> main.m
```

## Setup

Before the first run, you need to make sure that you have installed the required dependency.

## Dependiencies 
The application requires [Global Optimization Toolbox](https://www.mathworks.com/products/global-optimization.html) to be installed; besides, it uses functions from the standard library.
