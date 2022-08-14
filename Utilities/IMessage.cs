using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    interface IMessage
    {
        string GetTheMessage();
        List<string> GetElementsOfMessage();
        bool isEnded();
        void Add(string message);
        void Add(List<string> message_list);
        void AddEndOfMessage();
        int GetRequest();

    }
}
