import java.util.*;
class PathVectorRouting {
    // Method to find the shortest path using Path Vector Routing Algorithm
    public void findShortestPaths(int[][] graph, int numVertices) {
        // Initializing the distance and path vectors
        int[][] distance = new int[numVertices][numVertices];
        int[][] path = new int[numVertices][numVertices];

        // Initialize distance and path vectors
        for (int i = 0; i < numVertices; i++) {
            for (int j = 0; j < numVertices; j++) {
                if (i == j) {
                    distance[i][j] = 0; // Distance to itself is 0
                    path[i][j] = i;     // Path to itself is just the node
                } else if (graph[i][j] != 0) {
                    distance[i][j] = graph[i][j];
                    path[i][j] = j;
                } else {
                    distance[i][j] = Integer.MAX_VALUE; // Representing infinity for no direct path
                    path[i][j] = -1;
                }
            }
        }

        // Applying the Path Vector Algorithm
        for (int k = 0; k < numVertices; k++) {
            for (int i = 0; i < numVertices; i++) {
                for (int j = 0; j < numVertices; j++) {
                    // If there's a shorter path via vertex k, update the path and distance
                    if (distance[i][k] != Integer.MAX_VALUE && distance[k][j] != Integer.MAX_VALUE &&
                        distance[i][k] + distance[k][j] < distance[i][j]) {
                        distance[i][j] = distance[i][k] + distance[k][j];
                        path[i][j] = path[i][k];
                    }
                }
            }
        }

        // Printing the shortest paths
        printShortestPaths(distance, path, numVertices);
    }

    // Method to print the shortest paths
    public void printShortestPaths(int[][] distance, int[][] path, int numVertices) {
        System.out.println("Shortest Paths between vertices:");
        for (int i = 0; i < numVertices; i++) {
            for (int j = 0; j < numVertices; j++) {
                if (i != j) {
                    System.out.print("From " + i + " to " + j + " : ");
                    printPath(i, j, path);
                    System.out.println(" | Distance: " + (distance[i][j] == Integer.MAX_VALUE ? "Infinity" : distance[i][j]));
                }
            }
        }
    }

    // Recursive method to print the path
    private void printPath(int src, int dest, int[][] path) {
        if (path[src][dest] == -1) {
            System.out.print("No path");
            return;
        }
        System.out.print(src);
        while (src != dest) {
            src = path[src][dest];
            System.out.print(" -> " + src);
        }
    }

    public static void main(String[] args) {
        // Example graph represented as an adjacency matrix
        int[][] graph = {
            {0, 3, 0, 0, 6, 5},
            {3, 0, 1, 0, 0, 4},
            {0, 1, 0, 6, 0, 4},
            {0, 0, 6, 0, 8, 5},
            {6, 0, 0, 8, 0, 2},
            {5, 4, 4, 5, 2, 0}
        };

        PathVectorRouting pvr = new PathVectorRouting();
        pvr.findShortestPaths(graph, graph.length);
    }
}