#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "snake_utils.h"
#include "state.h"

/* Helper function definitions */
static char get_board_at(game_state_t* state, int x, int y);
static void set_board_at(game_state_t* state, int x, int y, char ch);
static bool is_tail(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static int incr_x(char c);
static int incr_y(char c);
static void find_head(game_state_t* state, int snum);
static char next_square(game_state_t* state, int snum);
static void update_tail(game_state_t* state, int snum);
static void update_head(game_state_t* state, int snum);

/* Helper function to get a character from the board (already implemented for you). */
static char get_board_at(game_state_t* state, int x, int y) {
  return state->board[y][x];
}

/* Helper function to set a character on the board (already implemented for you). */
static void set_board_at(game_state_t* state, int x, int y, char ch) {
  state->board[y][x] = ch;
}

/* Task 1 */
game_state_t* create_default_state() {
  // TODO: Implement this function.
  game_state_t* state = malloc(sizeof(struct game_state_t));
  state->x_size = 14;
  state->y_size = 10;

  state->board = malloc(sizeof(char*) * state->y_size);

  state->num_snakes = 1;
  state->snakes = malloc(sizeof(snake_t) * state->num_snakes);
  for (int i=0; i<state->num_snakes; i++) {
    state->snakes[i].tail_x = 4;
    state->snakes[i].tail_y = 4;
    state->snakes[i].head_x = 5;
    state->snakes[i].head_y = 4;
    state->snakes[i].live = true;
  } 

  for (int i=0; i<state->y_size; i++) {
    state->board[i] = malloc(sizeof(char) * state->x_size);
    for (int j=0; j<state->x_size; j++) {
      if ((j == 0) || (j == state->x_size - 1) || (i == 0) ||  (i == state->y_size - 1)) {
        set_board_at(state, j, i, '#');
      }
      else if ((i==state->snakes->tail_y) && (j==state->snakes->tail_x))
      {
        set_board_at(state, j, i, 'd');
      }
      else if ((i== state->snakes->head_y) && (j== state->snakes->head_x))
      {
        set_board_at(state, j, i, '>');
      }
      else if (i == 2 && j == 9)
      {
        set_board_at(state, j, i, '*');
      }
      else {
        set_board_at(state, j, i, ' ');
      }
    }
  }
  return state;
}

/* Task 2 */
void free_state(game_state_t* state) {
  // TODO: Implement this function.
  for (int i=0; i<state->y_size; i++) {
    free(state->board[i]);
  }
  free(state->board);
  free(state->snakes);
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  // TODO: Implement this function.
  for (int i=0; i<state->y_size; i++) {
    for (int j=0; j<state->x_size; j++) {
      fprintf(fp, "%c", get_board_at(state, j, i));
    }
    fprintf(fp, "%c", '\n');
  }
  return;
}

/* Saves the current state into filename (already implemented for you). */
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */
static bool is_tail(char c) {
  // TODO: Implement this function.
  if ((c=='w') || (c=='a') || (c=='s') || (c=='d')) {
    return true;
  }
  else{
    return false;
  }
}

static bool is_snake(char c) {
  // TODO: Implement this function.
  if ((c=='w') || (c=='a') || (c=='s') || (c=='d') || (c=='^') || (c=='<') || (c=='>') || (c=='v') || (c=='x')) {
    return true;
  }
  else{
    return false;
  }
}

static char body_to_tail(char c) {
  // TODO: Implement this function.
  char tail;
  switch (c)
  {
  case ('^'):
    tail ='w';
    break;
  case ('<'):
    tail = 'a';
    break;
  case ('>'):
    tail = 'd';
    break;
  case ('v'):
    tail = 's';
    break;
  default:
    tail = '0';
  }
  return tail;
}

static int incr_x(char c) {
  // TODO: Implement this function.
  if ((c=='>') || (c=='d')) {
    return 1;
  } else if ((c=='<') || (c=='a')) {
    return -1;
  } else {
    return 0;
  }
}

static int incr_y(char c) {
  if ((c=='^') || (c=='w')) {
    return -1;
  } else if ((c=='v') || (c=='s')) {
    return 1;
  } else {
    return 0;
  }
}

/* Task 4.2 */
static char next_square(game_state_t* state, int snum) {
  const unsigned int headx = state->snakes[snum].head_x;
  const unsigned int heady = state->snakes[snum].head_y;
  unsigned next_headx = headx + incr_x(get_board_at(state, headx, heady));
  unsigned next_heady = heady + incr_y(get_board_at(state, headx, heady));

  return get_board_at(state, next_headx, next_heady);
}

/* Task 4.3 */
static void update_head(game_state_t* state, int snum) {
  // TODO: Implement this function.
  unsigned int headx = state->snakes[snum].head_x;
  unsigned int heady = state->snakes[snum].head_y;
  char snakehead = get_board_at(state, headx, heady);
  state->snakes[snum].head_x = headx + incr_x(get_board_at(state, headx, heady));
  state->snakes[snum].head_y = heady + incr_y(get_board_at(state, headx, heady));
  set_board_at(state, state->snakes[snum].head_x, state->snakes[snum].head_y, snakehead);
  return;
}

/* Task 4.4 */
static void update_tail(game_state_t* state, int snum) {
  // TODO: Implement this function.
  unsigned int tailx = state->snakes[snum].tail_x;
  unsigned int taily = state->snakes[snum].tail_y;
  state->snakes[snum].tail_x = tailx + incr_x(get_board_at(state, tailx, taily));
  state->snakes[snum].tail_y = taily + incr_y(get_board_at(state, tailx, taily));
  char newtail = body_to_tail(get_board_at(state, state->snakes[snum].tail_x, state->snakes[snum].tail_y));
  set_board_at(state, tailx, taily, ' ');
  set_board_at(state, state->snakes[snum].tail_x, state->snakes[snum].tail_y, newtail);
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  // TODO: Implement this function.
  for (int i=0; i< state->num_snakes; i++) {
    char next_head = next_square(state, i);
    printf("id:%d, next:%c\n", i, next_head);
    if (next_head == '*') {
      update_head(state, i);
      add_food(state);
    }
    else if ((next_head == '#') || (is_snake(next_head))) {
      set_board_at(state, state->snakes[i].head_x, state->snakes[i].head_y, 'x');
      state->snakes[i].live = false;
    }
    else if (next_head == 'x') {
      ;
    }
    else {
      update_head(state, i);
      update_tail(state, i);
    }
  }
  return;
}

/* Task 5 */
game_state_t* load_board(char* filename) {
  // TODO: Implement this function.
  game_state_t* state = malloc(sizeof(struct game_state_t));

  FILE *file;
  file = fopen(filename, "r");
  char c;
  unsigned int xsize = 0;
  unsigned int ysize = 0;
  while (true)
  {
    c = fgetc(file);
    if ((ysize == 0) && (c!='\n')) {
      xsize = xsize + 1;
    }
    if (c=='\n') {
      ysize += 1;
    }

    if (c==EOF) {
      break;
    }
  }
  state->x_size = xsize;
  state->y_size = ysize;

  printf("boardsize: %d, %d\n", state->x_size, state->y_size);
  state->board = malloc(sizeof(char*) * state->y_size);
  for (int i=0; i<state->y_size; i++) {
    state->board[i] = malloc(sizeof(char) * state->x_size);
  }

  unsigned row_cnt = 0;
  unsigned col_cnt = 0;
  file = fopen(filename, "r");
  while (true)
  {
    c = fgetc(file);
    if (c==EOF) {
      break;
    }
    else {
      set_board_at(state, col_cnt, row_cnt, c);
      if (c == '\n') {
        row_cnt += 1;
        col_cnt = 0;   
      }
      else{
        col_cnt +=1;
      }
    }
  }
  return state;
}

/* Task 6.1 */
static void find_head(game_state_t* state, int snum) {
  // TODO: Implement this function.
  unsigned int tailx = 0;
  unsigned int taily = 0;
  char tailshape = ' ';
  switch (snum)
  {
  case (0):
    tailshape = 's';
    break;
  case (1):
    tailshape = 'd';
    break;
  case (2):
    tailshape = 'a';
    break;
  case (3):
    tailshape = 'w';
    break;
  default:
    tailshape = '0';
  }
  // printf("snaken: %d\n", state->num_snakes);
  for (int i=0; i<state->y_size; i++){
    for (int j=0; j<state->x_size; j++) {
      if (state->num_snakes == 1) {
        if (is_tail(state->board[i][j])) {
          tailx = j;
          taily = i;
          state->snakes[snum].tail_x = j;
          state->snakes[snum].tail_y = i;
        }
      }
      else {
        if (state->board[i][j] == tailshape) {
          tailx = j;
          taily = i;
          state->snakes[snum].tail_x = j;
          state->snakes[snum].tail_y = i;
        }
      }
    }
  }
  unsigned int body_x = tailx;
  unsigned int body_y = taily;
  unsigned int prev_body_x = tailx;
  unsigned int prev_body_y = taily;
  char body = get_board_at(state, state->snakes[snum].tail_x, state->snakes[snum].tail_y);
  while (is_snake(body))
  {
    prev_body_x = body_x;
    prev_body_y = body_y;
    body_x = incr_x(body) + body_x;
    body_y = incr_y(body) + body_y;
    body = get_board_at(state, body_x, body_y);
    // printf(" %d, %d, ", body_x, body_y);
    // printf("%c\n", body);
  }
  state->snakes[snum].head_x = prev_body_x;
  state->snakes[snum].head_y = prev_body_y;
  printf("id:%d, head:%d %d\n", snum, state->snakes[snum].head_x, state->snakes[snum].head_y);
  return;
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  // TODO: Implement this function.
  unsigned int snake_num = 0;
  for (int i=0; i<state->y_size; i++){
    for (int j=0; j<state->x_size; j++) {
      if (is_tail(state->board[i][j])) {
        snake_num += 1;
      }
    }
  }
  state->num_snakes = snake_num;
  state->snakes = malloc(sizeof(snake_t) * state->num_snakes);
  for (int i=0; i<state->num_snakes; i++) {
    find_head(state, i);
    if (get_board_at(state, state->snakes[i].head_x, state->snakes[i].head_y) != 'x') {
      state->snakes[i].live = true;
    }
    else {
      state->snakes[i].live = false;
    }
  }
  return state;
}
