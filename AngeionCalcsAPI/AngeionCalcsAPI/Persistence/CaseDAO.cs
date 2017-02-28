using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AngeionCalcsAPI.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;

namespace AngeionCalcsAPI
{
    public class CaseDAO
    {

        public ArrayList getCaseList()
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                ArrayList CaseArray = new ArrayList();

                //define stored proc with params
                SqlCommand cmd = new SqlCommand("dbo.Case_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;

                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();

                while (SQLReader.Read())
                {

                    Case CaseRecord = new Case();

                    int CaseIDOrdinal = SQLReader.GetOrdinal("CaseID");
                    int CaseCodeOrdinal = SQLReader.GetOrdinal("CaseCode");
                    int CaseNameOrdinal = SQLReader.GetOrdinal("CaseName");
                    int CreatedDateOrdinal = SQLReader.GetOrdinal("CreatedDate");
                    int ModifiedDateOrdinal = SQLReader.GetOrdinal("ModifiedDate");
                    int isDeletedOrdinal = SQLReader.GetOrdinal("isDeleted");

                    CaseRecord.CaseID = SQLReader.GetInt32(CaseIDOrdinal);
                    CaseRecord.CaseCode = SQLReader.GetString(CaseCodeOrdinal);
                    CaseRecord.CaseName = SQLReader.GetString(CaseNameOrdinal);
                    CaseRecord.CreatedDate = SQLReader.GetDateTime(CreatedDateOrdinal);
                    if (!SQLReader.IsDBNull(ModifiedDateOrdinal))
                        CaseRecord.ModifiedDate = SQLReader.GetDateTime(ModifiedDateOrdinal);
                    CaseRecord.isDeleted = SQLReader.GetByte(isDeletedOrdinal);

                    CaseArray.Add(CaseRecord);
                }

                return CaseArray;
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


        public Case getCase(int CaseID)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                //define stored proc with params
                SqlCommand cmd = new SqlCommand("dbo.Case_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseID", CaseID);

                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();

                if (SQLReader.Read())
                {
                    Case CaseRecord = new Case();

                    int CaseIDOrdinal = SQLReader.GetOrdinal("CaseID");
                    int CaseCodeOrdinal = SQLReader.GetOrdinal("CaseCode");
                    int CaseNameOrdinal = SQLReader.GetOrdinal("CaseName");
                    int CreatedDateOrdinal = SQLReader.GetOrdinal("CreatedDate");
                    int ModifiedDateOrdinal = SQLReader.GetOrdinal("ModifiedDate");
                    int isDeletedOrdinal = SQLReader.GetOrdinal("isDeleted");

                    CaseRecord.CaseID = SQLReader.GetInt32(CaseIDOrdinal);
                    CaseRecord.CaseCode = SQLReader.GetString(CaseCodeOrdinal);
                    CaseRecord.CaseName = SQLReader.GetString(CaseNameOrdinal);
                    CaseRecord.CreatedDate = SQLReader.GetDateTime(CreatedDateOrdinal);
                    if (!SQLReader.IsDBNull(ModifiedDateOrdinal))
                        CaseRecord.ModifiedDate = SQLReader.GetDateTime(ModifiedDateOrdinal);
                    CaseRecord.isDeleted = SQLReader.GetByte(isDeletedOrdinal);

                    return CaseRecord;
                }
                else
                {
                    return null;
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


        public int createCase(Case caseToCreate)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);

            try
            {
                connDB.Open();

                //define stored proc with params
                SqlCommand cmd = new SqlCommand("dbo.Case_Add", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseCode", caseToCreate.CaseCode);
                cmd.Parameters.AddWithValue("@CaseName", caseToCreate.CaseName);

                //execute proc and return identity
                var CaseID = cmd.ExecuteScalar().ToString();

                //return identity value from proc execution
                return Convert.ToInt32(CaseID);
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


        public bool updateCase(int CaseID, Case CaseToUpdate)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                //execute get to check for user existence
                SqlCommand cmd = new SqlCommand("dbo.Case_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseID", CaseID);


                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();

                if (SQLReader.Read())
                {
                    SQLReader.Close();

                    //setup delete proc
                    cmd = new SqlCommand("dbo.Case_Update", connDB);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CaseID", CaseID);
                    cmd.Parameters.AddWithValue("@CaseCode", CaseToUpdate.CaseCode);
                    cmd.Parameters.AddWithValue("@CaseName", CaseToUpdate.CaseName);

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

        public bool deleteCase(int CaseID)
        {
            System.Data.SqlClient.SqlConnection connDB;
            connDB = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            try
            {
                connDB.Open();

                //execute get to check for user existence
                SqlCommand cmd = new SqlCommand("dbo.Case_Get", connDB);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CaseID", CaseID);

                //execute proc and return identity
                SqlDataReader SQLReader = cmd.ExecuteReader();



                if (SQLReader.Read())
                {
                    SQLReader.Close();

                    //setup delete proc
                    cmd = new SqlCommand("dbo.Case_Delete", connDB);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CaseID", CaseID);

                    //execute proc and return identity
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