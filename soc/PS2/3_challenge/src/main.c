#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

/* handy macro function to save us some typing time */
#define _I(fmt, args...)  printf(fmt "\n", ##args)


/***** structure of the entry *****/
typedef struct llist{
    struct llist *next;
    unsigned     year;
    char         *city;
    unsigned      population_total;
    unsigned      population_below_wa;
    unsigned      population_in_wa;
    unsigned      population_above_wa;
} llist_t;

/***** global: start of the linked list structure *****/
llist_t *lhead = NULL;


void llist_print_single(llist_t *entry){
    _I("%20s, %u, %6u, %6u, %6u, %6u",
        entry->city,
        entry->year,
        entry->population_total,
        entry->population_below_wa,
        entry->population_in_wa,
        entry->population_above_wa);
}


/* @brief Prints entire linked list of entries
 *
 * NOTE:
 *   your goal here is to find a way how to iterate through the list, for the
 *   actual printing utilize print_list_single procedure 
 *   NB: use the global head pointer
 *
 * */
void llist_print() {
    for (llist_t *iter = lhead; iter != NULL; iter = iter->next) {
        llist_print_single(iter);
    }
}


/* @brief Reads file and constructs the linked list structure
 *
 * NOTE:
 *   try to divide your functionality in smaller chunks, i.e. for each entry
 *   - read line
 *   - allocate structure
 *   - parse line and fill the entry 
 *   - don't forget to allocate space for cities as they are of variable length
 *   NB: use the global head pointer
 *
 * @param fd    "file descriptor"
 * 
 * */
void llist_init(FILE *fd){
    char line[64];
    llist_t *tmp = NULL;
    llist_t *prev = NULL;

    while (fgets(line, sizeof(line), fd) != NULL) {
        tmp = malloc(sizeof(llist_t));

        tmp->next = NULL;

        tmp->year = (unsigned)atoi(strtok(line, ","));

        char *token = strtok(NULL, ",");
        tmp->city = malloc(strlen(token) + 1);
        strcpy(tmp->city, token);

        tmp->population_total = (unsigned)atoi(strtok(NULL, ","));
        tmp->population_below_wa = (unsigned)atoi(strtok(NULL, ","));
        tmp->population_in_wa = (unsigned)atoi(strtok(NULL, ","));
        tmp->population_above_wa = (unsigned)atoi(strtok(NULL, ","));

        if (prev == NULL) {
            lhead = tmp;
        } else {
            prev->next = tmp;
        }

        prev = tmp;
    }
}


/* @brief Releases the linked structure and the allocated memory associated
 *        with it
 *
 * NOTE:
 *   Basically this procedure should undo the things done in the init function
 *   NB: use the global head pointer
 *
 * */
void llist_deinit(){
    llist_t *next_tmp = NULL; 

    while (lhead != NULL) {
        next_tmp = lhead->next;
        free(lhead->city);
        free(lhead);
        lhead = next_tmp;
    }
}


/* @brief Sorts linked list by the overall population
 *
 * NOTE:
 *   try learning about existant sorting algorithms, for example bubble sort:
 *   - https://www.geeksforgeeks.org/bubble-sort/
 *   - https://www.youtube.com/watch?v=kgBjXUE_Nwc
 *   NB: use the global head pointer
 *
 *   The bubble sort algorithm is not very efficient, but hey, we have to 
 *   start somewhere. Here the key is to figure out, how can you exchange
 *   entries. Drawing the linked structure should help with the intuition.
 *
 * */

void llist_swap(llist_t **a, llist_t **b) {
    llist_t *tmp = *a;
    *a = *b;
    *b = tmp;

    tmp = (*a)->next;
    (*a)->next = (*b)->next;
    (*b)->next = tmp;
}

void llist_sort_year(){
    bool swapped = true;

    while (swapped) {
        swapped = false;
        llist_t **cur = &lhead;

        while ((*cur)->next != NULL) {
            if ((*cur)->year > (*cur)->next->year) {
                swapped = true;
                llist_swap(cur, &(*cur)->next);
            }

            cur = &(*cur)->next;
        }
    }
}


/* @brief Sorts linked list by the year
 *
 * NOTE:
 *   try learning about existant sorting algorithms, for example bubble sort:
 *   - https://www.geeksforgeeks.org/bubble-sort/
 *   - https://www.youtube.com/watch?v=kgBjXUE_Nwc
 *   NB: use the global head pointer
 *
 *   The bubble sort algorithm is not very efficient, but hey, we have to 
 *   start somewhere. Here the key is to figure out, how can you exchange
 *   entries. Drawing the linked structure should help with the intuition.
 *
 * */
void llist_sort_population_overall(){
    bool swapped = true;

    while (swapped) {
        swapped = false;
        llist_t **cur = &lhead;

        while ((*cur)->next != NULL) {
            if ((*cur)->population_total > (*cur)->next->population_total) {
                swapped = true;
                llist_swap(cur, &(*cur)->next);
            }

            cur = &(*cur)->next;
        }
    }
}


void print_usage(char *fname){
    printf("USAGE:\n");
    printf("\t%s <input file name>\n", fname);
}


int main(int argc, char *argv[]){
    char *fname_input;
    FILE *fd_input;

    /* checking input parameters */
    if(argc < 2){
        print_usage(argv[0]);
        return 0;
    }

    _I("Parsing input");
    fname_input = argv[1];

    _I("Opening file");
    fd_input  = fopen(fname_input,  "r");
    if(fd_input == NULL){
        _I("FAILED to open file");
        return 1;
    }

    _I("Initializing linked list");
    llist_init(fd_input);
    llist_print();

    _I("Sorting list in acending order by the year");
    llist_sort_year();
    llist_print();

    _I("Sorting list in acending order by population size (overall)");
    llist_sort_population_overall();
    llist_print();

    _I("Deinitializing linked list");
    llist_deinit();
    
    _I("Closing files");
    fclose(fd_input);

    return 0;
}
