// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Estudiante {
    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    mapping(string => uint8) private notas_materias;
    mapping (uint8 => string) private _materias;
    uint8 private _cant_mat = 0;

    constructor(
        string memory nombre_, 
        string memory apellido_, 
        string memory curso_
        ){
            _nombre = nombre_;
            _apellido = apellido_;
            _curso = curso_;
            _docente = msg.sender;
        }

    modifier es_docente(){
        require(msg.sender == _docente, "No sos docente");
        _;
    }


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

    function set_nota_materia(uint8 nota_, string memory materia_) public es_docente{
        require(nota_ > 0 && nota_ <101, "Tu nota no es valida");
        notas_materias[materia_] = nota_;
    }

    function nota_materia(string memory _materia) public view returns(uint8){
        return notas_materias[_materia];
    }

    function agregar_materia(string memory _materia) public es_docente {
       _materias[_cant_mat] = _materia;
       _cant_mat++;
    }

    function aprobo(string memory _materia) public view returns(bool){
        return (notas_materias[_materia] > 60);
    }



    function promedio() public view returns(uint8){
        uint8 promedio = 0;
        for(uint8 i =0;i<_cant_mat;i++){
            promedio += notas_materias[_materias[i]];
        }
        promedio /= _cant_mat;
        return promedio;
    }
}