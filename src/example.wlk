class Entrenador{
	var property pokemones()
}

class Pokemon{
	var vida
	var ataques = []
	var defensa
	var property estado
	var velocidad
	var poder
	method aprender(ataque){
		if(ataques.any({att => att == ataque})){
			throw new Exception("Ya conoce ese ataque")
		}
		if(ataques.size() >= 4){
			ataques.remove(ataques.anyOne())
		}		
		ataques.add(ataque)	
	}
	method atacar(enemigo, ataque){
		estado.atacar(self,enemigo,ataque)
		
	}
	method defender(ataque){
		 self.recibirDanio(ataque.danio(self) - defensa * 0.1)
		 ataque.atacar(self)
	}
	method recibirDanio(danio){
		vida =- danio
	}
	method vida(){
		return vida
	}
	method velocidad(){
		return velocidad
	}
	method poder(){
		return poder
	}
	method ataques(){
		return ataques
	}
}

class Estado{
	method atacar (atacante,victima,ataque){
		victima.defender(ataque)	
		self.efecto(atacante, victima)
	}
	method efecto(pokemon, enemigo){
	}	
}

object saludable inherits Estado{
	method aplicarEfecto(pokemon){
		pokemon.estado(self)
	}
}

class Paralizado inherits Estado{
	var grado
	constructor(_grado){
		grado = _grado
	}	
	override method efecto(pokemon, enemigo){
		grado--
	}
	method puedeAtacar(){
		return grado>0
	}
	override method atacar (atacante,victima,ataque){
		if(self.puedeAtacar()){
		super(atacante,victima,ataque)
		}
	}
}

object envenenado inherits Estado{
	override method efecto(pokemon, enemigo){
		pokemon.recibirDanio(pokemon.vida()*0.1)
	}
}

object veneno{
	method atacar(enemigo){
		self.aplicarEfecto(enemigo)
	}
	method aplicarEfecto(pokemon){
		pokemon.estado(envenenado)
	}
	method danio(pokemon){
		return 0
	}
}

object atactrueno{
	method atacar(enemigo){
		self.aplicarEfecto(enemigo)
	}
	method aplicarEfecto(pokemon){
		if(0.randomUpTo(1) <= 0.5){
			pokemon.estado(new Paralizado(5))
		}
	}
	method danio(pokemon){
		return pokemon.velocidad() 
	}
}

object placaje{
	method atacar(enemigo){
	}
	method aplicarEfecto(pokemon){
	}
	method danio(pokemon){
		return pokemon.poder() 
	}
}

object pelea{
	var pokemones1
	var pokemones2  
	method pelear(entrenador1, entrenador2){
		pokemones1 = entrenador1.pokemones()
		pokemones2 = entrenador2.pokemones()
		self.lucha(pokemones1.first(), pokemones2.first())
	}
	method lucha(pokemon1, pokemon2){
		if(pokemon1.vida()>0){
		self.atacar(pokemon1, pokemon2)
		}
		else {
			pokemones1.remove(pokemon1)
			self.lucha(self.swap(pokemones1),pokemon2)
			}
		self.lucha(pokemon2,pokemon1)
	}
	method atacar(pokemon1, pokemon2){
		pokemon1.atacar(pokemon2, pokemon1.ataques().anyOne())
		}

	method swap(pokemones){
		return pokemones.anyOne()
	}
}