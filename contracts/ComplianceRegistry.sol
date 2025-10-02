// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ComplianceRegistry
 * @dev Contrato de registro de cumplimiento (KYC/AML Whitelisting).
 * Simula la capa de Soberanía/Sequencer en la Evolve RWA Chain.
 */
contract ComplianceRegistry {
    // Mapeo para rastrear si una dirección es "compliant" (cumple con la lista blanca).
    mapping(address => bool) private isCompliant;

    // Dirección del administrador o 'Sequencer' que tiene autoridad para ajustar el cumplimiento.
    address public sequencerAddress;

    // Eventos para notificar cambios de estado
    event ComplianceStatusUpdated(address indexed user, bool status);

    constructor() {
        // Establece la dirección que despliega el contrato como el Sequencer/Admin inicial.
        sequencerAddress = msg.sender;
    }

    /**
     * @dev Modificador que restringe el acceso solo a la dirección del Sequencer.
     */
    modifier onlySequencer() {
        require(msg.sender == sequencerAddress, "CRC: Solo el Sequencer puede ejecutar.");
        _;
    }

    /**
     * @dev Modificador que asegura que la dirección que interactúa está en la lista blanca.
     */
    modifier onlyCompliant(address _addr) {
        require(isCompliant[_addr], "CRC: La direccion no cumple (no whitelisted).");
        _;
    }

    /**
     * @notice Permite al Sequencer establecer o revocar el estado de cumplimiento de una dirección.
     * @param _user La dirección del usuario a actualizar.
     * @param _status El nuevo estado de cumplimiento (true para whitelisted).
     */
    function setComplianceStatus(address _user, bool _status) public onlySequencer {
        require(isCompliant[_user] != _status, "CRC: El estado ya es el solicitado.");
        isCompliant[_user] = _status;
        emit ComplianceStatusUpdated(_user, _status);
    }

    /**
     * @notice Consulta el estado de cumplimiento de una dirección.
     * @param _addr La dirección a verificar.
     * @return bool True si la dirección está en la lista blanca.
     */
    function getComplianceStatus(address _addr) public view returns (bool) {
        return isCompliant[_addr];
    }
}
