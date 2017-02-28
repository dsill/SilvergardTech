using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AngeionCalcsAPI.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using AngeionCalcsAPI.Helpers;

namespace AngeionCalcsAPI
{
    public class CaseAttributeDAO
    {
        public ArrayList getCaseAttributeList(int CaseID)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                ArrayList CaseAttributeArray = new ArrayList();

                //define stored proc with params
                SqlCommand cmd = new SqlCommand("dbo.CaseAttribute_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseID", CaseID);

                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();
                while (SQLReader.Read())
                {

                    CaseAttribute CaseAttributeRecord = new CaseAttribute();

                    int CaseIDOrdinal = SQLReader.GetOrdinal("CaseID");
                    int CaseAttributeIDOrdinal = SQLReader.GetOrdinal("CaseAttributeID");
                    int CaseAttributePromptOrdinal = SQLReader.GetOrdinal("CaseAttributePrompt");
                    int CaseAttributeTypeIDOrdinal = SQLReader.GetOrdinal("CaseAttributeTypeID");
                    int isBoolOrdinal = SQLReader.GetOrdinal("isBool");
                    int isVisibleOrdinal = SQLReader.GetOrdinal("isVisible");
                    int ParentCaseAttributeIDOrdinal = SQLReader.GetOrdinal("ParentCaseAttributeID");
                    int CaseAttributeTypeNameOrdinal = SQLReader.GetOrdinal("CaseAttributeTypeName");
                    int CaseAttributeValueOrdinal = SQLReader.GetOrdinal("CaseAttributeValue");
                    int isRequiredOrdinal = SQLReader.GetOrdinal("isRequired");
                    int CreatedDateOrdinal = SQLReader.GetOrdinal("CreatedDate");
                    int ModifiedDateOrdinal = SQLReader.GetOrdinal("ModifiedDate");

                    CaseAttributeRecord.CaseID = SQLReader.GetInt32(CaseIDOrdinal);
                    CaseAttributeRecord.CaseAttributeID = SQLReader.GetInt32(CaseAttributeIDOrdinal);
                    CaseAttributeRecord.CaseAttributePrompt = SQLReader.GetString(CaseAttributePromptOrdinal);
                    CaseAttributeRecord.CaseAttributeTypeID = SQLReader.GetInt32(CaseAttributeTypeIDOrdinal);
                    CaseAttributeRecord.isBool = SQLReader.GetByte(isBoolOrdinal);
                    CaseAttributeRecord.isVisible = SQLReader.GetByte(isVisibleOrdinal);
                    CaseAttributeRecord.ParentCaseAttributeID = SQLReader.GetInt32(ParentCaseAttributeIDOrdinal);
                    CaseAttributeRecord.CaseAttributeTypeName = SQLReader.GetString(CaseAttributeTypeNameOrdinal);
                    if (!SQLReader.IsDBNull(CaseAttributeValueOrdinal))
                        CaseAttributeRecord.CaseAttributeValue = SQLReader.GetString(CaseAttributeValueOrdinal);
                    CaseAttributeRecord.isRequired = SQLReader.GetByte(isRequiredOrdinal);
                    if (!SQLReader.IsDBNull(CreatedDateOrdinal))
                        CaseAttributeRecord.CreatedDate = SQLReader.GetDateTime(CreatedDateOrdinal);
                    if (!SQLReader.IsDBNull(ModifiedDateOrdinal))
                        CaseAttributeRecord.ModifiedDate = SQLReader.GetDateTime(ModifiedDateOrdinal);

                    CaseAttributeArray.Add(CaseAttributeRecord);
                }

                return CaseAttributeArray;
            }
            catch (System.Data.SqlClient.SqlException err)
            {
                throw err;
            }
            finally
            {
                connDB.Close();
            }
        }

        public bool updateCaseAttribute(int CaseID, IEnumerable<CaseAttribute> CaseAttributeToUpdate)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                //List<StringKVP> CaseAttributeValueList = new List<StringKVP>();
                //List<IntKVP> CaseAttributeTypeList = new List<IntKVP>();
                //List<IntKVP> CaseAttributeisRequiredList = new List<IntKVP>();

                var CaseAttributeValueList = CaseAttributeToUpdate.ToDictionary(ca => ca.CaseAttributeID, ca => ca.CaseAttributeValue);
                var CaseAttributeTypeList = CaseAttributeToUpdate.ToDictionary(ca => ca.CaseAttributeID, ca => ca.CaseAttributeTypeID);
                var CaseAttributeisRequiredList = CaseAttributeToUpdate.ToDictionary(ca => ca.CaseAttributeID, ca => ca.isRequired);

                var CaseAttributeValueTable = DAOHelpers.CreateDataTable(CaseAttributeValueList);
                var CaseAttributeTypeTable = DAOHelpers.CreateDataTable(CaseAttributeTypeList);
                var CaseAttributeisRequiredTable = DAOHelpers.CreateDataTable(CaseAttributeisRequiredList);

                //execute get to check for user existence
                SqlCommand cmd = new SqlCommand("dbo.CaseAttribute_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseID", CaseID);


                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();

                if (SQLReader.Read())
                {
                    SQLReader.Close();

                    //setup delete proc
                    cmd = new SqlCommand("dbo.CaseAttribute_Update", connDB);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CaseID", CaseID);
                    cmd.Parameters.AddWithValue("@CaseAttributeValue_tvp", CaseAttributeValueTable);
                    cmd.Parameters.AddWithValue("@CaseAttributeTypeID_tvp", CaseAttributeTypeTable);
                    cmd.Parameters.AddWithValue("@isRequired_tvp", CaseAttributeisRequiredTable);

                    //execute proc
                    cmd.ExecuteNonQuery();

                    //return success
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (System.Data.SqlClient.SqlException err)
            {
                throw err;
            }
            finally
            {
                connDB.Close();
            }
        }
    }
}