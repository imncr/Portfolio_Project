/*
Cleaning Data in SQL
*/


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;


------------------------------------------------------------------------------------------------------------------------
-- Alter Date Format
-- Currently date time, however time is never populated

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate Date;


------------------------------------------------------------------------------------------------------------------------
-- Populate Missing Property Address Data
-- Matching ParcelIDs have the same address

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT ParcelID, PropertyAddress 
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID;

SELECT h1.ParcelID, h1.PropertyAddress, h2.ParcelID, h2.PropertyAddress, ISNULL(h1.PropertyAddress, h2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS h1
JOIN PortfolioProject.dbo.NashvilleHousing AS h2
	on h1.ParcelID = h2.ParcelID
	AND h1.[UniqueID ] <> h2.[UniqueID ]
WHERE h1.PropertyAddress IS NULL;

UPDATE h1
SET PropertyAddress = ISNULL(h1.PropertyAddress, h2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS h1
JOIN PortfolioProject.dbo.NashvilleHousing AS h2
	on h1.ParcelID = h2.ParcelID
	AND h1.[UniqueID ] <> h2.[UniqueID ]
WHERE h1.PropertyAddress IS NULL;


------------------------------------------------------------------------------------------------------------------------
-- Separating Address into Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM PortfolioProject.dbo.NashvilleHousing;



SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

SELECT OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing;


------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in SoldAsVacant field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END;


------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates
-- Meant to show ability, should not be done in all cases

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS RowNum
FROM PortfolioProject.dbo.NashvilleHousing)

DELETE
FROM RowNumCTE
WHERE RowNum > 1;

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS RowNum
FROM PortfolioProject.dbo.NashvilleHousing)

SELECT *
FROM RowNumCTE
WHERE RowNum > 1;


------------------------------------------------------------------------------------------------------------------------
-- Remove Unused Columns
-- Meant to show ability, should not be done in all cases

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;


