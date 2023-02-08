// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

// String Utils v0.1

/// @title String Utils - String utility functions
/// @author Piper Merriam - <pipermerriam@gmail.com>
library StringLib {
    /// @dev Converts an unsigned integer to its string representation.
    /// @param v The number to be converted.
    function uintToBytes(uint v) public pure returns (bytes32 ret) {
        if (v == 0) {
            ret = '0';
        }
        else {
            while (v > 0) {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }

    /// @dev Converts a numeric string to it's unsigned integer representation.
    /// @param v The string to be converted.
    function bytesToUInt(bytes32 v) public pure returns (uint ret) {
        require(v != 0x0, "StringLib.bytesToUInt: != 0x0");

        uint digit;

        for (uint i = 0; i < 32; i++) {
            digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
            if (digit == 0) {
                break;
            }
            else if (digit < 48 || digit > 57) {
                require(digit >= 48 && digit <= 57,"StringLib.bytesToUInt: digit < 48 || digit > 57");
            }
            ret *= 10;
            ret += (digit - 48);
        }
        return ret;
    }

    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}


/// @title String Utils - String utility functions
/// @author Piper Merriam - <pipermerriam@gmail.com>
library StringUtils {
    /// @dev Converts an unsigned integert to its string representation.
    /// @param v The number to be converted.
    function uintToBytes(uint v) public pure returns (bytes32 ret) {
            return StringLib.uintToBytes(v);
    }

    /// @dev Converts a numeric string to it's unsigned integer representation.
    /// @param v The string to be converted.
    function bytesToUInt(bytes32 v) public pure returns (uint ret) {
            return StringLib.bytesToUInt(v);
    }

    function uintToString(uint v) public pure returns (string memory s) {
        bytes32 b = StringLib.uintToBytes(v);
        return StringLib.bytes32ToString(b);
    }
}