pragma solidity >=0.4.22 <0.6.0;

contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;//variable que indica la cantidad maxima de tokens para las personas que vean mi contrato
    mapping (address => uint256) public balanceOf;//tipo de dato que alamacena claves publicas y balances de tokens
    
    event Transfer(address from, address to, uint256 value);//disparador que detecta una transaccion crea un log y notifica que se realizo, los parametros indican de donde se envio, a donde se envio y cuanto se envio
    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {// constructor del contrato para este ejemplo estoy utilizando 3 parametros el primero crea mi cantidad de tokens iniciales y los dos siguientes se encargan de la creacion del nombre y el simbolo del token
        totalSupply = initialSupply * 10 ** uint256(decimals);//conectamos la variable con el parametro y hacemos una potencia con decimals pues el numero con el que se almacenan los tokens esta en formato decimal entonces de esta manera se convierte a entero
        name = tokenName;
        symbol = tokenSymbol;
        balanceOf[msg.sender] = totalSupply;//asigna los tokens al creador del contrato
    }
    
    function _transfer(address _from, address _to, uint _value) internal {//funcion que realiza la transferecia del token creado
        require(balanceOf[_from] >= _value);//aca realizo una validacion de seguridad permitiendo la operacion si el balance del que envia es mayor a la cantidad que envia
        require(balanceOf[_to] + _value >= balanceOf[_to]);//aca se requiere que el que envia tenga mas saldo que el que recibe para que no hayan saldos negativos
        uint previusBalances = balanceOf[_from] + balanceOf[_to];//aca almacenamos los balances antes de modificarlos
        balanceOf[_from] -= _value;//le resto al que envia 
        balanceOf[_to] += _value;//y se lo sumo al que recibe
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previusBalances); assercion que verifica que compara los balances que almacenamos que coincida la suma con los nuevos saldos para evitar fugas o perdidas en nuestro contrato
    }
    
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
}
interface TokenERC20Interface{
      function transfer(address _to, uint256 _value) external;//Este espacio es para definir funciones comunes que deseo implementar de otros contratos ya creados  
}
    
contract BasicContrat {
        
        function transferToken() public {//inicializa interfaz del contrato basicContrat
            TokenERC20Interface token = TokenERC20Interface(0x174751cc7D172f649092b3Fe045EAbf2C44aFa37);//aca vemos el tipo de dato almacenado en la variable token como parametro le asigno la direccion de contrato del que quiero extraer la funcion que necesito
            token.transfer(0x174751cc7D172f649092b3Fe045EAbf2C44aFa37, 200000000000000000000);//aca ejecuto la funcion del contrato externo que quiero utilizar
        }
}
