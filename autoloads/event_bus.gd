extends Node

# Country shit
signal player_country_created(country: Country);

# Time stuff
signal time_changed(time: int);
signal set_time(time: int);
signal set_time_speed(speed: float);
signal pause_time;
signal resume_time;
signal toggle_time;
