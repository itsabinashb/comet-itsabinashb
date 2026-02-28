// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.15;

import "./IPriceFeed.sol";
import "./IERC20NonStandard.sol";
import "./CometMainInterface.sol";
import "./CometCore.sol";

/**
 * @title Compound's Asset List
 * @author Compound
 */
contract AssetList {
    /// @dev The decimals required for a price feed
    uint8 internal constant PRICE_FEED_DECIMALS = 8;

    /// @dev The scale for factors
    uint64 internal constant FACTOR_SCALE = 1e18;

    /// @dev The max value for a collateral factor (1)
    // q-1: Here collateral factor is 1e18, what does it mean by setting it to 1e18??
    uint64 internal constant MAX_COLLATERAL_FACTOR = FACTOR_SCALE;

    uint256 internal immutable asset00_a;
    uint256 internal immutable asset00_b;
    uint256 internal immutable asset01_a;
    uint256 internal immutable asset01_b;
    uint256 internal immutable asset02_a;
    uint256 internal immutable asset02_b;
    uint256 internal immutable asset03_a;
    uint256 internal immutable asset03_b;
    uint256 internal immutable asset04_a;
    uint256 internal immutable asset04_b;
    uint256 internal immutable asset05_a;
    uint256 internal immutable asset05_b;
    uint256 internal immutable asset06_a;
    uint256 internal immutable asset06_b;
    uint256 internal immutable asset07_a;
    uint256 internal immutable asset07_b;
    uint256 internal immutable asset08_a;
    uint256 internal immutable asset08_b;
    uint256 internal immutable asset09_a;
    uint256 internal immutable asset09_b;
    uint256 internal immutable asset10_a;
    uint256 internal immutable asset10_b;
    uint256 internal immutable asset11_a;
    uint256 internal immutable asset11_b;
    uint256 internal immutable asset12_a;
    uint256 internal immutable asset12_b;
    uint256 internal immutable asset13_a;
    uint256 internal immutable asset13_b;
    uint256 internal immutable asset14_a;
    uint256 internal immutable asset14_b;
    uint256 internal immutable asset15_a;
    uint256 internal immutable asset15_b;
    uint256 internal immutable asset16_a;
    uint256 internal immutable asset16_b;
    uint256 internal immutable asset17_a;
    uint256 internal immutable asset17_b;
    uint256 internal immutable asset18_a;
    uint256 internal immutable asset18_b;
    uint256 internal immutable asset19_a;
    uint256 internal immutable asset19_b;
    uint256 internal immutable asset20_a;
    uint256 internal immutable asset20_b;
    uint256 internal immutable asset21_a;
    uint256 internal immutable asset21_b;
    uint256 internal immutable asset22_a;
    uint256 internal immutable asset22_b;
    uint256 internal immutable asset23_a;
    uint256 internal immutable asset23_b;

    /// @notice The number of assets this contract actually supports
    uint8 public immutable numAssets;

    /**
    struct AssetConfig {
        address asset;
        address priceFeed;
        uint8 decimals;
        uint64 borrowCollateralFactor;
        uint64 liquidateCollateralFactor;
        uint64 liquidationFactor;
       
     */
    constructor(CometConfiguration.AssetConfig[] memory assetConfigs) {
        uint8 _numAssets = uint8(assetConfigs.length);
        numAssets = _numAssets;

        (asset00_a, asset00_b) = getPackedAssetInternal(assetConfigs, 0);
        (asset01_a, asset01_b) = getPackedAssetInternal(assetConfigs, 1);
        (asset02_a, asset02_b) = getPackedAssetInternal(assetConfigs, 2);
        (asset03_a, asset03_b) = getPackedAssetInternal(assetConfigs, 3);
        (asset04_a, asset04_b) = getPackedAssetInternal(assetConfigs, 4);
        (asset05_a, asset05_b) = getPackedAssetInternal(assetConfigs, 5);
        (asset06_a, asset06_b) = getPackedAssetInternal(assetConfigs, 6);
        (asset07_a, asset07_b) = getPackedAssetInternal(assetConfigs, 7);
        (asset08_a, asset08_b) = getPackedAssetInternal(assetConfigs, 8);
        (asset09_a, asset09_b) = getPackedAssetInternal(assetConfigs, 9);
        (asset10_a, asset10_b) = getPackedAssetInternal(assetConfigs, 10);
        (asset11_a, asset11_b) = getPackedAssetInternal(assetConfigs, 11);
        (asset12_a, asset12_b) = getPackedAssetInternal(assetConfigs, 12);
        (asset13_a, asset13_b) = getPackedAssetInternal(assetConfigs, 13);
        (asset14_a, asset14_b) = getPackedAssetInternal(assetConfigs, 14);
        (asset15_a, asset15_b) = getPackedAssetInternal(assetConfigs, 15);
        (asset16_a, asset16_b) = getPackedAssetInternal(assetConfigs, 16);
        (asset17_a, asset17_b) = getPackedAssetInternal(assetConfigs, 17);
        (asset18_a, asset18_b) = getPackedAssetInternal(assetConfigs, 18);
        (asset19_a, asset19_b) = getPackedAssetInternal(assetConfigs, 19);
        (asset20_a, asset20_b) = getPackedAssetInternal(assetConfigs, 20);
        (asset21_a, asset21_b) = getPackedAssetInternal(assetConfigs, 21);
        (asset22_a, asset22_b) = getPackedAssetInternal(assetConfigs, 22);
        (asset23_a, asset23_b) = getPackedAssetInternal(assetConfigs, 23);
    }

    /**
     * @dev Checks and gets the packed asset info for storage in 2 variables
     * - in first variable, the asset address is stored in the lower 160 bits (address can be interpreted as uint160),
     *      the borrow collateral factor in the next 16 bits,
     *      the liquidate collateral factor in the next 16 bits,
     *      and the liquidation factor in the next 16 bits
     * - in the second variable, the price feed address is stored in the lower 160 bits,
     *      the asset decimals in the next 8 bits,
     *      and the supply cap in the next 64 bits
     * @param assetConfigs The asset configurations
     * @param i The index of the asset info to get
     * @return The packed asset info

     struct AssetConfig {
        address asset;
        address priceFeed;
        uint8 decimals;
        uint64 borrowCollateralFactor;
        uint64 liquidateCollateralFactor;
        uint64 liquidationFactor;
        uint128 supplyCap;
    }
     */
    function getPackedAssetInternal(
        CometConfiguration.AssetConfig[] memory assetConfigs,
        uint i
    ) internal view returns (uint256, uint256) {
        CometConfiguration.AssetConfig memory assetConfig;
        if (i < assetConfigs.length) {
            assembly {
                // It is same as writing: assetConfig = assetConfigs[i];
                assetConfig := mload(add(add(assetConfigs, 0x20), mul(i, 0x20)))
            }
        } else {
            return (0, 0);
        }
        address asset = assetConfig.asset;
        address priceFeed = assetConfig.priceFeed;
        uint8 decimals_ = assetConfig.decimals;

        // Short-circuit if asset is nil
        if (asset == address(0)) {
            return (0, 0);
        }

        // Here priceFeed.decimals() means decimal of AggregatorV3Interface contract. The contract is here:
        // https://etherscan.io/address/0xa3eaec3ab66048e6f3cf23d81881a3fcd9a3d2ed#readContract#F4
        if (IPriceFeed(priceFeed).decimals() != PRICE_FEED_DECIMALS)
            revert CometMainInterface.BadDecimals();
        if (IERC20NonStandard(asset).decimals() != decimals_)
            revert CometMainInterface.BadDecimals();

        // BorrowCollateralFactor = How much of a collateral amount user can borrow.
        // For ex- collateralAmount = $1000, and collateralFactor = 80% so use can borrow = 1000 x 80% = $800
        // liquidationCollateralFactor = the LTV range after which a position will be liquidatable.
        // liquidationFactor = It tells us how much amount can be repaid by the protocol from the borroer's
        // account in the form of 'collateral deduction'.
        /**
        alice borrowed 800 usdc by depositing 1 eth as collateral (where 1 eth = 1000 usd and collateral factor 80% and liquidationCollateralFactor 90%). Now eth price drops to 700. So now LTV = 800/700 x 100 = 114%. As the LTV has crossed the 90% so it is liquidatable. 
        Now liquidationFactor = 95%. 
        Alice's collateral = $700 (now worth)
        Alice's debt = $800
        Now protocol seizing all of his collateral, i.e 1 eth == $700
        So, the recoverable amount from Alice's collateral = $700 x 95% = $665.
        So after recovering/repaying the Alice's debt now = $800 - $665 = $135

        This $135 will be denoted as bad debt. 

        So, now currently in account is $700 (1 eth) collateral and $135 bad debt. 
        Now protocol will sell this 1 eth ($700) with some discount. 
         */
        if (
            assetConfig.borrowCollateralFactor >=
            assetConfig.liquidateCollateralFactor
        ) revert CometMainInterface.BorrowCFTooLarge();
        /**
        Here we can see 1e18 is used as MAX_COLLATERAL_FACTOR and be confused that how it is working as
        collateral factor. So here Comound is using WAD scalling. i.e instead of using percentage or basis 
        point the protocol is using WAD (1e18) as unit of collateral factor. 
        Percentage =>>> 100% == 100, 80% == 80, 90% == 90
        Basis Point =>>> 100% == 10000, 80% == 8000, 90% == 9000
        WAD =>>> 100% == 1e18, 80% == 0.8 * 1e18, 90% == 0.9 * 1e18
            - These all are same. 
        For ex- 
        borrowCollateralFactor = 0.8 * 1e18 i.e 80% and collateralValue = 1000
        so, maxBorrow = collateralValue * 0.8 * 1e18 / 1e18 = 800
        We got 800 which is 80% of collateral.
         */
        if (assetConfig.liquidateCollateralFactor > MAX_COLLATERAL_FACTOR)
            revert CometMainInterface.LiquidateCFTooLarge();

        unchecked {
            // Keep 4 decimals for each factor
            // descale = 1e18 / 1e4 = 1e14
            uint64 descale = FACTOR_SCALE / 1e4;
            // Lets assume borrowCollateralFactor = 80% = 0.8 * 1e18
            // so, borrowCollateralFactor = 0.8 * 1e18 / 1e14 = 8000
            uint16 borrowCollateralFactor = uint16(
                assetConfig.borrowCollateralFactor / descale
            );
            // Lets assume liquidateCollateralFactor = 90% = 0.9 * 1e18
            // so, liquidateCollateralFactor = 0.9 * 1e18 / 1e14 = 9000
            uint16 liquidateCollateralFactor = uint16(
                assetConfig.liquidateCollateralFactor / descale
            );
            // Lets assume liquidationFactor = 95% = 0.95 * 1e18
            // so, liquidationFactor = 0.95 * 1e18 / 1e14 = 9500
            uint16 liquidationFactor = uint16(
                assetConfig.liquidationFactor / descale
            );

            // Be nice and check descaled values are still within range
            if (borrowCollateralFactor >= liquidateCollateralFactor)
                revert CometMainInterface.BorrowCFTooLarge();

            // Keep whole units of asset for supply cap
            uint64 supplyCap = uint64(
                // when assetConfig.supplyCap is passed it is passed as with extra 10**6, means if we 
                // wanna set it to 1000 USDC then it will be 1000 * 10**6. So by dividing by 10**6 we are 
                // setting it to exactly 1000
                assetConfig.supplyCap / (10 ** decimals_)
            );
            
            /**
            struct AssetConfig {
                address asset;
                address priceFeed;
                uint8 decimals;
                uint64 borrowCollateralFactor;
                uint64 liquidateCollateralFactor;
                uint64 liquidationFactor;
                uint128 supplyCap;
            }

            the AssetConfig struct has 7 fields, here 4 of them is packed in a 256 bit variable and rest 
            3 are packed in another 256 bit variable. So here we are holding the whole struct into only two uint256. 

            word_a => 
            uint160(asset) << 0 => bits 0 - 159 
            uint256(borrowCollateralFactor) << 160 => bits 160 - 175
            uint256(liquidateCollateralFactor) << 176 => bits 176 - 191
            uint256(liquidationFactor) << 192 => bits 192 - 207 

            word_b => 
            uint160(priceFeed) << 0 => bits 0 - 159
            uint256(decimals_) << 160 => bits 160 - 167
            uint256(supplyCap) << 168 => bits 168 - 231
             */
            uint256 word_a = ((uint160(asset) << 0) |
                (uint256(borrowCollateralFactor) << 160) |
                (uint256(liquidateCollateralFactor) << 176) |
                (uint256(liquidationFactor) << 192));
            uint256 word_b = ((uint160(priceFeed) << 0) |
                (uint256(decimals_) << 160) |
                (uint256(supplyCap) << 168));

            return (word_a, word_b);
        }
    }

    /**
     * @notice Get the i-th asset info, according to the order they were passed in originally
     * @param i The index of the asset info to get
     * @return The asset info object
     */
    function getAssetInfo(
        uint8 i
    ) public view returns (CometCore.AssetInfo memory) {
        if (i >= numAssets) revert CometMainInterface.BadAsset();
        uint256 word_a;
        uint256 word_b;
        if (i == 0) {
            word_a = asset00_a;
            word_b = asset00_b;
        }
        if (i == 1) {
            word_a = asset01_a;
            word_b = asset01_b;
        }
        if (i == 2) {
            word_a = asset02_a;
            word_b = asset02_b;
        }
        if (i == 3) {
            word_a = asset03_a;
            word_b = asset03_b;
        }
        if (i == 4) {
            word_a = asset04_a;
            word_b = asset04_b;
        }
        if (i == 5) {
            word_a = asset05_a;
            word_b = asset05_b;
        }
        if (i == 6) {
            word_a = asset06_a;
            word_b = asset06_b;
        }
        if (i == 7) {
            word_a = asset07_a;
            word_b = asset07_b;
        }
        if (i == 8) {
            word_a = asset08_a;
            word_b = asset08_b;
        }
        if (i == 9) {
            word_a = asset09_a;
            word_b = asset09_b;
        }
        if (i == 10) {
            word_a = asset10_a;
            word_b = asset10_b;
        }
        if (i == 11) {
            word_a = asset11_a;
            word_b = asset11_b;
        }
        if (i == 12) {
            word_a = asset12_a;
            word_b = asset12_b;
        }
        if (i == 13) {
            word_a = asset13_a;
            word_b = asset13_b;
        }
        if (i == 14) {
            word_a = asset14_a;
            word_b = asset14_b;
        }
        if (i == 15) {
            word_a = asset15_a;
            word_b = asset15_b;
        }
        if (i == 16) {
            word_a = asset16_a;
            word_b = asset16_b;
        }
        if (i == 17) {
            word_a = asset17_a;
            word_b = asset17_b;
        }
        if (i == 18) {
            word_a = asset18_a;
            word_b = asset18_b;
        }
        if (i == 19) {
            word_a = asset19_a;
            word_b = asset19_b;
        }
        if (i == 20) {
            word_a = asset20_a;
            word_b = asset20_b;
        }
        if (i == 21) {
            word_a = asset21_a;
            word_b = asset21_b;
        }
        if (i == 22) {
            word_a = asset22_a;
            word_b = asset22_b;
        }
        if (i == 23) {
            word_a = asset23_a;
            word_b = asset23_b;
        }

        address asset = address(uint160(word_a & type(uint160).max));
        uint64 rescale = FACTOR_SCALE / 1e4;
        uint64 borrowCollateralFactor = uint64(
            ((word_a >> 160) & type(uint16).max) * rescale
        );
        uint64 liquidateCollateralFactor = uint64(
            ((word_a >> 176) & type(uint16).max) * rescale
        );
        uint64 liquidationFactor = uint64(
            ((word_a >> 192) & type(uint16).max) * rescale
        );

        address priceFeed = address(uint160(word_b & type(uint160).max));
        uint8 decimals_ = uint8(((word_b >> 160) & type(uint8).max));
        uint64 scale = uint64(10 ** decimals_);
        uint128 supplyCap = uint128(
            ((word_b >> 168) & type(uint64).max) * scale
        );

        return
            CometCore.AssetInfo({
                offset: i,
                asset: asset,
                priceFeed: priceFeed,
                scale: scale,
                borrowCollateralFactor: borrowCollateralFactor,
                liquidateCollateralFactor: liquidateCollateralFactor,
                liquidationFactor: liquidationFactor,
                supplyCap: supplyCap
            });
    }
}
