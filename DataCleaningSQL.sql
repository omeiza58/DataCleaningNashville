SELECT *
FROM PortfolioProject..NashvilleProject

--standardise SaleDate Format

Select SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleProject

 SELECT CAST(SaleDate as date)
 FROM PortfolioProject..NashvilleProject
 
 
------------------------------------------------------------------------------------------------------------------------------

--Removing the time from dataetime

Update PortfolioProject..NashvilleProject
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE PortfolioProject..NashvilleProject
ADD SalesDateConverted Date

UPDATE PortfolioProject..NashvilleProject
SET SalesDateConverted = CONVERT(DATE, SaleDate)

--Select this new table with converted SaleDate Format

SELECT SalesDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleProject



------------------------------------------------------------------------------------------------------------------------------

--populate property address data

SELECT *
FROM PortfolioProject..NashvilleProject
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

--making a new column whwere the propert address where null in prop a will b createdd in a new column
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleProject a
JOIN PortfolioProject..NashvilleProject b
	ON	a.ParcelID = b.ParcelID 
	AND a.UniqueID  != b.UniqueID
WHERE a.PropertyAddress IS NULL

-- updating our table so we no longer have vlues where propert address is null
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleProject a
JOIN PortfolioProject..NashvilleProject b
	ON	a.ParcelID = b.ParcelID 
	AND a.UniqueID  != b.UniqueID
WHERE a.PropertyAddress IS NULL


------------------------------------------------------------------------------------------------------------------------------

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleProject
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..NashvilleProject



ALTER TABLE PortfolioProject..NashvilleProject
ADD PropertyAddressSplit nvarchar(255)

UPDATE PortfolioProject..NashvilleProject
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProject..NashvilleProject
ADD PropertyCitySplit nvarchar(255)

UPDATE PortfolioProject..NashvilleProject
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject..NashvilleProject


------------------------------------------------------------------------------------------------------------------------------

--ANOTHER WAY TO SPLIT A COLUMN 
--THIS TIME SPLITTING THE OwnerAddress column

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM PortfolioProject..NashvilleProject



ALTER TABLE PortfolioProject..NashvilleProject
ADD OwnerAddressSplit nvarchar(255)

UPDATE PortfolioProject..NashvilleProject
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE PortfolioProject..NashvilleProject
ADD OwnerCitySplit nvarchar(255)

UPDATE PortfolioProject..NashvilleProject
SET OwnerCitySplit = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


ALTER TABLE PortfolioProject..NashvilleProject
ADD OwnerStateSplit nvarchar(255)

UPDATE PortfolioProject..NashvilleProject
SET OwnerStateSplit = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


SELECT *
FROM PortfolioProject..NashvilleProject



------------------------------------------------------------------------------------------------------------------------------

--CHANGING THE T AND N IN THE SoldAsVacant column to YES and NO


SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleProject
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant

SELECT (SoldAsVacant),
CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..NashvilleProject

UPDATE PortfolioProject..NashvilleProject
SET SoldAsVacant= CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

------------------------------------------------------------------------------------------------------------------------------

--REMOVING DUPLICATES

WITH RowNumbCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) RowNumb
				
FROM PortfolioProject..NashvilleProject
)
SELECT *
FROM RowNumbCTE
WHERE RowNumb>1
--ORDER BY PropertyAddress

SELECT *
FROM PortfolioProject..NashvilleProject



------------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS


SELECT *
FROM PortfolioProject..NashvilleProject

ALTER TABLE PortfolioProject..NashvilleProject
DROP COLUMN PropertyAddress,TaxDistrict, OwnerAddress

ALTER TABLE PortfolioProject..NashvilleProject
DROP COLUMN SalesDateConverted1, SaleDate

ALTER TABLE PortfolioProject..NashvilleProject
DROP COLUMN SalesDateConverted1

ALTER TABLE PortfolioProject..NashvilleProject
DROP COLUMN SaleDate



------------------------------------------------------------------------------------------------------------------------------

--Removing rows where OwnerName is null

SELECT *
FROM PortfolioProject..NashvilleProject
WHERE OwnerName IS NOT NULL
ORDER BY SalesDateConverted ASC


------------------------------------------------------------------------------------------------------------------------------
