class_name ModifyTarrifsDecision
extends Decision

@export var all_tarrifs: bool = false;
@export var tarrifs: Array[String];

@export var random_range: Vector2 = Vector2(1., 2.);

func execute(country: Country) -> void:
	if all_tarrifs:
		for tarrif in country.tarrifs:
			country.tarrifs[tarrif] += randf_range(random_range.x, random_range.y);
	else:
		for tarrif in tarrifs:
			if !country.tarrifs.has(tarrif): continue;
			country.tarrifs[tarrif] += randf_range(random_range.x, random_range.y);
