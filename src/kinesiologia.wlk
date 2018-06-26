class Centro{
	var pacientes=#{}
	var aparatos=[]
	
	method coloresDeAparatos()= aparatos.map({maq=>maq.color()}).asSet()
	method pacientesMenoresA8()=pacientes.filter({paciente=>paciente.edad()<8}).asSet()
	method pacientesQnoPuedenComplirConSuSecion()= pacientes.count({paciente=>paciente.puedeUsarTodo().negate()})
}



class PacienteNormal {

	var property edad = null
	var property dolor = null
	var property fortaleza = null
	var property rutina = null

	method puedeUsar(unaMaquina) = unaMaquina.puedeSerUsadoPor(self)

	method puedeUsarTodo() = rutina.all({ maq => self.puedeUsar(maq) })

	method hacerSecion() {
		rutina.forEach({ maq => self.usarMaquina(maq)})
	}

	method usarMaquina(unaMaquina) = if (self.puedeUsar(unaMaquina)) unaMaquina.esUsadoPor(self) else self.error("no puede usarlo")

	method calculoDeDolor(num) {
		dolor = dolor - num
	}

	method calculoDeFortaleza(num) {
		fortaleza = fortaleza + num
	}

}

class PacienteResistente inherits PacienteNormal {

	override method hacerSecion() {
		super()
		fortaleza = fortaleza + rutina.size()
	}

}

class PacienteCaprichoso inherits PacienteNormal {

	method alMenosUnaDeColorRojo() = rutina.any({ maq => maq.color() == "rojo" })

	override method puedeUsar(unaMaquina) = super(unaMaquina) and self.alMenosUnaDeColorRojo()

	override method hacerSecion() {
		super()
		super()
	}

}
object puntos{
	var property num = 3
	method config(n){
		num=n
	}
}

class PacienteRapido inherits PacienteNormal {


	override method hacerSecion(){
		super()
		self.calculoDeDolor(puntos.num())
	}

}


class Maquina{
	var property color="Blanco"
	method puedeSerUsadoPor(unPaciente)
	method esUsadoPor(unPaciente)
}


class Magneto inherits Maquina{
	override method puedeSerUsadoPor(unPaciente)=true
	method modificarDolor(unPaciente)= unPaciente.dolor()*0.1
	override method esUsadoPor(unPaciente){
		unPaciente.calculoDeDolor(self.modificarDolor(unPaciente))
	}
}

class Bicicleta inherits Maquina{

	override method puedeSerUsadoPor(unPaciente)= unPaciente.edad()>8
	method modificarDolor(unPaciente)= 4
	method modificarFortaleza(unPaciente)= 3
	override method esUsadoPor(unPaciente){
		unPaciente.calculoDeDolor(self.modificarDolor(unPaciente))
		unPaciente.calculoDeFortaleza(self.modificarFortaleza(unPaciente))
	}
	
	
}

class Minitrap inherits Maquina{
	override method puedeSerUsadoPor(unPaciente)= unPaciente.dolor()<20
	method modificarFortaleza(unPaciente)= (unPaciente.edad()*0.1)
	override method esUsadoPor(unPaciente){
		unPaciente.calculoDeFortaleza(self.modificarFortaleza(unPaciente))
	}
}