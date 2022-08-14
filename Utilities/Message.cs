using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Message : IMessage
    {
        private string _message;
        private bool _ended;
        private int _type;

        public Message(string entire_message)
        {
            _message = entire_message;
            List<string> elements = new List<string>();
            elements = this.GetElementsOfMessage();

            
            _type = Int32.Parse(elements.First());
            _ended = true;
        }
        public Message(int type)
        {
            _message = type.ToString();
            _type = type;
            _ended = false;
        }
        public void Add(string message)
        {
            if (_ended)
                return;
            if (_message.Length.Equals(0))
                _message += message;
            else
                _message += Utilities.Utility._MESSAGE_SEPARATOR + message;
        }

        public void Add(List<string> message_list)
        {
            foreach(string m in message_list)
            {
                this.Add(m);
            }
            this.AddEndOfMessage();
        }

        public void AddEndOfMessage()
        {
            _message += Utilities.Utility._MESSAGE_SEPARATOR;
            _message += Utilities.Utility._END_OF_MESSAGE;
            _ended = true;
        }

        public List<string> GetElementsOfMessage()
        {
            List<string> elements = new List<string>();

            string[] stringDelimiters = new string[] { Utility._MESSAGE_SEPARATOR, Utility._END_OF_MESSAGE };

            string []elements_list = _message.Split(stringDelimiters, StringSplitOptions.RemoveEmptyEntries);

            foreach(string item in elements_list)
            {
                elements.Add(item);
            }

            return elements;
        }

        public string GetTheMessage()
        {
            return _message;
        }

        public bool isEnded()
        {
            return _ended;
        }

        public int GetRequest()
        {
            return _type;
        }
    }
}
