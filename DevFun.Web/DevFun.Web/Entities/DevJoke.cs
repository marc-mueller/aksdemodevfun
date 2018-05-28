using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DevFun.Web.Entities
{
    public class DevJoke
    {
        public int Id { get; set; }
        public string Text { get; set; }
        public string Author { get; set; }
        public string ImageUrl { get; set; }
    }
}
