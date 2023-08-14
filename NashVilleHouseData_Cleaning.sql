select* from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]

--Strandardizing the Date format
 select SaleDate, convert(Date,SaleDate)
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]


  update [Nashville Housing Data for Data Cleaning]
  set SaleDate = CONVERT(Date,SaleDate)

   select SaleDate
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]

  -- Populate Property Address Data

	 select PropertyAddress
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
  where PropertyAddress is null

   select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] a
  join PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null

  update a
  set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] a
  join PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID


  -- Breaking out Address into Individual Columns (Address, City, State)
   select PropertyAddress
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
  --where PropertyAddress is null

  select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
   from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
 
 alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
 add PropertySplitCity NVARCHAR(255);
 
 UPDATE [Nashville Housing Data for Data Cleaning]
 set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

 select* from
 [Nashville Housing Data for Data Cleaning]



 --Breaking ou Owner Address

 select OwnerAddress
 from [Nashville Housing Data for Data Cleaning]

 select 
 PARSENAME(Replace(OwnerAddress,',','.'),3) 
 , PARSENAME(Replace(OwnerAddress,',','.'),2) 
   ,PARSENAME(Replace(OwnerAddress,',','.'),1) 
 from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]

  alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
 add OwnerSplitAddress NVARCHAR(255);
 UPDATE [Nashville Housing Data for Data Cleaning]
 set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3) 

  alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
 add OwnerSplitCity NVARCHAR(255);

 UPDATE [Nashville Housing Data for Data Cleaning]
 set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


  alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning] 
 add OwnerSplitState NVARCHAR(255);
  UPDATE [Nashville Housing Data for Data Cleaning]
 set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

 select* from
 [Nashville Housing Data for Data Cleaning]

 --Select Y or N to Yes and No in "Sold as Vacant" Field

 select distinct(SoldAsVacant), count(SoldAsVacant)
 from [Nashville Housing Data for Data Cleaning]
 group by SoldAsVacant
 order by 2

 
 select SoldAsVacant,
 CASE when SoldAsVacant = 0 then 'no'
		else 'yes'
end
 from [Nashville Housing Data for Data Cleaning]


 update [Nashville Housing Data for Data Cleaning]
 set SoldAsVacant = CASE when SoldAsVacant = 0 then cast('no' as varchar(10))
		else 'yes'
end
 from [Nashville Housing Data for Data Cleaning]


 --Remove Duplicates

 with RowNumCTE AS(
 select*,
	ROW_NUMBER() over(
	partition by parcelid,
				PropertyAddress,
				SalePrice,
				LegalReference
				order by UniqueID)row_num
 from [Nashville Housing Data for Data Cleaning]
 --order by ParcelID
 )
 select* from
 RowNumCTE
 Where row_num>1
 order by propertyAddress


 Select* 
 from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]


 --Deleting Unused Columns 

 Select* 
 
 select* from
 [Nashville Housing Data for Data Cleaning]

 alter table 
 [Nashville Housing Data for Data Cleaning]
 drop column OwnerAddress, TaxDistrict, HalfBath