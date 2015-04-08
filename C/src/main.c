/* FitBreak */
/* @author: krakovoj@fit.cvut.cz */
/* @version: 1.0 */
/* (c) LS 2015 */
/* MI - FLP */
/********************************************/
#include <stdio.h>
#include <stdlib.h>

#define DEBUG
#define NODES_MIN 2
#define NODES_MAX 100
#define INF       9999
#define NO_PRE -2

typedef struct graph{
	int m_nodes_cnt;
	int ** m_adjacency_matrix;
	int * m_distance;
	int * m_predecessor;
} graph_t;

void read_input(graph_t * g){
	int i = 0, j = 0;
	int street_cnt = 0;
	int node1, node2, length;
	
	scanf("%d",&g->m_nodes_cnt);
	if(g->m_nodes_cnt < NODES_MIN || g->m_nodes_cnt > NODES_MAX)
		printf("Input g->m_nodes_cnt is not allowed number. It is %d.\n",
				g->m_nodes_cnt);

	g->m_adjacency_matrix = malloc(g->m_nodes_cnt * sizeof(int *));
	for(i = 0; i < g->m_nodes_cnt; i++)
		g->m_adjacency_matrix[i] = malloc(g->m_nodes_cnt * sizeof(int));
	
	g->m_distance = malloc(g->m_nodes_cnt * sizeof(int));
	g->m_predecessor = malloc(g->m_nodes_cnt * sizeof(int));

	for(i = 0; i < g->m_nodes_cnt; i++)
		g->m_predecessor[i] = NO_PRE;

	/* init adjacency matrix */
	for(i = 0; i < g->m_nodes_cnt; i++)
		for(j = 0; j < g->m_nodes_cnt; j++)
			g->m_adjacency_matrix[i][j] = 0;

	/* read the streets */
	scanf("%d", &street_cnt);

	for(i = 0; i < street_cnt ; i++){		
		scanf("%d %d %d", &node1, &node2, &length);
		g->m_adjacency_matrix[--node1][--node2] = length;
		g->m_adjacency_matrix[node2][node1] = length;
	}
}

void reverse_edges(graph_t * g){
	int source,dest;

	dest = g->m_nodes_cnt-1;
	source = g->m_predecessor[dest];

	while(dest != 0){
		g->m_adjacency_matrix[source][dest] =
			-g->m_adjacency_matrix[source][dest];
		dest = source;
		source = g->m_predecessor[dest];
	}
}

/* Bellman Ford algorithm */
void bellman_ford(graph_t * g){
	int i , j, k;

	for(i = 1; i < g->m_nodes_cnt; i++){
		g->m_distance[i] = INF;
		g->m_predecessor[i] = NO_PRE;
	}

	g->m_distance[0] = 0;

	for(i = 0; i < g->m_nodes_cnt; i++)
		for(j = 0; j < g->m_nodes_cnt; j++)
			for(k = 0; k < g->m_nodes_cnt; k++){
				if(g->m_adjacency_matrix[j][k] <= 0)
					continue;
		
				if(g->m_distance[j] + g->m_adjacency_matrix[j][k] < 
						g->m_distance[k]){
					g->m_distance[k] = g->m_distance[j]+g->m_adjacency_matrix[j][k];
					g->m_predecessor[k] = j;
				}
					
			}
	
}

int main(void){
	int i;
	graph_t Graph;

	read_input(&Graph);
	bellman_ford(&Graph);
	reverse_edges(&Graph);
	bellman_ford(&Graph);
#ifdef DEBUG
	printf("Graph->m_nodes_cnt is %d.\n", Graph.m_nodes_cnt);
	printf("Predecessors:\n");
	for(i = 0; i < Graph.m_nodes_cnt; i++)
		printf("[%d] = %d\n",i+1, Graph.m_predecessor[i]+1);
#endif
	printf("Total distance to last node is %d\n", 
			Graph.m_distance[Graph.m_nodes_cnt-1]);
	return 0;
}
