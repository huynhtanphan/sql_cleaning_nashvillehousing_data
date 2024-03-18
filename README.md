# Nashville Housing Data - SQL Cleaning

This script performs various cleaning tasks on the `PortfolioProject.NashvilleHousing` table. Here's a breakdown of each section:

## 1. Standardize Data Format (SaleDate)

Problem: The SaleDate format might be inconsistent.

Solution:
Converts existing `SaleDate` to a standard date format using CONVERT(date, SaleDate).
Adds a new column `SaleDateConverted` to store the standardized date.
Populates SaleDateConverted with the converted values.

## 2. Populate Property Address Data

Problem: Some records might have missing `PropertyAddress` values.

Solution:
Identifies rows with missing `PropertyAddress`.
Uses a self-join to find matching `ParcelID` records with a populated `PropertyAddress`.
Updates missing addresses using the address from the matching record.

## 3. Breaking Out Address into Individual Columns

Problem: The `PropertyAddress` might contain multiple data points (address, city, state) in a single string.

Solution:
Extracts address components (before and after the comma) using SUBSTRING.
Adds new columns `PropertySlipAddress` and `PropertySlipCity` to store the extracted data.
Populates the new columns using the extracted values.
Similar steps are performed to extract components from `OwnerAddress` into new columns `OwnerSlipAddress`, `OwnerSlipCity`, and `OwnerSlipState`.

## 4. Change Y and N to Yes and No in "Sold as Vacant" Field

Problem: The `SoldAsVacant` field might use single characters ('Y' or 'N') to represent Yes or No.

Solution:
Uses a CASE statement to convert 'Y' to 'Yes' and 'N' to 'No'.
Updates the `SoldAsVacant` field with the converted values.

## 5. Delete Duplicated Rows

Problem: The table might contain duplicate rows.

Solution:
Uses a Common Table Expression (CTE) with ROW_NUMBER() to assign a row number based on specific columns (identifying duplicates).
Deletes rows with a row number greater than 1 (duplicates).

## 6. Delete Unused Columns

Problem: Some columns might no longer be needed.

Solution:
Uses ALTER TABLE DROP COLUMN to remove unwanted columns like `PropertyAddress`, `SaleDate`, O`wnerAddress`, and `TaxDistrict`.

## 7. Rename Column

Solution:
Uses sp_rename stored procedure to rename the `SaleDateConverted` column to the simpler `SaleDate`.
