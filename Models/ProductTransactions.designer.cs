﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ScreeningONE.Models
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="ScreeningONE")]
	public partial class ProductTransactionsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    #endregion
		
		public ProductTransactionsDataContext() : 
				base(global::System.Configuration.ConfigurationManager.ConnectionStrings["ScreeningONEConnectionString"].ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public ProductTransactionsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public ProductTransactionsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public ProductTransactionsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public ProductTransactionsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_CreateProductTransaction")]
		public int S1_ProductTransactions_CreateProductTransaction([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductID", DbType="Int")] System.Nullable<int> productID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="VendorID", DbType="Int")] System.Nullable<int> vendorID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="TransactionDate", DbType="DateTime")] System.Nullable<System.DateTime> transactionDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="DateOrdered", DbType="DateTime")] System.Nullable<System.DateTime> dateOrdered, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="OrderBy", DbType="VarChar(50)")] string orderBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="Reference", DbType="VarChar(50)")] string reference, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="FileNum", DbType="VarChar(50)")] string fileNum, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="FName", DbType="VarChar(255)")] string fName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="LName", DbType="VarChar(255)")] string lName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MName", DbType="VarChar(255)")] string mName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="SSN", DbType="VarChar(50)")] string sSN, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductDescription", DbType="VarChar(MAX)")] string productDescription, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductType", DbType="VarChar(50)")] string productType, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductPrice", DbType="Money")] System.Nullable<decimal> productPrice)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), productID, clientID, vendorID, transactionDate, dateOrdered, orderBy, reference, fileNum, fName, lName, mName, sSN, productDescription, productType, productPrice);
			return ((int)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_GetProductTransaction")]
		public ISingleResult<S1_ProductTransactions_GetProductTransactionResult> S1_ProductTransactions_GetProductTransaction([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductTransactionID", DbType="Int")] System.Nullable<int> productTransactionID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), productTransactionID);
			return ((ISingleResult<S1_ProductTransactions_GetProductTransactionResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_GetProductTransactions")]
		public ISingleResult<S1_ProductTransactions_GetProductTransactionsResult> S1_ProductTransactions_GetProductTransactions([global::System.Data.Linq.Mapping.ParameterAttribute(Name="Status", DbType="Int")] System.Nullable<int> status, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), status, clientID);
			return ((ISingleResult<S1_ProductTransactions_GetProductTransactionsResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_GetProductTransactionsPaged")]
		public ISingleResult<S1_ProductTransactions_GetProductTransactionsPagedResult> S1_ProductTransactions_GetProductTransactionsPaged([global::System.Data.Linq.Mapping.ParameterAttribute(Name="Status", DbType="Int")] System.Nullable<int> status, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="StartDate", DbType="DateTime")] System.Nullable<System.DateTime> startDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="EndDate", DbType="DateTime")] System.Nullable<System.DateTime> endDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="FileNum", DbType="VarChar(50)")] string fileNum, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="CurrentPage", DbType="Int")] System.Nullable<int> currentPage, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="RowsPerPage", DbType="Int")] System.Nullable<int> rowsPerPage, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="OrderBy", DbType="VarChar(50)")] string orderBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="OrderDir", DbType="Bit")] System.Nullable<bool> orderDir)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), status, clientID, startDate, endDate, fileNum, currentPage, rowsPerPage, orderBy, orderDir);
			return ((ISingleResult<S1_ProductTransactions_GetProductTransactionsPagedResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_RemoveProductTransaction")]
		public int S1_ProductTransactions_RemoveProductTransaction([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductTransactionID", DbType="Int")] System.Nullable<int> productTransactionID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), productTransactionID);
			return ((int)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_ProductTransactions_UpdateProductTransaction")]
		public int S1_ProductTransactions_UpdateProductTransaction(
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductTransactionID", DbType="Int")] System.Nullable<int> productTransactionID, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductID", DbType="Int")] System.Nullable<int> productID, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="VendorID", DbType="Int")] System.Nullable<int> vendorID, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="TransactionDate", DbType="DateTime")] System.Nullable<System.DateTime> transactionDate, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="DateOrdered", DbType="DateTime")] System.Nullable<System.DateTime> dateOrdered, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="OrderBy", DbType="VarChar(50)")] string orderBy, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="Reference", DbType="VarChar(50)")] string reference, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="FileNum", DbType="VarChar(50)")] string fileNum, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="FName", DbType="VarChar(255)")] string fName, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="LName", DbType="VarChar(255)")] string lName, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="MName", DbType="VarChar(255)")] string mName, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="SSN", DbType="VarChar(50)")] string sSN, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductDescription", DbType="VarChar(MAX)")] string productDescription, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductType", DbType="VarChar(50)")] string productType, 
					[global::System.Data.Linq.Mapping.ParameterAttribute(Name="ProductPrice", DbType="Money")] System.Nullable<decimal> productPrice)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), productTransactionID, productID, clientID, vendorID, transactionDate, dateOrdered, orderBy, reference, fileNum, fName, lName, mName, sSN, productDescription, productType, productPrice);
			return ((int)(result.ReturnValue));
		}
	}
	
	public partial class S1_ProductTransactions_GetProductTransactionResult
	{
		
		private int _ProductTransactionID;
		
		private int _ProductID;
		
		private int _ClientID;
		
		private string _ClientName;
		
		private int _VendorID;
		
		private string _VendorName;
		
		private System.Nullable<System.DateTime> _TransactionDate;
		
		private System.Nullable<System.DateTime> _DateOrdered;
		
		private string _OrderBy;
		
		private string _Reference;
		
		private string _FileNum;
		
		private string _FName;
		
		private byte _IncludeOnInvoice;
		
		private string _LName;
		
		private string _MName;
		
		private string _SSN;
		
		private string _ProductName;
		
		private string _ProductDescription;
		
		private string _ProductType;
		
		private decimal _ProductPrice;
		
		private string _ExternalInvoiceNumber;
		
		private string _SalesRep;
		
		private string _CoLName;
		
		private string _CoFName;
		
		private string _CoMName;
		
		private string _CoSSN;
		
		private decimal _BasePrice;
		
		private System.Nullable<bool> _ImportsAtBaseOrSales;
		
		public S1_ProductTransactions_GetProductTransactionResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductTransactionID", DbType="Int NOT NULL")]
		public int ProductTransactionID
		{
			get
			{
				return this._ProductTransactionID;
			}
			set
			{
				if ((this._ProductTransactionID != value))
				{
					this._ProductTransactionID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductID", DbType="Int NOT NULL")]
		public int ProductID
		{
			get
			{
				return this._ProductID;
			}
			set
			{
				if ((this._ProductID != value))
				{
					this._ProductID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientID", DbType="Int NOT NULL")]
		public int ClientID
		{
			get
			{
				return this._ClientID;
			}
			set
			{
				if ((this._ClientID != value))
				{
					this._ClientID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientName", DbType="VarChar(100) NOT NULL", CanBeNull=false)]
		public string ClientName
		{
			get
			{
				return this._ClientName;
			}
			set
			{
				if ((this._ClientName != value))
				{
					this._ClientName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VendorID", DbType="Int NOT NULL")]
		public int VendorID
		{
			get
			{
				return this._VendorID;
			}
			set
			{
				if ((this._VendorID != value))
				{
					this._VendorID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VendorName", DbType="VarChar(100)")]
		public string VendorName
		{
			get
			{
				return this._VendorName;
			}
			set
			{
				if ((this._VendorName != value))
				{
					this._VendorName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_TransactionDate", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> TransactionDate
		{
			get
			{
				return this._TransactionDate;
			}
			set
			{
				if ((this._TransactionDate != value))
				{
					this._TransactionDate = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_DateOrdered", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> DateOrdered
		{
			get
			{
				return this._DateOrdered;
			}
			set
			{
				if ((this._DateOrdered != value))
				{
					this._DateOrdered = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_OrderBy", DbType="VarChar(100)")]
		public string OrderBy
		{
			get
			{
				return this._OrderBy;
			}
			set
			{
				if ((this._OrderBy != value))
				{
					this._OrderBy = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Reference", DbType="VarChar(100)")]
		public string Reference
		{
			get
			{
				return this._Reference;
			}
			set
			{
				if ((this._Reference != value))
				{
					this._Reference = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FileNum", DbType="VarChar(50)")]
		public string FileNum
		{
			get
			{
				return this._FileNum;
			}
			set
			{
				if ((this._FileNum != value))
				{
					this._FileNum = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FName", DbType="VarChar(255)")]
		public string FName
		{
			get
			{
				return this._FName;
			}
			set
			{
				if ((this._FName != value))
				{
					this._FName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_IncludeOnInvoice", DbType="TinyInt NOT NULL")]
		public byte IncludeOnInvoice
		{
			get
			{
				return this._IncludeOnInvoice;
			}
			set
			{
				if ((this._IncludeOnInvoice != value))
				{
					this._IncludeOnInvoice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_LName", DbType="VarChar(255)")]
		public string LName
		{
			get
			{
				return this._LName;
			}
			set
			{
				if ((this._LName != value))
				{
					this._LName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MName", DbType="VarChar(255)")]
		public string MName
		{
			get
			{
				return this._MName;
			}
			set
			{
				if ((this._MName != value))
				{
					this._MName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_SSN", DbType="VarChar(50)")]
		public string SSN
		{
			get
			{
				return this._SSN;
			}
			set
			{
				if ((this._SSN != value))
				{
					this._SSN = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductName", DbType="VarChar(255) NOT NULL", CanBeNull=false)]
		public string ProductName
		{
			get
			{
				return this._ProductName;
			}
			set
			{
				if ((this._ProductName != value))
				{
					this._ProductName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductDescription", DbType="VarChar(MAX)")]
		public string ProductDescription
		{
			get
			{
				return this._ProductDescription;
			}
			set
			{
				if ((this._ProductDescription != value))
				{
					this._ProductDescription = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductType", DbType="VarChar(50)")]
		public string ProductType
		{
			get
			{
				return this._ProductType;
			}
			set
			{
				if ((this._ProductType != value))
				{
					this._ProductType = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductPrice", DbType="Money NOT NULL")]
		public decimal ProductPrice
		{
			get
			{
				return this._ProductPrice;
			}
			set
			{
				if ((this._ProductPrice != value))
				{
					this._ProductPrice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ExternalInvoiceNumber", DbType="VarChar(50)")]
		public string ExternalInvoiceNumber
		{
			get
			{
				return this._ExternalInvoiceNumber;
			}
			set
			{
				if ((this._ExternalInvoiceNumber != value))
				{
					this._ExternalInvoiceNumber = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_SalesRep", DbType="VarChar(50)")]
		public string SalesRep
		{
			get
			{
				return this._SalesRep;
			}
			set
			{
				if ((this._SalesRep != value))
				{
					this._SalesRep = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CoLName", DbType="VarChar(255)")]
		public string CoLName
		{
			get
			{
				return this._CoLName;
			}
			set
			{
				if ((this._CoLName != value))
				{
					this._CoLName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CoFName", DbType="VarChar(255)")]
		public string CoFName
		{
			get
			{
				return this._CoFName;
			}
			set
			{
				if ((this._CoFName != value))
				{
					this._CoFName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CoMName", DbType="VarChar(255)")]
		public string CoMName
		{
			get
			{
				return this._CoMName;
			}
			set
			{
				if ((this._CoMName != value))
				{
					this._CoMName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CoSSN", DbType="VarChar(50)")]
		public string CoSSN
		{
			get
			{
				return this._CoSSN;
			}
			set
			{
				if ((this._CoSSN != value))
				{
					this._CoSSN = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_BasePrice", DbType="Money NOT NULL")]
		public decimal BasePrice
		{
			get
			{
				return this._BasePrice;
			}
			set
			{
				if ((this._BasePrice != value))
				{
					this._BasePrice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ImportsAtBaseOrSales", DbType="Bit")]
		public System.Nullable<bool> ImportsAtBaseOrSales
		{
			get
			{
				return this._ImportsAtBaseOrSales;
			}
			set
			{
				if ((this._ImportsAtBaseOrSales != value))
				{
					this._ImportsAtBaseOrSales = value;
				}
			}
		}
	}
	
	public partial class S1_ProductTransactions_GetProductTransactionsResult
	{
		
		private int _ProductTransactionID;
		
		private string _FileNum;
		
		private string _OrderBy;
		
		private string _Reference;
		
		private System.Nullable<System.DateTime> _TransactionDate;
		
		private System.Nullable<System.DateTime> _DateOrdered;
		
		private string _FName;
		
		private string _LName;
		
		private string _MName;
		
		private int _ProductID;
		
		private string _ProductDescription;
		
		private string _ProductType;
		
		private string _ProductName;
		
		private System.Nullable<decimal> _ProductPrice;
		
		private string _ExternalInvoiceNumber;
		
		private string _SalesRep;
		
		private int _ClientID;
		
		private string _ClientName;
		
		private byte _IncludeOnInvoice;
		
		public S1_ProductTransactions_GetProductTransactionsResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductTransactionID", DbType="Int NOT NULL")]
		public int ProductTransactionID
		{
			get
			{
				return this._ProductTransactionID;
			}
			set
			{
				if ((this._ProductTransactionID != value))
				{
					this._ProductTransactionID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FileNum", DbType="VarChar(50)")]
		public string FileNum
		{
			get
			{
				return this._FileNum;
			}
			set
			{
				if ((this._FileNum != value))
				{
					this._FileNum = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_OrderBy", DbType="VarChar(100)")]
		public string OrderBy
		{
			get
			{
				return this._OrderBy;
			}
			set
			{
				if ((this._OrderBy != value))
				{
					this._OrderBy = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Reference", DbType="VarChar(100)")]
		public string Reference
		{
			get
			{
				return this._Reference;
			}
			set
			{
				if ((this._Reference != value))
				{
					this._Reference = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_TransactionDate", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> TransactionDate
		{
			get
			{
				return this._TransactionDate;
			}
			set
			{
				if ((this._TransactionDate != value))
				{
					this._TransactionDate = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_DateOrdered", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> DateOrdered
		{
			get
			{
				return this._DateOrdered;
			}
			set
			{
				if ((this._DateOrdered != value))
				{
					this._DateOrdered = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FName", DbType="VarChar(255)")]
		public string FName
		{
			get
			{
				return this._FName;
			}
			set
			{
				if ((this._FName != value))
				{
					this._FName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_LName", DbType="VarChar(255)")]
		public string LName
		{
			get
			{
				return this._LName;
			}
			set
			{
				if ((this._LName != value))
				{
					this._LName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MName", DbType="VarChar(255)")]
		public string MName
		{
			get
			{
				return this._MName;
			}
			set
			{
				if ((this._MName != value))
				{
					this._MName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductID", DbType="Int NOT NULL")]
		public int ProductID
		{
			get
			{
				return this._ProductID;
			}
			set
			{
				if ((this._ProductID != value))
				{
					this._ProductID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductDescription", DbType="VarChar(MAX)")]
		public string ProductDescription
		{
			get
			{
				return this._ProductDescription;
			}
			set
			{
				if ((this._ProductDescription != value))
				{
					this._ProductDescription = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductType", DbType="VarChar(50)")]
		public string ProductType
		{
			get
			{
				return this._ProductType;
			}
			set
			{
				if ((this._ProductType != value))
				{
					this._ProductType = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductName", DbType="VarChar(255) NOT NULL", CanBeNull=false)]
		public string ProductName
		{
			get
			{
				return this._ProductName;
			}
			set
			{
				if ((this._ProductName != value))
				{
					this._ProductName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductPrice", DbType="Money")]
		public System.Nullable<decimal> ProductPrice
		{
			get
			{
				return this._ProductPrice;
			}
			set
			{
				if ((this._ProductPrice != value))
				{
					this._ProductPrice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ExternalInvoiceNumber", DbType="VarChar(50)")]
		public string ExternalInvoiceNumber
		{
			get
			{
				return this._ExternalInvoiceNumber;
			}
			set
			{
				if ((this._ExternalInvoiceNumber != value))
				{
					this._ExternalInvoiceNumber = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_SalesRep", DbType="VarChar(50)")]
		public string SalesRep
		{
			get
			{
				return this._SalesRep;
			}
			set
			{
				if ((this._SalesRep != value))
				{
					this._SalesRep = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientID", DbType="Int NOT NULL")]
		public int ClientID
		{
			get
			{
				return this._ClientID;
			}
			set
			{
				if ((this._ClientID != value))
				{
					this._ClientID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientName", DbType="VarChar(100) NOT NULL", CanBeNull=false)]
		public string ClientName
		{
			get
			{
				return this._ClientName;
			}
			set
			{
				if ((this._ClientName != value))
				{
					this._ClientName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_IncludeOnInvoice", DbType="TinyInt NOT NULL")]
		public byte IncludeOnInvoice
		{
			get
			{
				return this._IncludeOnInvoice;
			}
			set
			{
				if ((this._IncludeOnInvoice != value))
				{
					this._IncludeOnInvoice = value;
				}
			}
		}
	}
	
	public partial class S1_ProductTransactions_GetProductTransactionsPagedResult
	{
		
		private int _ProductTransactionID;
		
		private string _FileNum;
		
		private string _OrderBy;
		
		private string _Reference;
		
		private System.Nullable<System.DateTime> _TransactionDate;
		
		private System.Nullable<System.DateTime> _DateOrdered;
		
		private string _FName;
		
		private string _LName;
		
		private string _MName;
		
		private int _ProductID;
		
		private string _ProductDescription;
		
		private string _ProductType;
		
		private string _ProductName;
		
		private decimal _ProductPrice;
		
		private string _ExternalInvoiceNumber;
		
		private string _SalesRep;
		
		private int _ClientID;
		
		private string _ClientName;
		
		private byte _IncludeOnInvoice;
		
		private System.Nullable<long> _rownum;
		
		private System.Nullable<int> _Number;
		
		public S1_ProductTransactions_GetProductTransactionsPagedResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductTransactionID", DbType="Int NOT NULL")]
		public int ProductTransactionID
		{
			get
			{
				return this._ProductTransactionID;
			}
			set
			{
				if ((this._ProductTransactionID != value))
				{
					this._ProductTransactionID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FileNum", DbType="VarChar(50)")]
		public string FileNum
		{
			get
			{
				return this._FileNum;
			}
			set
			{
				if ((this._FileNum != value))
				{
					this._FileNum = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_OrderBy", DbType="VarChar(100)")]
		public string OrderBy
		{
			get
			{
				return this._OrderBy;
			}
			set
			{
				if ((this._OrderBy != value))
				{
					this._OrderBy = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Reference", DbType="VarChar(100)")]
		public string Reference
		{
			get
			{
				return this._Reference;
			}
			set
			{
				if ((this._Reference != value))
				{
					this._Reference = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_TransactionDate", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> TransactionDate
		{
			get
			{
				return this._TransactionDate;
			}
			set
			{
				if ((this._TransactionDate != value))
				{
					this._TransactionDate = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_DateOrdered", DbType="SmallDateTime")]
		public System.Nullable<System.DateTime> DateOrdered
		{
			get
			{
				return this._DateOrdered;
			}
			set
			{
				if ((this._DateOrdered != value))
				{
					this._DateOrdered = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_FName", DbType="VarChar(255)")]
		public string FName
		{
			get
			{
				return this._FName;
			}
			set
			{
				if ((this._FName != value))
				{
					this._FName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_LName", DbType="VarChar(255)")]
		public string LName
		{
			get
			{
				return this._LName;
			}
			set
			{
				if ((this._LName != value))
				{
					this._LName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MName", DbType="VarChar(255)")]
		public string MName
		{
			get
			{
				return this._MName;
			}
			set
			{
				if ((this._MName != value))
				{
					this._MName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductID", DbType="Int NOT NULL")]
		public int ProductID
		{
			get
			{
				return this._ProductID;
			}
			set
			{
				if ((this._ProductID != value))
				{
					this._ProductID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductDescription", DbType="VarChar(MAX)")]
		public string ProductDescription
		{
			get
			{
				return this._ProductDescription;
			}
			set
			{
				if ((this._ProductDescription != value))
				{
					this._ProductDescription = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductType", DbType="VarChar(50)")]
		public string ProductType
		{
			get
			{
				return this._ProductType;
			}
			set
			{
				if ((this._ProductType != value))
				{
					this._ProductType = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductName", DbType="VarChar(255) NOT NULL", CanBeNull=false)]
		public string ProductName
		{
			get
			{
				return this._ProductName;
			}
			set
			{
				if ((this._ProductName != value))
				{
					this._ProductName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ProductPrice", DbType="Money NOT NULL")]
		public decimal ProductPrice
		{
			get
			{
				return this._ProductPrice;
			}
			set
			{
				if ((this._ProductPrice != value))
				{
					this._ProductPrice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ExternalInvoiceNumber", DbType="VarChar(50)")]
		public string ExternalInvoiceNumber
		{
			get
			{
				return this._ExternalInvoiceNumber;
			}
			set
			{
				if ((this._ExternalInvoiceNumber != value))
				{
					this._ExternalInvoiceNumber = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_SalesRep", DbType="VarChar(50)")]
		public string SalesRep
		{
			get
			{
				return this._SalesRep;
			}
			set
			{
				if ((this._SalesRep != value))
				{
					this._SalesRep = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientID", DbType="Int NOT NULL")]
		public int ClientID
		{
			get
			{
				return this._ClientID;
			}
			set
			{
				if ((this._ClientID != value))
				{
					this._ClientID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ClientName", DbType="VarChar(100) NOT NULL", CanBeNull=false)]
		public string ClientName
		{
			get
			{
				return this._ClientName;
			}
			set
			{
				if ((this._ClientName != value))
				{
					this._ClientName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_IncludeOnInvoice", DbType="TinyInt NOT NULL")]
		public byte IncludeOnInvoice
		{
			get
			{
				return this._IncludeOnInvoice;
			}
			set
			{
				if ((this._IncludeOnInvoice != value))
				{
					this._IncludeOnInvoice = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_rownum", DbType="BigInt")]
		public System.Nullable<long> rownum
		{
			get
			{
				return this._rownum;
			}
			set
			{
				if ((this._rownum != value))
				{
					this._rownum = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Number", DbType="Int")]
		public System.Nullable<int> Number
		{
			get
			{
				return this._Number;
			}
			set
			{
				if ((this._Number != value))
				{
					this._Number = value;
				}
			}
		}
	}
}
#pragma warning restore 1591
