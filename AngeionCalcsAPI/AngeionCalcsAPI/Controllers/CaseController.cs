using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using AngeionCalcsAPI.Models;
using System.Collections;

namespace AngeionCalcsAPI.Controllers
{
    public class CaseController : ApiController
    {
        /// <summary>
        /// List all cases
        /// </summary>
        /// <returns></returns>
        // GET: api/Case
        public ArrayList Get()
        {
            CaseDAO CaseListDAO = new CaseDAO();
            return CaseListDAO.getCaseList();
        }

        /// <summary>
        /// Get a specific Case
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        // GET: api/Case/5
        public Case Get(int id)
        {
            CaseDAO CaseRecordDAO = new CaseDAO();
            Case CaseRecord = CaseRecordDAO.getCase(id);

            if (CaseRecord == null)
            {
                throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound));
            }

            return CaseRecord;
        }

        /// <summary>
        /// Create a Case
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        // POST: api/Case
        public HttpResponseMessage Post([FromBody]Case value)
        {
            CaseDAO CaseRecordDAO = new CaseDAO();
            int CaseID;

            //execute save method and return identity
            CaseID = CaseRecordDAO.createCase(value);
            value.CaseID = CaseID;

            //create response header
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created);
            response.Headers.Location = new Uri(Request.RequestUri, String.Format("Case/{0}", CaseID));

            //return response header
            return response;
        }

        /// <summary>
        /// Update a Case
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        // PUT: api/Case/5
        public HttpResponseMessage Put(int id, [FromBody]Case value)
        {
            CaseDAO CaseRecordDAO = new CaseDAO();
            bool recordExisted = false;

            recordExisted = CaseRecordDAO.updateCase(id, value);

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

        /// <summary>
        /// Delete a Case (sets deleted flag in DB)
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        // DELETE: api/Case/5
        public HttpResponseMessage Delete(int id)
        {
            CaseDAO CaseRecordDAO = new CaseDAO();
            bool recordExisted = false;

            recordExisted = CaseRecordDAO.deleteCase(id);

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
    }
}