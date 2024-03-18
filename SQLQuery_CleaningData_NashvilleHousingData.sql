/* 
Cleaning data in SQL queries
*/

SELECT *
FROM PortfolioProject..NashvilleHousing


-----------------------------------------------------------------------------------
--Standardize data format

/*Looking*/
SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortfolioProject..NashvilleHousing		 

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted date

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)


-----------------------------------------------------------------------------------
--Populate Property Address data

/*Looking*/
SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is null				

/*Test*/
SELECT
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM	
	PortfolioProject..NashvilleHousing a
	join 
	PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null				


UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM	
	PortfolioProject..NashvilleHousing a
	join 
	PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


-----------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

/*Looking*/
SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
FROM PortfolioProject..NashvilleHousing

SELECT PropertyAddress, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySlipAddress  NVARCHAR(255)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySlipCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySlipAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET PropertySlipCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
FROM PortfolioProject..NashvilleHousing

/*Test*/
SELECT PropertySlipAddress, PropertySlipCity
FROM PortfolioProject..NashvilleHousing

/*Looking*/
SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSlipAddress NVARCHAR(255)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSlipCity NVARCHAR(255)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSlipState NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSlipAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSlipCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSlipState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

/*Test*/
SELECT OwnerSlipAddress, OwnerSlipCity, OwnerSlipState
FROM PortfolioProject..NashvilleHousing



-----------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

/*Looking*/
SELECT SoldAsVacant 
FROM PortfolioProject..NashvilleHousing

/*Test*/
SELECT SoldAsVacant
, CASE	
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE	
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END



-----------------------------------------------------------------------------------
--Delete Duplicated Columns																														Num
WITH RowNumberCTE AS(
	SELECT *
		,ROW_NUMBER() OVER (
			PARTITION BY 
				ParcelId,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
			ORDER BY UniqueId
			) as row_number		
	FROM 
		PortfolioProject..NashvilleHousing
		)


/*Test*/
--SELECT *
--FROM RowNumberCTE
--WHERE row_number>1

DELETE
FROM RowNumberCTE
WHERE row_number >1



-----------------------------------------------------------------------------------
--Delete Unused Columns	

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict




-----------------------------------------------------------------------------------
--Rename Columns	

EXEC sp_rename 'NashvilleHousing.SaleDateConverted', 'SaleDate';