// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Estudiante {
    string private _nombre;
    string private _apellido;
    string private _curso;
    mapping(uint8 => string) private _materias;
    mapping(uint8 => mapping(string => uint8)) private _notas_materias; //Bimestre => Materia => Nota
    uint8 private _cant_mat = 0;
    mapping (address => bool) _docentes;
    constructor(
        string memory nombre_, 
        string memory apellido_, 
        string memory curso_
        ){
            _nombre = nombre_;
            _apellido = apellido_;
            _curso = curso_;
            _docentes[msg.sender] = true;
        }

    modifier es_docente(){
        require(_docentes[msg.sender], "No sos docente");
        _;
    }

    event nueva_nota(uint8 bimestre, string materia, uint8 nota);

    function agregar_docente(address nuevo_docente_) public es_docente {
        _docentes[nuevo_docente_] = true;
    }

    function agregar_materia(string memory _materia) public es_docente {
       _materias[_cant_mat] = _materia;
       _cant_mat++;
    }

    function set_nota_materia(uint8 nota_, string memory materia_, uint8 bimestre_) public es_docente{
        require(nota_ > 0 && nota_ <101, "Tu nota no es valida");
        _notas_materias[bimestre_][materia_] = nota_;
        emit nueva_nota(bimestre_, materia_, nota_);
    }

    //View functions
    function apellido() public view returns (string memory){
        return _apellido;
    }

    function nombre_completo() public view returns(string memory){
        string memory nc = string(abi.encodePacked(_nombre," ",_apellido));
        return nc;
    }

    function curso() public view returns(string memory){
        return _curso;
    }


    function nota_materia(string memory materia_, uint8 bimestre_) public view returns(uint8){
        return _notas_materias[bimestre_][materia_];
    }

    function aprobo(string memory materia_, uint8 bimestre_) public view returns(bool){
        return (_notas_materias[bimestre_][materia_] > 60);
    }

    function promedio(uint8 bimestre_) public view returns(uint8){
        uint8 _promedio = 0;
        for(uint8 i =0;i<_cant_mat;i++){
            _promedio += _notas_materias[bimestre_][_materias[i]];
        }
        _promedio /= _cant_mat;
        return _promedio;
    }
}