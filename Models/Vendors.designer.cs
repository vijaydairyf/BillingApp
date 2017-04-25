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
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="screeningONE")]
	public partial class VendorsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    #endregion
		
		public VendorsDataContext() : 
				base(global::System.Configuration.ConfigurationManager.ConnectionStrings["ScreeningONEConnectionString"].ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public VendorsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public VendorsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public VendorsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public VendorsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Vendors_GetVendorList")]
		public ISingleResult<S1_Vendors_GetVendorListResult> S1_Vendors_GetVendorList()
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())));
			return ((ISingleResult<S1_Vendors_GetVendorListResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Vendors_AddProductToVendor")]
		public int S1_Vendors_AddProductToVendor([global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> vendorID, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> productID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), vendorID, productID);
			return ((int)(result.ReturnValue));
		}
	}
	
	public partial class S1_Vendors_GetVendorListResult
	{
		
		private int _VendorID;
		
		private string _VendorName;
		
		public S1_Vendors_GetVendorListResult()
		{
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
	}
}
#pragma warning restore 1591