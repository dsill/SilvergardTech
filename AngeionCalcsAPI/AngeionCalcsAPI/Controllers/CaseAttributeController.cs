using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using AngeionCalcsAPI.Models;
using System.Collections;
using Newtonsoft.Json;
using System.Data;
using System.Data.SqlClient;
using AngeionCalcsAPI.Helpers;
using System.Web.Http.ModelBinding;

namespace AngeionCalcsAPI.Controllers
{

    public class CaseAttributeController : ApiController
    {
        // GET: api/CaseAttribute
        //public IEnumerable<string> Get()
        //{
        //    return new string[] { "value1", "value2" };
        //

        // GET: api/CaseAttribute/5
        public ArrayList Get(int id)
        {
            CaseAttributeDAO CaseAttributeRecordDAO = new CaseAttributeDAO();
            ArrayList CaseAttributeList = CaseAttributeRecordDAO.getCaseAttributeList(id);

            if (CaseAttributeList.Count == 0)
            {
                throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound));
            }

            return CaseAttributeList;
        }

        //POST: api/CaseAttribute
        //public void Post([FromBody]string value)
        //{
        //}

        //PUT: api/CaseAttribute/5
        public HttpResponseMessage Put(int id, [FromBody]IEnumerable<CaseAttribute> CaseAttributeList)
        {
            CaseAttributeDAO CaseAttributeRecordDAO = new CaseAttributeDAO();
            bool recordExisted = false;

            //List<CaseAttribute> CaseAttributeList = new List<CaseAttribute>();

            recordExisted = CaseAttributeRecordDAO.updateCaseAttribute(id, CaseAttributeList);

            HttpResponseMessage response;

            if (recordExisted)
            {
                response = Request.CreateResponse(HttpStatusCode.NoContent);
            }
            else
            {
                response = Request.CreateResponse(HttpStatusCode.NotFound);
            }

            return response;
        }

        //DELETE: api/CaseAttribute/5
        //public void Delete(int id)
        //{
        //}
    }
}
