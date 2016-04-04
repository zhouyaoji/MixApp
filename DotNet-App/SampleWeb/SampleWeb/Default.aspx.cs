using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace SampleWeb
{
    public partial class _Default : System.Web.UI.Page
    {
        public string _url = "";
        public string _strResponse = "";

        protected void Page_Load(object sender, EventArgs e)
        {

            Thread.Sleep(100);
            if (Request.QueryString["url"] != null)
            {
                _url = Request.QueryString["url"].ToString();
                HttpWebRequest req = WebRequest.Create(_url) as HttpWebRequest;
                HttpWebResponse response = req.GetResponse() as HttpWebResponse;
                Encoding enc = System.Text.Encoding.GetEncoding(1252);
                StreamReader loResponseStream =
                new StreamReader(response.GetResponseStream(), enc);

                _strResponse = loResponseStream.ReadToEnd();


                loResponseStream.Close();
                response.Close();
            }
            else
            {
                _strResponse = "Default page.....";
            }
            /*            HelloWorldLabel.Text = "Before Button Click";
                        Session["Var1"] = HelloWorldLabel.Text;
                        Test test = new Test();
                        _number = test.CallFunction(3).ToString();
                        _number = test.MethodParam(5).ToString();
                        test.CallFunctionObject(3);
                    }
                    protected void btnSubmit_Click(object sender, EventArgs e)
                    {
                        Session["Var1"] = "Button Clicked";
            */

            
            //HelloWorldLabel.Text = Session["Var1"].ToString() + ", " + _number;
            HelloWorldLabel.Text = Session["Var1"] + ", " + _strResponse;

        }
        
    }
}