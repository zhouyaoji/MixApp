using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace SampleWeb
{
    public class Test
    {
        public Object oNumber;
        public int iNumber = 0;
        public int CallFunction(int a)
        {
            Thread.Sleep(50);
            iNumber = a;
            return iNumber;
        }

        public int MethodParam(int a)
        {
            Thread.Sleep(50);
            iNumber = a;
            return iNumber;
        }

        public Onumber CallFunctionObject(int a)
        {
            Thread.Sleep(50);
            var oNumber = new Onumber(a.ToString());
            return oNumber;
        }
    }

    public class Onumber 
    {
        private string value;
        public Onumber(string str)
        {
            value = str;
        }

        public string Value()
        {
            return value;
        }
    }
}