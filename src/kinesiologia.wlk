// Nota: 8 ocho
//Test: MB
//1: MB
//2: B+ (cuidado con los nombres, algunso detalles tećnicos)
//3: B+ (problema de responsabilidad en las validaciones)
//4: MB-

class Centro{
	var pacientes=#{}
	//TODO: Por que es una lista y no un conjunto?
	var aparatos=[]
	
	method coloresDeAparatos()= aparatos.map({maq=>maq.color()}).asSet()
	
	//TODO: El asSet es innecesario, ya que tus pacientes son un conjunto.
	method pacientesMenoresA8()=pacientes.filter({paciente=>paciente.edad()<8}).asSet()
	
	method pacientesQnoPuedenComplirConSuSecion()= pacientes.count({paciente=>paciente.puedeUsarTodo().negate()})
}



class PacienteNormal {

	var property edad = null
	var property dolor = null
	var property fortaleza = null
	var property rutina = null

	method puedeUsar(unaMaquina) = unaMaquina.puedeSerUsadoPor(self)

//TODO: mejorar nombre: significa que puede usar la secion
	method puedeUsarTodo() = rutina.all({ maq => self.puedeUsar(maq) })

	method hacerSecion() {
	//TODO debería validar que puedeUsarTodo para evitar aplicar efecto en una máquina que sí podía usar antes de
	//darse cuenta que no podía hacer toda la sesion		
		rutina.forEach({ maq => self.usarMaquina(maq)})
	}

//TODO: Esto es una orden, por lo tanto no tiene que devolver nada. Esta notación es como poner {return xxx}
	method usarMaquina(unaMaquina) = if (self.puedeUsar(unaMaquina)) unaMaquina.esUsadoPor(self) else self.error("no puede usarlo")

//TODO: Mejorar el nombre: "Calculo de" no significa nada, incluso suena a que es una pregunta
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
		//TODO: tenés un método "calculoDeFortaleza" que incrementa la fortaleza. Deberias usarlo.
		fortaleza = fortaleza + rutina.size()
	}

}

class PacienteCaprichoso inherits PacienteNormal {

	method alMenosUnaDeColorRojo() = rutina.any({ maq => maq.color() == "rojo" })

//TODO: Esta vaidación adicional tiene que ser a nivel de sesión, no de máquina.
//Un paciente puede utilizar una máquina independientemente de las demas

	override method puedeUsar(unaMaquina) = super(unaMaquina) and self.alMenosUnaDeColorRojo()

	override method hacerSecion() {
		super()
		super()
	}

}
object puntos{
	var property num = 3
	//TODO: Si num es una property no hace falta un método config, porque es igual al setter
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
	//TODO: Mejorar nombre. modificar dolor parece una orden pero es una pregunta
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