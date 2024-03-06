// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LicenseContract {
    // Struct to represent a license
    struct License {
        uint256 licenseId;
        string fullName;
        string fatherName;
        uint256 dob;  // Date of Birth
        uint256 validDate;
        string dlNo;  // Driving License Number
        string cov;   // Class of Vehicle
        string addr;  // Change 'address' to 'addr'
        string phoneNumber;
    }

    mapping(uint256 => License) public licenses;  // Mapping from licenseId to License
    mapping(bytes32 => uint256) public hashToLicenseId;  // Mapping from hash to licenseId
    mapping(string => uint256) public phoneToLicenseId;  // Mapping from phoneNumber to licenseId
    uint256[] public licenseIdsArray;  // Array to store license IDs

    // Function to create a new license
    function createLicense(
        uint256 _licenseId,
        string memory _fullName,
        string memory _fatherName,
        uint256 _dob,
        uint256 _validDate,
        string memory _dlNo,
        string memory _cov,
        string memory _addr,  // Change 'address' to 'addr'
        string memory _phoneNumber
    ) external {
        License memory newLicense = License({
            licenseId: _licenseId,
            fullName: _fullName,
            fatherName: _fatherName,
            dob: _dob,
            validDate: _validDate,
            dlNo: _dlNo,
            cov: _cov,
            addr: _addr,  // Change 'address' to 'addr'
            phoneNumber: _phoneNumber
        });

        licenses[_licenseId] = newLicense;
        licenseIdsArray.push(_licenseId);
        
        // Generate hash using keccak256 for the license details
        bytes32 hash = keccak256(abi.encodePacked(_fullName, _fatherName, _dob, _validDate, _dlNo, _cov, _addr, _phoneNumber));  // Change 'address' to 'addr'
        
        // Map the hash to the licenseId
        hashToLicenseId[hash] = _licenseId;
        
        // Map the phoneNumber to the licenseId
        phoneToLicenseId[_phoneNumber] = _licenseId;
    }

    // Function to list all licenses with licenseId, full name, and hash
    function listLicenses() external view returns (uint256[] memory, string[] memory, bytes32[] memory) {
        uint256 arrayLength = licenseIdsArray.length;
        uint256[] memory licenseIds = new uint256[](arrayLength);
        string[] memory fullNames = new string[](arrayLength);
        bytes32[] memory hashes = new bytes32[](arrayLength);

        for (uint256 i = 0; i < arrayLength; i++) {
            uint256 licenseId = licenseIdsArray[i];
            License memory license = licenses[licenseId];
            
            licenseIds[i] = license.licenseId;
            fullNames[i] = license.fullName;
            // Generate hash using keccak256 for the license details
            hashes[i] = keccak256(abi.encodePacked(license.fullName, license.fatherName, license.dob, license.validDate, license.dlNo, license.cov, license.addr, license.phoneNumber));
        }

        return (licenseIds, fullNames, hashes);
    }

    // Function to get license information using hash
    function getLicenseByHash(bytes32 _hash) external view returns (uint256, string memory, string memory, uint256, uint256, string memory, string memory, string memory, string memory) {
        uint256 licenseId = hashToLicenseId[_hash];
        return getLicenseDetails(licenseId);
    }

    // Function to get license information using licenseId
    function getLicenseById(uint256 _licenseId) external view returns (uint256, string memory, string memory, uint256, uint256, string memory, string memory, string memory, string memory) {
        return getLicenseDetails(_licenseId);
    }

    // Function to get license information using phone number
    function getLicenseByPhoneNumber(string memory _phoneNumber) external view returns (uint256, string memory, string memory, uint256, uint256, string memory, string memory, string memory, string memory) {
        uint256 licenseId = phoneToLicenseId[_phoneNumber];
        return getLicenseDetails(licenseId);
    }

    // Helper function to get license details
    function getLicenseDetails(uint256 _licenseId) internal view returns (
        uint256, string memory, string memory, uint256, uint256, string memory, string memory, string memory, string memory
    ) {
        License memory license = licenses[_licenseId];
        return (
            license.licenseId,
            license.fullName,
            license.fatherName,
            license.dob,
            license.validDate,
            license.dlNo,
            license.cov,
            license.addr,
            license.phoneNumber
        );
    }
}
