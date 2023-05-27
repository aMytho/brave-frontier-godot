extends Resource
class_name CharEquipment

# The name of the equipment (sword, effect, a nice hat). Must correspond to its animation name!
@export var name: String = ""
# Every equipment must define its frames
@export var frames: Array[EquipmentFrame] = []
