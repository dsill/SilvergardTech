using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLToolkit.Mapping;
using System.Security.Principal;

namespace AngeionCalcsAPI.Models
{
    public class IntKVP
    {
        public int ID { get; set; }
        public int Value { get; set; }
    }

    public class StringKVP
    {
        public int ID { get; set; }
        public String Value { get; set; }
    }

    public class CaseAttribute
    {
        public int CaseID { get; set; }
        public int CaseAttributeID { get; set; }
        public String CaseAttributePrompt { get; set; }
        public int CaseAttributeTypeID { get; set; }
        public Byte isBool { get; set; }
        public Byte isVisible { get; set; }
        public int ParentCaseAttributeID { get; set; }
        public String CaseAttributeTypeName { get; set; }
        public String CaseAttributeValue { get; set; }
        public Byte isRequired { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
    }

    public class CaseAttributeList
    {
        public IEnumerable<CaseAttribute> CaseAttributeListItem { get; set; }
    }

}