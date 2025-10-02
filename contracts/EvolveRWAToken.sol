// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ComplianceRegistry.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title EvolveRWAToken
 * @dev Un token ERC-20 que hereda y aplica las reglas de cumplimiento.
 * Simula el requisito de RWA donde las transferencias deben ser verificadas.
 */
contract EvolveRWAToken is ERC20 {
    // Dirección del contrato de ComplianceRegistry implementado.
    ComplianceRegistry public complianceRegistry;

    // Parámetros del token
    string private constant TOKEN_NAME = "Evolve RWA Token";
    string private constant TOKEN_SYMBOL = "EVOLVE";

    // Constructor que requiere la dirección del ComplianceRegistry
    constructor(address _complianceRegistryAddress) ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        // Asignar la dirección del contrato de cumplimiento
        complianceRegistry = ComplianceRegistry(_complianceRegistryAddress);

        // MINT inicial de tokens (ej. a la dirección de despliegue)
        _mint(msg.sender, 10000 * (10 ** decimals())); // Mintear 10,000 tokens iniciales
    }

    /**
     * @dev Sobreescribe la función _transfer de ERC20.
     * Aplica la verificación de cumplimiento ANTES de ejecutar la transferencia.
     * * Solo las direcciones 'from' que son compliant pueden iniciar una transferencia.
     */
    function _transfer(address from, address to, uint256 amount) internal override {
        // --- Aplicación del Modificador de Seguridad RWA ---
        require(complianceRegistry.getComplianceStatus(from), 
            "ERWA: El emisor no cumple con la lista blanca (Compliance check failed)."
        );
        // ----------------------------------------------------
        
        // Ejecución de la transferencia ERC-20 estándar
        super._transfer(from, to, amount);
    }

    // Nota: Las funciones 'transfer' y 'transferFrom' llaman internamente a '_transfer', 
    // por lo que el chequeo de compliance se aplica automáticamente.
}

// Nota: Para compilar esto, también necesitarías el contrato ERC20 de OpenZeppelin.
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Por simplicidad, asumimos que este archivo está disponible.
