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

namespace ScreeningONE
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="ScreeningONE_Test")]
	public partial class MessagesDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    #endregion
		
		public MessagesDataContext() : 
				base(global::System.Configuration.ConfigurationManager.ConnectionStrings["ScreeningONEConnectionString"].ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public MessagesDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MessagesDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MessagesDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MessagesDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_GetMessageTemplateReservedWordList")]
		public ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateReservedWordListResult> S1_Messages_GetMessageTemplateReservedWordList([global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageTemplateName", DbType="VarChar(50)")] string messageTemplateName)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), messageTemplateName);
			return ((ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateReservedWordListResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_GetMessageTemplate")]
		public ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateResult> S1_Messages_GetMessageTemplate([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageName", DbType="VarChar(50)")] string messageName)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), clientID, messageName);
			return ((ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_GetMessageTemplateList")]
		public ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateListResult> S1_Messages_GetMessageTemplateList([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), clientID);
			return ((ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateListResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_CreateMessageWithAction")]
		public int S1_Messages_CreateMessageWithAction([global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> messageactiontype, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="VarChar(255)")] string messagesubject, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="VarChar(MAX)")] string messagetext, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> messageto, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> tocontacttype, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> messagefrom, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Int")] System.Nullable<int> fromcontacttype, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="VarChar(100)")] string messageactionpath, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="DateTime")] System.Nullable<System.DateTime> sentdate, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="DateTime")] System.Nullable<System.DateTime> receiveddate, [global::System.Data.Linq.Mapping.ParameterAttribute(DbType="VarChar(50)")] string bodyformat, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageID", DbType="Int")] ref System.Nullable<int> messageID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageActionGUID", DbType="UniqueIdentifier")] ref System.Nullable<System.Guid> messageActionGUID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), messageactiontype, messagesubject, messagetext, messageto, tocontacttype, messagefrom, fromcontacttype, messageactionpath, sentdate, receiveddate, bodyformat, messageID, messageActionGUID);
			messageID = ((System.Nullable<int>)(result.GetParameterValue(11)));
			messageActionGUID = ((System.Nullable<System.Guid>)(result.GetParameterValue(12)));
			return ((int)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_UpdateMessageAndMarkForSending")]
		public int S1_Messages_UpdateMessageAndMarkForSending([global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageID", DbType="Int")] System.Nullable<int> messageID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageSubject", DbType="VarChar(255)")] string messageSubject, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageText", DbType="VarChar(MAX)")] string messageText)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), messageID, messageSubject, messageText);
			return ((int)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_GetMessageTemplateRecord")]
		public ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateRecordResult> S1_Messages_GetMessageTemplateRecord([global::System.Data.Linq.Mapping.ParameterAttribute(Name="ClientID", DbType="Int")] System.Nullable<int> clientID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageName", DbType="VarChar(50)")] string messageName)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), clientID, messageName);
			return ((ISingleResult<ScreeningONE.Models.S1_Messages_GetMessageTemplateRecordResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.S1_Messages_AddMessage")]
		public int S1_Messages_AddMessage([global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageActionTypeID", DbType="Int")] System.Nullable<int> messageActionTypeID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageSubject", DbType="VarChar(255)")] string messageSubject, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageText", DbType="VarChar(MAX)")] string messageText, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageTo", DbType="Int")] System.Nullable<int> messageTo, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToContactType", DbType="Int")] System.Nullable<int> toContactType, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageFrom", DbType="Int")] System.Nullable<int> messageFrom, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromContactType", DbType="Int")] System.Nullable<int> fromContactType, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="EmailAddressTo", DbType="NVarChar(256)")] string emailAddressTo, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="MessageGUID", DbType="UniqueIdentifier")] ref System.Nullable<System.Guid> messageGUID)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), messageActionTypeID, messageSubject, messageText, messageTo, toContactType, messageFrom, fromContactType, emailAddressTo, messageGUID);
			messageGUID = ((System.Nullable<System.Guid>)(result.GetParameterValue(8)));
			return ((int)(result.ReturnValue));
		}
	}
}
namespace ScreeningONE.Models
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.ComponentModel;
	using System;
	
	
	public partial class S1_Messages_GetMessageTemplateReservedWordListResult
	{
		
		private string _ReservedWord;
		
		private string _ReservedWordDisplay;
		
		public S1_Messages_GetMessageTemplateReservedWordListResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ReservedWord", DbType="VarChar(250) NOT NULL", CanBeNull=false)]
		public string ReservedWord
		{
			get
			{
				return this._ReservedWord;
			}
			set
			{
				if ((this._ReservedWord != value))
				{
					this._ReservedWord = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ReservedWordDisplay", DbType="VarChar(250) NOT NULL", CanBeNull=false)]
		public string ReservedWordDisplay
		{
			get
			{
				return this._ReservedWordDisplay;
			}
			set
			{
				if ((this._ReservedWordDisplay != value))
				{
					this._ReservedWordDisplay = value;
				}
			}
		}
	}
	
	public partial class S1_Messages_GetMessageTemplateResult
	{
		
		private string _MessageText;
		
		public S1_Messages_GetMessageTemplateResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageText", DbType="VarChar(MAX) NOT NULL", CanBeNull=false)]
		public string MessageText
		{
			get
			{
				return this._MessageText;
			}
			set
			{
				if ((this._MessageText != value))
				{
					this._MessageText = value;
				}
			}
		}
	}
	
	public partial class S1_Messages_GetMessageTemplateListResult
	{
		
		private string _MessageName;
		
		private byte _IsPlainText;
		
		public S1_Messages_GetMessageTemplateListResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageName", DbType="VarChar(50) NOT NULL", CanBeNull=false)]
		public string MessageName
		{
			get
			{
				return this._MessageName;
			}
			set
			{
				if ((this._MessageName != value))
				{
					this._MessageName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_IsPlainText", DbType="TinyInt NOT NULL")]
		public byte IsPlainText
		{
			get
			{
				return this._IsPlainText;
			}
			set
			{
				if ((this._IsPlainText != value))
				{
					this._IsPlainText = value;
				}
			}
		}
	}
	
	public partial class S1_Messages_GetMessageTemplateRecordResult
	{
		
		private System.Nullable<int> _MessageActionTypeID;
		
		private int _MessageTemplateID;
		
		private int _ClientID;
		
		private string _MessageText;
		
		private string _MessageName;
		
		private byte _IsPlainText;
		
		public S1_Messages_GetMessageTemplateRecordResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageActionTypeID", DbType="Int")]
		public System.Nullable<int> MessageActionTypeID
		{
			get
			{
				return this._MessageActionTypeID;
			}
			set
			{
				if ((this._MessageActionTypeID != value))
				{
					this._MessageActionTypeID = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageTemplateID", DbType="Int NOT NULL")]
		public int MessageTemplateID
		{
			get
			{
				return this._MessageTemplateID;
			}
			set
			{
				if ((this._MessageTemplateID != value))
				{
					this._MessageTemplateID = value;
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageText", DbType="VarChar(MAX) NOT NULL", CanBeNull=false)]
		public string MessageText
		{
			get
			{
				return this._MessageText;
			}
			set
			{
				if ((this._MessageText != value))
				{
					this._MessageText = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MessageName", DbType="VarChar(50) NOT NULL", CanBeNull=false)]
		public string MessageName
		{
			get
			{
				return this._MessageName;
			}
			set
			{
				if ((this._MessageName != value))
				{
					this._MessageName = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_IsPlainText", DbType="TinyInt NOT NULL")]
		public byte IsPlainText
		{
			get
			{
				return this._IsPlainText;
			}
			set
			{
				if ((this._IsPlainText != value))
				{
					this._IsPlainText = value;
				}
			}
		}
	}
}
#pragma warning restore 1591