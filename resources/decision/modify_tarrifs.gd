class_name ModifyTarrifsDecision
extends Decision

@export var all_tarrifs: bool = false;
@export var tarrifs: Array[String];

@export var random_range: Vector2 = Vector2(1., 2.);

func execute(country: Country) -> void:
	var tarrif_modification = Utils.truncate(randf_range(random_range.x, random_range.y), 2);
	if all_tarrifs:
		for tarrif in country.tarrifs:
			country.tarrifs[tarrif] += tarrif_modification;
		print("Applied tarrifs: " + str(tarrif_modification) + ", on all goods");
	else:
		for tarrif in tarrifs:
			if !country.tarrifs.has(tarrif): continue;
			country.tarrifs[tarrif] += tarrif_modification;
	print("Applied tarrifs: " + str(tarrif_modification) + ", on: " + Utils.join_array(tarrifs, ", "));
