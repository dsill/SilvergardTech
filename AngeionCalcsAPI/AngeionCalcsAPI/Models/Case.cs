using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AngeionCalcsAPI.Models
{
    /// <summary>
    /// Case Class
    /// </summary>
    public class Case
    {
        public int CaseID { get; set; }
        public String CaseCode { get; set; }
        public String CaseName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int isDeleted { get; set; }
    }
}